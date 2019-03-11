/**
* @createdby        :   Teertha prasad 
* @createddate      :   25/08/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   07/09/2016
* @description      :   Class Used In Activation_Payment for upserting Activation Payments
*                       AND for navigating between Tabs.
**/ 

public class Act_Payment_Component_Controller extends Act_Base_component_controller {
    
    public List<Activation_subscriber__c> lstActivationSubscriber {get; set;}
    public List<Activation_Order__c> lstActivationOrder {get; set;}
    
    public String parentContainer {get; set;}
    
    public Payment_Profile__c objPaymentProfile {get; set;} // input fields to insert payment profile and customer profile
    public Payment_Profile__c objPaymentProfilePrimary {get; set;} // primary output payment profile field
    public Payment_Profile__c objPaymentProfileSecondary {get; set;} // secondary output payment profile field
    
    CountryStateMethods objCountryStateMethods = new CountryStateMethods(); //Helper Class to load Country ans relevent State
    public list<SelectOption> CountriesList = new list<SelectOption>();      
    public list<SelectOption> StatesList = new list<SelectOption>();
    
    public string selectedTab {get; set;} // Current Tab Id
    public String ActivationOrderId {get; set;} // Current Activation Order Id
    private String strActivationContact; // Selected Activation Contact Record
    
    public Map<String, List<String>> mapXmlNodeValue {get; set;} // Parse Response and store it in this Map
    public boolean isSkipValidation {get; set;}
    
    // To get creditcard Information
    public transient string strCreditCardNumber;
    public transient string strCreditCardCVV;
    public transient string strMonth;
    public transient string strYear;
    private static Integer intYearRange = 6; // Can be taken from custom setting
    
    public list<SelectOption> lstMonths{
        get{
            lstMonths = New list<SelectOption>();
            lstMonths.add(new SelectOption('', '--mm--'));
            for(Integer i=1; i<=12; i++){
                String strval =string.valueof(i+100).right(2);
                lstMonths.add(new SelectOption(strval, strval));
            }
            return lstMonths;
        }
        set;
    }
    
    public list<SelectOption> lstYears{
        get{
            lstYears = New list<SelectOption>();
            lstYears.add(new SelectOption('', '--yyyy--'));
            for(Integer i=0; i<=intYearRange; i++){
                Integer Year = Date.Today().Year();
                String strval =string.valueof(Year+i);
                lstYears.add(new SelectOption(strval, strval));
            }
            return lstYears;
        }
        set;
    }
    
    public Boolean boolPopup {get; set;}  // Show/Hide Error popup
    public String strErrorCode {get; set;} // Error Code after XML parsing 
    public String strErrorMsg {get; set;}  // Error Message after XML parsing 
    public Boolean boolIsShowPrimary {get; set;} // Primary Credit card readonly block
    public Boolean boolIsShowSecondary {get; set;}// Secondary Credit card readonly block
    
    // Email with Attachment Variables
    public Transient String  strAttachmentBody {get; set;}
    public Transient String  strAttachmentName {get; set;}
    public Transient String  strAttachmentType {get; set;}
    
    public Attachment objOrderAttachment  {
        get {
            List<Attachment> lstOrderAttach = [SELECT ID, ParentId, Body, ContentType, Name FROM Attachment WHERE ParentId =: ActivationOrderId LIMIT 1];
            return (lstOrderAttach.size() == 0 ? New Attachment() : lstOrderAttach[0]);
        } 
        set;
    }
    
