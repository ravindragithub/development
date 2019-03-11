public class CCDS_EntityHelper 
{
    public static CCDS_Customer.CustomerEntity GetCustomerEntityFromAccount(Account a)
    {
        if(a == null) return null;            
        
        CCDS_Customer.CustomerEntity ce = new CCDS_Customer.CustomerEntity();

        try{
            if(!System.Test.isRunningTest()){
            	ce.externalId = a.Acct_ID_18_Char__c;   
            }           
            if(a.Custom_Call_Acct_ID__c != null){
               ce.customerNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c); 
            }
            if(a.CC_Prospect_Acct_ID__c != null){
               ce.prospectId = Integer.valueOf(a.CC_Prospect_Acct_ID__c);
            }
            if(a.Parent_Acct_CC_ID__c != null){
                ce.corporateNumber = Integer.valueOf(a.Parent_Acct_CC_ID__c);                        	
            }
            
            if(a.Bill_To_Corporate__c){
                ce.billToCorp = 1;
            }else{
                ce.billToCorp = 0;
            }
            
            if(a.Mail_to_Corporate__c){
                ce.mailToCorp = 1;
            }else{
                ce.mailToCorp = 0;
            }   
            
            ce.customerName = a.name;
            ce.residentialBusiness = 'B';            
            ce.corporateParent = false;  
            
            ce.billType = String.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Bill_Type__c',a.Bill_Type__c)).trim();
            //SetFullName(ce); May be needed in the future for residential customers
            
            ce.billingCycle = String.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Billing_Cycle__c',a.Billing_Cycle_picklist__c));
            ce.resellerId = Integer.valueOf(a.CC_Reseller_Account_ID__c);
            ce.orderSource = Global_Variable__c.getInstance('Webtop_OrderSource').value__c;
            ce.entityContacts = GetContacts(a);
            ce.salesOffice = Integer.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Sales_Office__c',a.Revenue_Category__c));
            ce.salesRegion = Integer.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Sales_Region__c',a.KVH_Sales_Office__c));
            ce.salesRep3 = Integer.valueOf(CCDS_BaseHelper.GetWebtopValue('CCDS_Sales_Rep__c',a.Home_Hub__c));             
            ce.addresses = GetAddresses(a);
            
            datetime myDate = a.Account_Effective_Date__c;
        	datetime newDate = myDate.addHours(12);        
        	ce.effectiveDate = newDate;
            
            ce.modified = Datetime.now();
        }catch(Exception e) {
            system.debug('Exception thrown ' + e.getMessage());
            return null;
        }

        return ce;            
    }
    
    public static CCDS_Customer.EntityContact[] GetContacts(Account account)
    {      
        CCDS_Customer.EntityContact MainContact = GetEntityContact(account, 'Airtime Services Main Contact');
        
        return new CCDS_Customer.EntityContact[] {MainContact};
    }
    
    public static CCDS_Customer.CustomerAddress[] GetAddresses(Account account)
    {          
        CCDS_Customer.CustomerAddress Physical = GetAddress(account,1);

        CCDS_Customer.CustomerAddress Billing = GetAddress(account,2);

        return new CCDS_Customer.CustomerAddress[] {Physical, Billing};  
    }
    
    public static CCDS_Customer.EntityContact GetEntityContact(Account a, String role)
    {
        CCDS_Customer.EntityContact ec = new CCDS_Customer.EntityContact();
        List<AccountContactRole> acr = new List<AccountContactRole>();

        if(role == 'Airtime Services Main Contact') ec.contactTypeId = 1;
        
        boolean found = true;
        
        try{
            acr = GetContactRoleByAccountIdAndRole(a.Id, role);       
        }catch(Exception e){  
            ec.name = 'default';
            ec.email = 'default@kvh.com';
            return ec;
        }
        
        if(acr.size() == 0){
        	ec.name = 'default';
            ec.email = 'default@kvh.com';
            return ec;
        }
        
        for(Integer i = 0; i < acr.size(); i++){
            String contactRoleId = acr[i].ContactId;
           
            Contact pc = null;
            
            try{
                pc = [select Name, Email from Contact where AccountId = :a.Id and Id = :contactRoleId];               
            }catch(Exception e){    
            	system.debug('no contact found for contact role id ' +contactRoleId);
                found = false;
        	}
    
            ec.contactType = new CCDS_Customer.ContactType();  
            
            List<CCDS_Entity.EntityContact> entityContacts = GetCCDSContacts(a.Acct_ID_18_Char__c); 
            
            ec.entityContactId = entityContacts[i].entityContactId;
                      
            if(a.Custom_Call_Acct_ID__c != null){
                ec.customerNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c); 
            }        
            if(a.CC_Prospect_Acct_ID__c != null){
                ec.prospectId = Integer.valueOf(a.CC_Prospect_Acct_ID__c);
            } 
            if(found){
                if(pc.Name != null){
                    ec.name = pc.Name;
                }       
                if(pc.Email != null){
                    ec.email = pc.Email;
                } 
            }else{
                ec.email = entityContacts[i].email;       
            	ec.name = entityContacts[i].name;
            }
        }
        
        return ec;                
    }   
    
    public static CCDS_Customer.CustomerAddress GetAddress(Account account, Integer addressType) 
    {        
        CCDS_Customer.CustomerAddress ca = new CCDS_Customer.CustomerAddress();
        ca.addressTypeId = addressType;
        
        Address__c addr = null;
        
        if(addressType == 1){
            addr = GetAddressByType(account.Id, 'Airtime Services Subscriber');
        }else{
            addr = GetAddressByType(account.Id, 'Airtime Services Billing');
            ca.name = String.isEmpty(addr.Attention__c) ? '' : addr.Attention__c;
        }
                
        if(addr == null){
            System.debug('address for account type ' + addressType + ' is == null');
            return null;
        }
        
        if(String.isEmpty(account.Custom_Call_Acct_ID__c)){
            ca.customerNumber = null;
        }else{
            ca.customerNumber = Integer.valueOf(account.Custom_Call_Acct_ID__c);
        }

        if(account.CC_Prospect_Acct_ID__c == null){
            ca.ProspectId = null;
        }else{
        	ca.ProspectId = Integer.valueOf(account.CC_Prospect_Acct_ID__c);
        }
        
        ca.address1 = String.isEmpty(addr.Address_1__c) ? '' : addr.Address_1__c;
        ca.address2 = String.isEmpty(addr.Address_2__c) ? '' : addr.Address_2__c;                         
        ca.city = String.isEmpty(addr.City__c) ? '' : addr.City__c;
        ca.country = String.isEmpty(addr.Country__c) ? '' : addr.Country__c;
        
        if(ca.country != null){
            if(ca.country == 'United States'){
                ca.internationalStatus = 0;
                String temp = String.isEmpty(addr.Address_1__c) ? '' : addr.Address_1__c;
                ca.houseNumber = String.isEmpty(temp) ? '' : temp.substringBefore(' ');
        		ca.streetName = String.isEmpty(temp) ? '' : temp.substringAfter(' ');
                ca.state = String.isEmpty(addr.State_Province_ISO_Code__c) ? '' : addr.State_Province_ISO_Code__c; 
            }else{
                ca.internationalStatus = 1;
                List<pw_ccpro__CountryObject__c> isoCodes = GetInternationalIsoCode(addr.Country__c);
                ca.state = isoCodes[0].pw_ccpro__IsoCode_2__c;
            }
        }
        
        ca.zipCode = String.isEmpty(addr.Postal_Zipcode__c) ? '' : addr.Postal_Zipcode__c;
		ca.zipPlus4 = String.isEmpty(addr.Zip_4__c) ? '' : addr.Zip_4__c;
        
        if (CCDS_CustomerHelper.IsCustomer(account)) {
            SetExistingAddressIDByCustomerNumber(Integer.valueOf(account.Custom_Call_Acct_ID__c), ca);
        }

        return ca;
    }
          
    public static void SetExistingAddressIDByCustomerNumber(Integer customerNumber, CCDS_Customer.CustomerAddress address)
    {
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);          
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.EntityAddressReturn result = new CCDS_Entity.EntityAddressReturn();
            
        if(!System.Test.isRunningTest()){
            result =  ep.getAddressesByCustomerNumber(auth, CustomerNumber);
        }else{    
            CCDS_Entity.AddressContainer ac1 = new CCDS_Entity.AddressContainer();
            ac1.currentAddress = new CCDS_Entity.Address();
            ac1.currentAddress.addressTypeId = 1;
            ac1.currentAddress.addressId = 9999;
                        
            CCDS_Entity.AddressContainer ac2 = new CCDS_Entity.AddressContainer();
            ac2.currentAddress = new CCDS_Entity.Address();
            ac2.currentAddress.addressTypeId = 2;
            ac2.currentAddress.addressId = 9998;
            
            result.addresses = new CCDS_Entity.AddressContainer[] { ac1, ac2 };               
        }
           
        for(CCDS_Entity.AddressContainer ea : result.addresses){
            if(ea.currentAddress.addressTypeId == address.addressTypeId){
              address.addressId = ea.currentAddress.addressId;  
            } 
        }       
    }
    
    public static CCDS_Entity.EntityContactReturn AddCustomerContact(Account a)
    {
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.EntityContact ec = new CCDS_Entity.EntityContact();
        CCDS_Entity.EntityContactReturn ecr = new CCDS_Entity.EntityContactReturn();
        CCDS_Entity.EntityContacts contacts = new CCDS_Entity.EntityContacts(); 
                      
        ecr.successful = true;
                
        ecr = UpdateCustomerContact(a);       
        if(ecr.successful == false){
            return ecr;
        }
        
        List<CCDS_Entity.EntityContact> entityContacts = GetCCDSContacts(a.Acct_ID_18_Char__c);
        
        ecr = DeleteEntityContacts(entityContacts);  
        if(ecr.successful == false){
            return ecr;
        }
         
        String role = '';
       	String contactRoleId = '';
        
        for(Integer x = 0; x < 2; x++){
            if(x == 0){
                role = 'Airtime Service Billing Contact'; 
                ec.contactTypeId = 4;
            }else{
                role = 'Airtime Services Authorized Rep';
                ec.contactTypeId = 11;
            }
            
            List<AccountContactRole> contactInfo = GetContactRoleByAccountIdAndRole(a.Id, role);           
            
            for(Integer i = 0; i < contactInfo.size(); i++){ 
                try{
                    contactRoleId = contactInfo[i].ContactId; 
                }catch(Exception e){
                    system.debug('Exception thrown. Contact role not found. ' + e.getMessage());
                    ecr = new CCDS_Entity.EntityContactReturn();
                    ecr.entityContacts = new CCDS_Entity.EntityContact[]{};
                    ecr.successful = false;
                    return ecr;
                }
                
                Contact pc = GetContactById(contactRoleId);
                
                ec.customerNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c); 
                ec.prospectId = Integer.valueOf(a.CC_Prospect_Acct_ID__c);
                ec.entityContactId = -1;  
                ec.email = String.isEmpty(pc.Email) ? '' : pc.Email;       
                ec.name = String.isEmpty(pc.Name) ? '' : pc.Name;
                ec.title = String.isEmpty(pc.Title) ? '' : pc.Title;   	
 
                String regex = '[+*(*)*\\s*-]';
                Pattern p = Pattern.compile(regex);
                
                if(pc.Phone != null){                 
                    String newPhone = p.matcher(pc.Phone).replaceAll('');        
                    ec.phone1 = newPhone.trim();
                }            
                if(pc.Fax!= null){                 			
                    String newFax = p.matcher(pc.Fax).replaceAll(''); 
                    ec.fax = newFax.trim();
                }
                if(pc.MobilePhone != null){
                    String newCell = p.matcher(pc.MobilePhone).replaceAll(''); 
                    ec.cellphone = newCell.trim();
                }
                
                contacts.entityContacts = new CCDS_Entity.EntityContact[] { ec };
                
                if(!System.Test.isRunningTest()){                   
            		ecr = ep.addEntityContacts(auth, contacts); 
                }    
            }
        }
      
        return ecr;
    }
    
    public static CCDS_Entity.EntityContactReturn UpdateCustomerContact(Account a)
    {
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.EntityContact ec = new CCDS_Entity.EntityContact();
        CCDS_Entity.EntityContactReturn ecr = new CCDS_Entity.EntityContactReturn();
        CCDS_Entity.EntityContacts contacts = new CCDS_Entity.EntityContacts(); 

        List<CCDS_Entity.EntityContact> entityContacts = GetCCDSContacts(a.Acct_ID_18_Char__c); 
        
        String role = '';
        String contactRoleId = '';    
        
        ecr.successful = true;
 
        for(Integer i = 0; i < entityContacts.size(); i++){
            ec.contactTypeId = entityContacts[i].contactTypeId;
            
            if(ec.contactTypeId == 1){
                role = 'Airtime Services Main Contact'; 
            }else if(ec.contactTypeId == 4){
                role = 'Airtime Service Billing Contact'; 
            }else{
                role = 'Airtime Services Authorized Rep';
            }

            List<AccountContactRole> contactInfo = GetContactRoleByAccountIdAndRole(a.Id, role);
            
            try{
                contactRoleId = contactInfo[0].ContactId; 
            }catch(Exception e){
                ecr.entityContacts = new CCDS_Entity.EntityContact[]{};
                ecr.successful = true;
                return ecr;
            }
            
            Contact pc = GetContactById(contactRoleId);

            ec.customerNumber = Integer.valueOf(a.Custom_Call_Acct_ID__c);
            ec.prospectId = Integer.valueOf(a.CC_Prospect_Acct_ID__c);
            ec.entityContactId = entityContacts[i].entityContactId;
            ec.email = String.isEmpty(pc.Email) ? '' : pc.Email;       
            ec.name = String.isEmpty(pc.Name) ? '' : pc.Name;
            ec.title = String.isEmpty(pc.Title) ? '' : pc.Title;
        	ec.address1 = entityContacts[i].address1;
        	ec.city = entityContacts[i].city;       	

            String regex = '[+*(*)*\\s*-]';
            Pattern p = Pattern.compile(regex);
            
            if(pc.Phone != null){                 
                String newPhone = p.matcher(pc.Phone).replaceAll('');        
                ec.phone1 = newPhone.trim();
            }            
            if(pc.Fax!= null){                 			
                String newFax = p.matcher(pc.Fax).replaceAll(''); 
                ec.fax = newFax.trim();
            }
            if(pc.MobilePhone != null){
                String newCell = p.matcher(pc.MobilePhone).replaceAll(''); 
                ec.cellphone = newCell.trim();
            }
            
            contacts.entityContacts = new CCDS_Entity.EntityContact[] { ec };
 
			if(!System.Test.isRunningTest()){               
            	ecr = ep.updateEntityContacts(auth, contacts); 
            }   
        }
  
        return ecr;
    }
    
    public static List<CCDS_Entity.EntityContact> GetCCDSContacts(String externalId)
    {     
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);
        CCDS_Entity.EntityContactReturn result = new CCDS_Entity.EntityContactReturn();
        
        List<CCDS_Entity.EntityContact> entityContacts = new List<CCDS_Entity.EntityContact>();
        
        if(System.Test.isRunningTest()) {   
            CCDS_Entity.EntityContact c = new CCDS_Entity.EntityContact();
            c.entityContactId = 999999999;  
            
            c.ContactType = new CCDS_Entity.ContactType();
            c.ContactType.contactTypeId = 1;
            
            result.entityContacts = new CCDS_Entity.EntityContact[] { c };
            entityContacts.add(c);
            return entityContacts;
        } 

        result = ep.getContactsByExternalId(auth, externalId); 
                
        if(result != null && result.entityContacts.size() > 0) {
            for(CCDS_Entity.EntityContact ec : result.entityContacts){
                if(ec.contactType != null){
                    entityContacts.add(ec); 
                }else{
                    CCDS_Entity.EntityContact c = new CCDS_Entity.EntityContact();
                    
            		c.entityContactId = -1;             
            		c.ContactType = new CCDS_Entity.ContactType();
            
            		result.entityContacts = new CCDS_Entity.EntityContact[] { c };
            		entityContacts.add(c);
                }                
            } 
        }

        return entityContacts;
    }
    
    public static CCDS_Entity.EntityContactReturn DeleteEntityContacts(List<CCDS_Entity.EntityContact> entityContacts)
    {
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);
        CCDS_Entity.EntityContact ec = new CCDS_Entity.EntityContact();
        CCDS_Entity.EntityContactReturn ecr = new CCDS_Entity.EntityContactReturn();
        CCDS_Entity.EntityContacts contacts = new CCDS_Entity.EntityContacts(); 
        
        ecr.successful = true;
        
        if(System.Test.isRunningTest()){
            ec.customerNumber = 9999;
            ec.prospectId = 8888;
            ec.entityContactId = 123456;
            ec.contactTypeId = 1;               
            contacts.entityContacts = new CCDS_Entity.EntityContact[] { ec };

            return ecr;
        }         
        
        for(Integer i = 0; i < entityContacts.size(); i++){
            if(entityContacts[i].contactTypeId != 1){
			    ec.customerNumber = entityContacts[i].customerNumber;
                ec.prospectId = entityContacts[i].prospectId;
                ec.entityContactId = entityContacts[i].entityContactId;
                ec.contactTypeId = entityContacts[i].contactTypeId;
                
                contacts.entityContacts = new CCDS_Entity.EntityContact[] { ec };
                
                ecr = ep.deleteEntityContacts(auth, contacts);
            }
        }
        
        return ecr;    
    } 
    
    public static List<pw_ccpro__CountryObject__c> GetInternationalIsoCode(String country)
    {    
        List<pw_ccpro__CountryObject__c> isoCodes = [Select pw_ccpro__IsoCode_2__c from pw_ccpro__CountryObject__c where name = :country limit 1];
        
        return isoCodes;
    }

    public static Contact GetContactById(String contactId)
    {
        return [select Name, Email, Title, Phone, Fax, MobilePhone from Contact where Id = :contactId];
    } 
        
    public static List<AccountContactRole> GetContactRoleByAccountIdAndRole(String acctId, String role)
    {
        List<AccountContactRole> acr = [select Role, ContactId from AccountContactRole 
                                        where AccountId = :acctId and Role = :role]; 
		
        return acr;
    } 
    
    public static Address__c GetAddressByType(String accountId, String type)
    {
        return [select Account__r.Custom_Call_Acct_ID__c, Account__r.CC_Prospect_Acct_ID__c, Id, Name, Account__c, Address_1__c, Address_Type__c, City__c, Country__c, State__c, 
                Attention__c,Postal_Zipcode__c, State_Province_ISO_Code__c, Address_2__c, Zip_4__c from Address__c where Account__c = :accountId and Address_Type__c =:type];
    }
    
    /* the following code is commented out in case we need it in the near future. If not, it can be deleted.
     * JLW 12/4/2014
     * public static object GetCustomerByCustomerNumber(integer CustomerNumber)
    {
        if(System.Test.isRunningTest()) {
            CCDS_Entity.EntityReturn result = new CCDS_Entity.EntityReturn();
            
            CCDS_Entity.Entity ec = new CCDS_Entity.Entity();
            ec.customerNumber = 9999;
            ec.prospectId = 8888;
            ec.firstName = 'fName';
            ec.lastName = 'lName';
            
            result.entities = new CCDS_Entity.Entity[] { ec };
            result.successful = true;
            return result; 
        }
            
        CCDS_Entity.EntityHttpSoap11Endpoint ep = new CCDS_Entity.EntityHttpSoap11Endpoint(CCDS_BaseHelper.GetEnvironmentType());
        CCDS_Entity.Authentication auth = (CCDS_Entity.Authentication) CCDS_BaseHelper.GetAuthenticationByType(Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c);

        return ep.getByCustomerNumber(auth, CustomerNumber);    
    }

	public static void SetFullName(CCDS_Customer.CustomerEntity ce) //used for Residential customers
    {
        if(ce.residentialBusiness.toUpperCase() == 'R' && String.isNotEmpty(ce.customerName)){
            String name = ce.customerName;           
            ce.firstName = name.substringBefore(' ');
            
            if(name.substringBetween(' ') == null){
                ce.lastName = name.substringAfterLast(' ');  
            }else{
                ce.middleInitial = name.substringBetween(' ');
                
                if(ce.middleInitial.length() > 1){
                    ce.middleInitial = ce.middleInitial.substring(0,1);
                }
                
                ce.lastName = name.substringAfterLast(' '); 
            }
        }
    }
    
    */
}