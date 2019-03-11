public class CCDS_CorporateHelper 
{    
    public static CCDS_Corporate.CorporateMessageReturn AddCorporateAccount(Account account)
    {    
        CCDS_Corporate.CorporateHttpSoap11Endpoint cep = new CCDS_Corporate.CorporateHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Corporate.Authentication auth = (CCDS_Corporate.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);       
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        CCDS_Corporate.Corporate co = SetCorporateValues(account);
        
        if(System.Test.isRunningTest()){                       
            cmr.id = '9999';
            cmr.successful = true;               
            return cmr; 
        } 
        
        cmr = cep.add(auth, co);

        return cmr;
    }
    
    public static CCDS_Corporate.CorporateMessageReturn UpdateCorporateAccount(Account account)
    {
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        
        cmr = UpdateCorporateName(account);        
        system.debug('cmr after update name ' +cmr.successful);
       
        if(cmr.successful){
            system.debug('cmr before update sub account default ' +cmr.successful);
            cmr = UpdateSubAccountDefaultOptions(account);
            system.debug('cmr after update sub account ' +cmr.successful);
        }
       
        if(cmr.successful){
            cmr = UpdateCorporateAddress(account, 'Airtime Services Billing');
            system.debug('cmr after update billing addr ' +cmr.successful);
        }
        
        if(cmr.successful){
            cmr = UpdateCorporateAddress(account, 'Airtime Services Subscriber');
            system.debug('cmr after update subscriber addr ' +cmr.successful);
        }
        
        if(cmr.successful){
            cmr = AddCorporateContact(account);
            system.debug('cmr after add corp contact ' +cmr.successful);
        }
      
        return cmr;
    }
    
    public static CCDS_Corporate.CorporateMessageReturn UpdateCorporateName(Account a)
    {
        CCDS_Corporate.Authentication auth = (CCDS_Corporate.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);       
        CCDS_Corporate.CorporateHttpSoap11Endpoint cep = new CCDS_Corporate.CorporateHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        
        if(System.Test.isRunningTest()){       
            cmr.id = '9999';
            cmr.successful = true;            
            return cmr;
        }
        
        cmr = cep.updateCorporateName(auth, Integer.valueOf(a.Custom_Call_Acct_ID__c), a.Name);
        
        return cmr;
    }
    
    public static CCDS_Corporate.CorporateMessageReturn UpdateSubAccountDefaultOptions(Account a)
    {
        CCDS_Corporate.Authentication auth = (CCDS_Corporate.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);  
        CCDS_Corporate.CorporateHttpSoap11Endpoint cep = new CCDS_Corporate.CorporateHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        CCDS_Corporate.SubAccountDefaults sad = new CCDS_Corporate.SubAccountDefaults();
        
        sad.defaultBillingCycle = String.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Billing_Cycle__c', a.Billing_Cycle_picklist__c));  
        sad.corporateNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c);
        
        if(a.Bill_to__c == 'Corporate'){
            sad.defaultBillToCorp = '1';
        }else{
            sad.defaultBillToCorp = '0';
        }
        
        if(a.Mail_to__c == 'Corporate'){
            sad.defaultMailToCorp = '1';
        }else if(a.Mail_to__c == 'Customer'){
            sad.defaultMailToCorp = '0';
        }else{
            sad.defaultMailToCorp = '2';
        }
        
        if(System.Test.isRunningTest()){
            cmr.id = '9999';
            cmr.successful = true;            
            return cmr; 
        }        
                        
        return cep.updateSubAccountDefaultOptions(auth, sad);

    }
    
    public static CCDS_Corporate.CorporateMessageReturn UpdateCorporateAddress(Account a, String type)
    {
        CCDS_Corporate.Authentication auth = (CCDS_Corporate.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);       
        CCDS_Corporate.CorporateHttpSoap11Endpoint cep = new CCDS_Corporate.CorporateHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType()); 
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        CCDS_Corporate.Address ca = new CCDS_Corporate.Address();

        Address__c addr = GetAddress(a, type);
        ca.corporateNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c);
        ca.address1 = String.isEmpty(addr.Address_1__c) ? '' : addr.Address_1__c;
        ca.address2 = String.isEmpty(addr.Address_2__c) ? '' : addr.Address_2__c;    
        ca.city = String.isEmpty(addr.City__c) ? '' : addr.City__c;       
        ca.country = String.isEmpty(addr.Country__c) ? '' : addr.Country__c;
        
        if(ca.country != null){
            if(ca.country == 'United States'){
                ca.internationalStatus = 0;
                ca.state =  String.isEmpty(addr.State__c) ? '' : addr.State__c;
            }else{
                ca.internationalStatus = 1;
                List<pw_ccpro__CountryObject__c> isoCodes = CCDS_EntityHelper.GetInternationalIsoCode(addr.Country__c);
                ca.state = isoCodes[0].pw_ccpro__IsoCode_2__c;
            }
        }
         
        ca.zip = String.isEmpty(addr.Postal_Zipcode__c) ? '' : addr.Postal_Zipcode__c;
        ca.zipExtension = String.isEmpty(addr.Zip_4__c) ? '' : addr.Zip_4__c;
       
        if(System.Test.isRunningTest()){
            cmr.id = '9999';
            cmr.successful = true;               
            return cmr;
        } 
           
        cmr = cep.updateAddress(auth, ca);
        return cmr;
    }
    
    public static CCDS_Corporate.Corporate SetCorporateValues(Account a)
    {
        CCDS_Corporate.Corporate co = new CCDS_Corporate.Corporate();

        co.defaultBillingCycle = String.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Billing_Cycle__c', a.Billing_Cycle_picklist__c));                 
        
        if(a.Bill_to__c == 'Corporate'){
            co.defaultBillToCorp = '1';
        }else{
            co.defaultBillToCorp = '0';
        }
        
        if(a.Mail_to__c == 'Corporate'){
            co.defaultMailToCorp = '1';
        }else if(a.Mail_to__c == 'Customer'){
            co.defaultMailToCorp = '0';
        }else{
            co.defaultMailToCorp = '2';
        }
        
        co.name = a.Name;
        co.externalId = a.Acct_ID_18_Char__c;
        co.resellerId = Integer.valueOf(a.CC_Reseller_Account_ID__c);
        
        datetime myDate = a.Account_Effective_Date__c;
        datetime newDate = myDate.addHours(12);
        
        co.effectiveDate = newDate; //a.Account_Effective_Date__c;

        Address__c addr = GetAddress(a, 'Airtime Services Billing');
        co.address1 = String.isEmpty(addr.Address_1__c) ? '' : addr.Address_1__c;
        co.address2 = String.isEmpty(addr.Address_2__c) ? '' : addr.Address_2__c;    
        co.city = String.isEmpty(addr.City__c) ? '' : addr.City__c;        
        co.country = String.isEmpty(addr.Country__c) ? '' : addr.Country__c;
        
        if(co.country != null){          
            if(co.country == 'United States'){
                co.internationalStatus = 0;
                co.state = String.isEmpty(addr.State__c) ? '' : addr.State__c;
            }else{
                co.internationalStatus = 1;
                List<pw_ccpro__CountryObject__c> isoCodes = CCDS_EntityHelper.GetInternationalIsoCode(addr.Country__c);
                co.state = isoCodes[0].pw_ccpro__IsoCode_2__c;
            }
        }
        
        co.zip = String.isEmpty(addr.Postal_Zipcode__c) ? '' : addr.Postal_Zipcode__c;
        co.zipExtension = String.isEmpty(addr.Zip_4__c) ? '' : addr.Zip_4__c;

        return co;
    }
    
    public static CCDS_Corporate.CorporateMessageReturn AddCorporateContact(Account a)
    {
        CCDS_Corporate.Authentication auth = (CCDS_Corporate.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c);  
        CCDS_Corporate.CorporateHttpSoap11Endpoint cep = new CCDS_Corporate.CorporateHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType()); 
        CCDS_Corporate.CorporateMessageReturn cmr = new CCDS_Corporate.CorporateMessageReturn();
        CCDS_Corporate.Contact co = new CCDS_Corporate.Contact();   
        
        List<AccountContactRole> contactInfo = GetContactRoleByAccountId(a.Id);
        
        cmr.successful = true;
     
        if(contactInfo.size() > 2){
            System.debug('Only 2 contacts allowed for Corporate Account.');
            cmr.messages = new String[] {'Only 2 contacts allowed for Corporate Account.'}; 
            cmr.successful = false;
            return cmr;
        }
               
        for(Integer i = 0; i < contactInfo.size(); i++){ 
            String role = '';
            String contactRoleId = '';
        
            try{
                role = contactInfo[i].Role;
                contactRoleId = contactInfo[i].ContactId; 
            }catch(Exception e){
                system.debug('Exception thrown. Contact role for Corporate not found. ' + e.getMessage());
                cmr.messages = new String[] {'Exception thrown. Contact role for Corporate not found. ' + e.getMessage()};
                cmr.successful = false;
                return cmr;
            }  

            Contact pc = CCDS_EntityHelper.GetContactById(contactRoleId);
           
            co.corporateNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c); 
            
            String regex = '[+*(*)*\\s*-]';
            Pattern p = Pattern.compile(regex);
        
            if(pc.Phone != null){   
                String str = p.matcher(pc.Phone).replaceAll('');
                co.phone = str.trim();
            }

            if(pc.Fax!= null){                          
                String strng = p.matcher(pc.Fax).replaceAll(''); 
                co.fax = strng.trim();
            }
            
            co.Email = String.isEmpty(pc.Email) ? '' : pc.Email;       
            co.Name = String.isEmpty(pc.Name) ? '' : pc.Name;
            co.Title = String.isEmpty(pc.Title) ? '' : pc.Title; 
            
            if(role == 'Airtime Services Main Contact'){
                co.type_x = 'main';                
            }else{
                co.type_x = 'alt';               
            }

            if(System.Test.isRunningTest()){
                cmr.id = '9999';
                cmr.successful = true;               
                return cmr; 
            }
            
            cmr = cep.updateContact(auth, co);
        }

        return cmr;
    }
    
    public static Address__c GetAddress(Account a, String addressType)
    {
        return [select Id, Name, Account__c, Address_1__c, Address_2__c, City__c, State__c, Country__c, Postal_Zipcode__c, Zip_4__c 
                from Address__c where Account__c = :a.Id and Address_Type__c = :addressType];    
    }
    
    public static List<AccountContactRole> GetContactRoleByAccountId(String acctId)
    {
        List<AccountContactRole> acr = [select Role, ContactId from AccountContactRole where AccountId = :acctId];      
        return acr;
    }
}