    /** Constructor - Start **/
    public Act_Payment_Component_Controller(){
        ActivationOrderId = ApexPages.currentPage().getParameters().get('order');
        strActivationContact = ApexPages.currentPage().getParameters().get('conActID');
        lstActivationOrder = New List<Activation_Order__c>();
        lstActivationOrder= [SELECT Id,Payment_Method__c,
                             (SELECT id,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c,Bill_To_Corporate__c,
                              Pay_from_sub_account_invoices__c,Pay_from_corporate_account_summary__c,Bill_to__c,Existing_Credit_Terms__c
                              FROM Activation_Subscribers__r)
                             FROM Activation_Order__c 
                             WHERE Id=:ActivationOrderId LIMIT 1];
        lstActivationSubscriber = New List<Activation_Subscriber__c>();
        if(lstActivationOrder.size()>0){
            lstActivationSubscriber = lstActivationOrder[0].Activation_Subscribers__r;
        }

        objPaymentProfileSecondary = New Payment_Profile__c();
        objPaymentProfilePrimary = New Payment_Profile__c();
        CountryStateMethods objCountryStateMethods = new CountryStateMethods();
        CountriesList = objCountryStateMethods.setupCountryPicklist();
        StatesList = objCountryStateMethods.setupStatesPicklist();
        objPaymentProfile = (strActivationContact !=null && strActivationContact != '') ? readActivationContact(strActivationContact) : New Payment_Profile__c();

        boolPopup = false;
        boolIsShowPrimary = false;
        boolIsShowSecondary = false;
        for(Customer_Profile__c objCustomerProfile :[SELECT Id, Name,(SELECT Id,First_Name__c,Primary_Credit_Card__c,Card_Type__c,Expiration_Date__c,Last_Name__c,Credit_Card_Number__c,Customer_Profile__r.Customer_Profile_Id__c FROM Payment_Profiles__r) FROM Customer_Profile__c WHERE Activation_Order__c =: ActivationOrderId LIMIT 1]){
            for(Payment_Profile__c objPaymentProfile1 : objCustomerProfile.Payment_Profiles__r){
                if(objPaymentProfile1.Primary_Credit_Card__c == true){
                    boolIsShowPrimary = true;
                    objPaymentProfilePrimary = objPaymentProfile1;
                }else{
                    boolIsShowSecondary = true;
                    objPaymentProfileSecondary = objPaymentProfile1;
                }
            }
        }
        strAttachmentBody = '';
        strAttachmentType = '';
        strAttachmentName = '';
        list<Activation_Order__c> lstForSkipValidation = [SELECT Id,Activation_Type__c FROM Activation_Order__c WHERE id =: ActivationOrderId and Activation_Type__c = 'Activation on behalf of Customer' and CreatedById =: UserInfo.getUserId()];
        if(lstForSkipValidation.size() > 0)
            isSkipValidation = true;
    }
    /** Constructor - End **/
    
    //Getters and Setters
    public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    
    public void componentCountryChangeHandler(){
        StatesList = objCountryStateMethods.CountryChangeHandler(objPaymentProfile.Country__c, objPaymentProfile.State_Province_Territory__c);
    }
    
    public void componentStateChangeHandler(){
    }
    
    //"Read only" getters... always return null!
    public string getstrCreditCardNumber(){return null;}
    public string getstrCreditCardCVV(){return null;}
    public string getstrMonth(){return null;}
    public string getstrYear(){return null;}
    //custom setters....
    public void setstrCreditCardNumber(string value){
        strCreditCardNumber = value;
    }
    public void setstrCreditCardCVV(string value){
        strCreditCardCVV = value;
    }
    public void setstrMonth(string value){
        strMonth = value;
    }
     public void setstrYear(string value){
        strYear = value;
    }

    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/08/2016
    * @description          :   updateSubscriber Method.
    *                           update Activation Subscriber BillTo values.
    * @return               :   pagereference
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public pageReference updateSubscriber(){
        updateSubscriberonly();
        return gototab();
    }
    
     /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/08/2016
    * @description          :   updateSubscriberonly Method.
    *                           update Activation Subscriber BillTo values.
    * @return               :   pagereference
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public pageReference updateSubscriberonly(){
        if(lstActivationSubscriber.size()>0){
            if(ApexPages.currentPage().getParameters().get('existingcreditterms') != null && ApexPages.currentPage().getParameters().get('existingcreditterms') != ''){
                Boolean boolexistingcreditterms = Boolean.valueOf(ApexPages.currentPage().getParameters().get('existingcreditterms'));
                lstActivationSubscriber[0].Existing_Credit_Terms__c = boolexistingcreditterms;
            }
            if(lstActivationSubscriber[0].Bill_to__c == 'Corporate'){
                lstActivationSubscriber[0].Pay_from_corporate_account_summary__c = True;
                lstActivationSubscriber[0].Pay_from_sub_account_invoices__c = False;
                lstActivationSubscriber[0].Bill_To_Corporate__c = True;
            }
            else{
                lstActivationSubscriber[0].Pay_from_corporate_account_summary__c = False;
                lstActivationSubscriber[0].Pay_from_sub_account_invoices__c = True;
                lstActivationSubscriber[0].Bill_To_Corporate__c = False;
            }
            update lstActivationSubscriber;
            string selectedType = ApexPages.currentPage().getParameters().get('selectedType');
            system.debug('selectedType'+selectedType);
            if(selectedType != null && selectedType != '' && lstActivationOrder.size()>0){
                lstActivationOrder[0].Payment_Method__c = selectedType;
                update lstActivationOrder;
            }
        }
        return null;
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   25/06/2016
    * @description          :   readActivationContact Method.
    *                           Load Selected Activation Contact on edit layout And used in component.
    *                           If nothing is selected, new initialization of Payment Profile.
    * @return               :   Payment_Profile__c, object - selected Payment Profile 
    * @invoke               :   From construction
    **/
    public Payment_Profile__c readActivationContact(String strActivationContact){
        if(strActivationContact!=null && strActivationContact !=''){
            objPaymentProfile = New Payment_Profile__c();
            for(Activation_Contact__c objActivationContact : 
                [SELECT id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,
                 Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,
                 Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c 
                 FROM Activation_Contact__c  WHERE  id=:strActivationContact]){
                     objPaymentProfile.First_Name__c = objActivationContact.First_Name__c;
                     objPaymentProfile.Last_Name__c = objActivationContact.Last_Name__c;
                     objPaymentProfile.Email__c =  objActivationContact.Email__c;
                     objPaymentProfile.Company__c =  objActivationContact.Account__c;
                     objPaymentProfile.Phone__c =  objActivationContact.Primary_Phone__c;
                     objPaymentProfile.Country__c = objActivationContact.Country__c;
                     objPaymentProfile.State_Province_Territory__c = objActivationContact.State__c;
                 }
        }
        componentCountryChangeHandler();
        return objPaymentProfile;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   08/06/2016
    * @description          :   goToTab Method.
    *                           To update Activation status and navigate next Or Previous
    *                           tab based on component 'selectedTab' param 
    * @return               :   pageReference
    * @invoke               :   From updateSubscriber Method
    **/
    public pageReference gototab(){
        pageReference returnPage = ApexPages.currentPage();      //unfortunately, this returns the whole view state!
        actStatus.Account_Setup_Active_Tab__c = selectedTab;
        update actStatus;
        returnPage.getParameters().clear();                      //BUT! we can just clear that stuff out...
        returnPage.getParameters().put('order', ActivationOrderId);     //add the order ID
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   testcallouts Method.
    *                           redirect method calls based on boolIsShowPrimary value
    * @return               :   void
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public void testcallouts(){
        boolPopup = false;
        if(!boolIsShowPrimary)
            testPrimarycallouts();
        else 
            testSecondarycallouts(); 
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   testPrimarycallouts Method.
    *                           Primary Credit card Customer profile and payment profile API calls
    * @return               :   void
    * @invoke               :   From testcallouts Method
    **/
    private void testPrimarycallouts(){
        
        hvk.Authorize_API_callouts util = new hvk.Authorize_API_callouts();
        string refId = 'refId';  // transaction reference Id - returned with response
        
        //Create Customer Profile using Authorize_API_callouts.customerProfile Class
        hvk.Authorize_API_callouts.customerProfile objCustomerProfile = new hvk.Authorize_API_callouts.customerProfile();
        objCustomerProfile.setmerchantCustomerId(ActivationOrderId);
        objCustomerProfile.setDescription(objPaymentProfile.Company__c);
        objCustomerProfile.setemail(objPaymentProfile.Email__c);
        
        hvk.Authorize_API_callouts.paymentProfile objPaymentProfileAPI = paymentProfile();
        
        //Add Payment PRofile to list (required by createCustomerProfileRequest method)
        list<hvk.Authorize_API_callouts.paymentProfile> ppList = new list<hvk.Authorize_API_callouts.paymentProfile>();
        ppList.add(objPaymentProfileAPI);
        
        //Make the callout!
        HttpResponse response = util.createCustomerProfileRequest(refId, 'liveMode', objCustomerProfile, ppList);
        
        Dom.Document xmlDOC = response.getBodyDocument();
        readXMLResponse(xmlDOC);
    }
    
     /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   testSecondarycallouts Method.
    *                           Secondary Credit card Based on Customer profile Id Create payment profile API calls
    * @return               :   void
    * @invoke               :   From testcallouts Method
    **/
    private void testSecondarycallouts(){
        
        //Create Customer Payment Profile
        hvk.Authorize_API_callouts util = new hvk.Authorize_API_callouts();
        string refId = 'refId';  // transaction reference Id - returned with response
        string custProfId = objPaymentProfilePrimary.Customer_Profile__r.Customer_Profile_Id__c;  //well known Customer Profile ID, obviously this needs to be the **CORRECT** Customer Profile Id
        
        hvk.Authorize_API_callouts.paymentProfile objPaymentProfileAPI = paymentProfile();
        
        //Make the callout!
        HttpResponse response = util.createCustomerPaymentProfileRequest(refId, 'liveMode', custProfId, objPaymentProfileAPI);
        
        Dom.Document xmlDOC = response.getBodyDocument();
        readXMLResponse(xmlDOC);  
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   paymentProfile Method.
    *                           Created Authorize.Net payment profile
    * @return               :   hvk.Authorize_API_callouts.paymentProfile
    * @invoke               :   From testPrimarycallouts Method AND testSecondarycallouts Method  
    **/
    private hvk.Authorize_API_callouts.paymentProfile paymentProfile(){
        
        //Create Payment Profile from the top down in 4 steps
        //Step 1) Create Payment Profile wrapper using Authorize_API_callouts.paymentProfile Class 
        hvk.Authorize_API_callouts.paymentProfile objPaymentProfileAPI = new hvk.Authorize_API_callouts.paymentProfile();
        
        //Step 2) Create Payment wrapper using Authorize_API_callouts.payment Class
        hvk.Authorize_API_callouts.payment objPayment = new hvk.Authorize_API_callouts.payment();
        //Add payment to paymentProfile...
        objPaymentProfileAPI.payment = objPayment;
        
        //Step 3) Create Credit Card wrapper using Authorize_API_callouts.creditCard Class
        hvk.Authorize_API_callouts.creditCard objCreditCard = new hvk.Authorize_API_callouts.creditCard();
        objCreditCard.setCardNumber(strCreditCardNumber.trim());
        String strCreditCardExDate = strMonth.trim()+'/'+strYear.trim();
        objCreditCard.setExpirationDate(strCreditCardExDate);
        objCreditCard.setCardCode(strCreditCardCVV.trim());
        //Add Credit Card to Payment...
        objPayment.creditCard = objCreditCard;
        
        //Step 4) Create Bill To wrapper using Authorize_API_callouts.billTo Class
        hvk.Authorize_API_callouts.billTo objBillTo = new hvk.Authorize_API_callouts.billTo();
        objBillTo.setFirstName(objPaymentProfile.First_Name__c);
        objBillTo.setLastName(objPaymentProfile.Last_Name__c);
        objBillTo.setCompany(objPaymentProfile.Company__c);
        objBillTo.setAddress(objPaymentProfile.Address__c);
        objBillTo.setCity(objPaymentProfile.City__c);
        objBillTo.setState(objPaymentProfile.State_Province_Territory__c);
        objBillTo.setZip(objPaymentProfile.Postal_Zip_Code__c);
        objBillTo.setCountry(objPaymentProfile.Country__c);
        objBillTo.setPhoneNumber(objPaymentProfile.Phone__c);
        //objBillTo.setFaxNumber('(401)555-1213');
        //Add billTo to paymentProfile...
        objPaymentProfileAPI.billTo = objBillTo;
        
        //DONE! (payment.bankAccount not supported)
        return objPaymentProfileAPI;
    }
    
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   readXMLResponse Method.
    *                           mapXmlNodeValue MAP to store all Nodes 
    * @return               :   void
    * @param                :   Dom.Document
    * @invoke               :   From testPrimarycallouts Method AND testSecondarycallouts Method  
    **/  
    private void readXMLResponse(Dom.Document xmlDOC){
        mapXmlNodeValue = New  Map<String, List<String>>();
        strErrorCode='';
        strErrorMsg = '';
        Map<String, List<String>> mapXmlNodeValue1 = New  Map<String, List<String>>();
        for(DOM.XMLNode xmlnodeobj:xmlDOC.getRootElement().getChildren()){ 
            if(!mapXmlNodeValue1.containsKey(xmlnodeobj.getName())){
                mapXmlNodeValue1.put(xmlnodeobj.getName(), New List<String>{xmlnodeobj.getText()});
            }
            else{
                mapXmlNodeValue1.get(xmlnodeobj.getName()).add(xmlnodeobj.getText());
            }
            
            mapXmlNodeValue = loadChilds(xmlnodeobj);
        }
        mapXmlNodeValue.putAll(mapXmlNodeValue1);
        if(!(mapXmlNodeValue.isEmpty()) && mapXmlNodeValue.get('resultCode') != null && mapXmlNodeValue.get('resultCode')[0] != 'Error'){
            saveprofiles();
        }else{
            boolPopup = true;
            strErrorCode= mapXmlNodeValue.get('code') != null ? mapXmlNodeValue.get('code')[0] : '';
            strErrorMsg = mapXmlNodeValue.get('text') != null ? mapXmlNodeValue.get('text')[0] : '';
        }
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   Dom.Document Method.
    *                           mapXmlNodeValue MAP to store all Nodes 
    * @return               :   Map<String, List<String>>
    * @param                :   DOM.XMLNode
    * @invoke               :   From readXMLResponse Method  
    **/  
    private Map<String, List<String>> loadChilds(DOM.XMLNode xmlnode){
        for(Dom.XMLNode child : xmlnode.getChildElements()){
            if(Child.getName() != null){
                if(!mapXmlNodeValue.containsKey(Child.getName())){
                    mapXmlNodeValue.put(Child.getName(), New List<String>{child.getText()});
                }
                else{
                    mapXmlNodeValue.get(Child.getName()).add(child.getText());
                }
            }
            loadChilds(child);
        }
        return mapXmlNodeValue;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   30/06/2016
    * @description          :   saveprofiles Method.
    *                           Save Customer Profile and Payment Profiles to Database If there is no error in Response 
    * @return               :   pagereference
    * @invoke               :   From readXMLResponse Method  
    **/  
    @TestVisible
    private pagereference saveprofiles(){
        List<Customer_Profile__c> lstCustomerProfile = New List<Customer_Profile__c>();
        lstCustomerProfile = [SELECT Id, Name, Contact__c,Merchant_Profile__c,Activation_Order__c,Billing_Account__c FROM Customer_Profile__c WHERE Activation_Order__c =: ActivationOrderId LIMIT 1];
        List<String> lstResponseString = New List<String>();
        if(lstCustomerProfile.size() ==0){
            Customer_Profile__c objCustomerProfile = New Customer_Profile__c();
            objCustomerProfile.Activation_Order__c = ActivationOrderId;
            objCustomerProfile.Customer_Profile_Id__c =  mapXmlNodeValue.get('customerProfileId')[0];
            insert objCustomerProfile;
            objPaymentProfile.Customer_Profile__c = objCustomerProfile.Id;
            objPaymentProfile.Primary_Credit_Card__c = true;
            lstResponseString = mapXmlNodeValue.get('string') != null ? mapXmlNodeValue.get('string')[0].split(',') : New List<String>();
        }else{
            objPaymentProfile.Customer_Profile__c = lstCustomerProfile[0].Id; 
            lstResponseString = mapXmlNodeValue.get('validationDirectResponse') != null ? mapXmlNodeValue.get('validationDirectResponse')[0].split(',') : New List<String>();
        }
        
        for(Integer i =0; i<lstResponseString.size(); i++){
            String strValue = lstResponseString[i]; 
            if(strValue != null && strValue.length() == 8 && strValue.startsWith('XXXX') && strValue.right(4).isNumeric()){
                objPaymentProfile.Credit_Card_Number__c = strValue;
                if(lstResponseString.size() >= i+1 && lstResponseString[i+1] != null){
                    objPaymentProfile.Card_Type__c = lstResponseString[i+1];
                }
            }
        }   
        
        // wrong approach, we should map from the response. But From response we are not getting this date value!!
        objPaymentProfile.Expiration_Date__c = strMonth.trim()+'/'+strYear.trim(); 
        objPaymentProfile.Payment_Profile_Id__c = mapXmlNodeValue.get('numericString') != null ? mapXmlNodeValue.get('numericString')[0] : (mapXmlNodeValue.get('customerPaymentProfileId') != null ? mapXmlNodeValue.get('customerPaymentProfileId')[0] : 'Error') ; 
        insert objPaymentProfile;
        return null;
    }
    
  
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   01/09/2016
    * @description          :   orderStatusUpdate Method.
    *                           To update Activation Order Status To 'Submitted'
    * @return               :   pagereference
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public pagereference orderStatusUpdate(){
        Activation_Order__c objActivationOrder = [SELECT Id, Name, Order_Status__c FROM Activation_Order__c WHERE Id=:ActivationOrderId];
        if(objActivationOrder != null && objActivationOrder.Order_Status__c != 'Submitted'){
            objActivationOrder.Order_Status__c = 'Submitted';
            update objActivationOrder;
        }
        return null;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   01/09/2016
    * @description          :   accountsListView Method.
    *                           Redirect page to Accounts List View
    * @return               :   pagereference
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public pagereference accountsListView(){
        pageReference returnPage = new PageReference('/apex/ActivationAccountsPage');
        returnPage.setRedirect(true);                            //this causes the constructors to run again...
        return returnPage;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   07/09/2016
    * @description          :   uploadCreditAttachment Method.
    *                           To upload Credit Attachment 
    * @return               :   pagereference
    * @invoke               :   From button action method of Activation_Payment component
    **/
    public pagereference uploadCreditAttachment(){
        Attachment objAttachment = New Attachment();
        if(objOrderAttachment.Id != null)
            delete objOrderAttachment;
        objAttachment.Body = EncodingUtil.base64Decode(strAttachmentBody);
        objAttachment.ParentId = ActivationOrderId; //lstActivationSubscriber.size()>0 ? lstActivationSubscriber[0].Id : ActivationOrderId;
        objAttachment.ContentType = strAttachmentType;
        objAttachment.Name = strAttachmentName;
        insert objAttachment;
        return null;
    }
}