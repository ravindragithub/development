public without sharing class RequestAQuoteClass {
    @AuraEnabled
    public static Map<String, Object> getInformation(String AccountId, String ProductID) {
        Map<String, Object> resultsMap = new Map<String, Object>();
        List<Product_Market_Sector__c> marketSectors = new List<Product_Market_Sector__c>();
        marketSectors = Database.query('SELECT Market__c, Sector__c, Product_Line__c, Product_Series__c, Catalog_Display_Name__c FROM Product_Market_Sector__c WHERE Product__c = \'' + ProductID + '\' AND Display_Product__c = true');
        system.debug(marketSectors);
        String product = marketSectors[0].Catalog_Display_Name__c;
        String market = marketSectors[0].Market__c;
        String sector = marketSectors[0].Sector__c;
        String productLine = marketSectors[0].Product_Line__c;
        String productSeries = marketSectors[0].Product_Series__c;
        List<Account> accounts = new List<Account>();
        String accountName = '';
        String accountStreet = '';
        String accountCity = '';
        String accountState = '';
        String accountZip = '';
        String accountCountry = '';
        DefaultAccounts__c kvhDefaultAccount = DefaultAccounts__c.getInstance('KVH_Official_Internal_Contacts');
        accounts = Database.query('SELECT Name, ShippingAddress, Partner_Portal_Main_Contact__c FROM Account WHERE Id = \'' + AccountId + '\''); 
        if (accounts.size() == 0){
            List<Contact> contacts = new List<Contact>();
            contacts = Database.query('SELECT Name, MailingAddress, AccountId FROM Contact WHERE Id = \'' + AccountId + '\''); 
            resultsMap.put('contactId', contacts[0].Id);
            resultsMap.put('accountId', contacts[0].AccountId);
            accountName = contacts[0].Name;
            accountStreet = contacts[0].MailingAddress.getStreet();
            accountCity = contacts[0].MailingAddress.getCity();
            accountState = contacts[0].MailingAddress.getState();
            accountZip = contacts[0].MailingAddress.getPostalCode();
            accountCountry = contacts[0].MailingAddress.getCountry();
        }else{
            if (kvhDefaultAccount.Account_ID__c == accounts[0].Id){
                accountName = 'KVH Industries Inc.';
            }else{
                accountName = accounts[0].Name;
            }
            resultsMap.put('accountId', accounts[0].Id);
            resultsMap.put('contactId', accounts[0].Partner_Portal_Main_Contact__c);
            accountStreet = accounts[0].ShippingAddress.getStreet();
            accountCity = accounts[0].ShippingAddress.getCity();
            accountState = accounts[0].ShippingAddress.getState();
            accountZip = accounts[0].ShippingAddress.getPostalCode();
            accountCountry = accounts[0].ShippingAddress.getCountry();
        }
        resultsMap.put('product', product);
        resultsMap.put('productLine', productLine);
        resultsMap.put('productSeries', productSeries);
        resultsMap.put('market', market);
        resultsMap.put('sector', sector);
        resultsMap.put('accountName', accountName);
        resultsMap.put('accountStreet', accountStreet);
        resultsMap.put('accountCity', accountCity);
        resultsMap.put('accountState', accountState);
        resultsMap.put('accountZip', accountZip);
        resultsMap.put('accountCountry', accountCountry);
        return resultsMap;
    }
    
    @AuraEnabled
    public static String insertQuoteRequested( String salutation, String firstName, String lastName, String email, string companyName, String phoneNumber, String country, String state, String comments, String productId, String product, String accountId, String contactId, String searchOption, String company, String market, String sector) {
        
        try{
            Map<String, KVH_Countries__mdt> countryMap = New Map<String, KVH_Countries__mdt>();
            for(KVH_Countries__mdt mCountry: [SELECT Label, IsoCode_2__c FROM KVH_Countries__mdt]){
                countryMap.put(mCountry.IsoCode_2__c.toUpperCase(),mCountry);
            }
            if (countryMap.containsKey(country.toUpperCase())){
                country = countryMap.get(country.toUpperCase()).Label;
            }
            if(String.isNotBlank(state)){
                Map<String, KVH_States__mdt> stateMap = New Map<String, KVH_States__mdt >();
                for(KVH_States__mdt mState: [SELECT Label, FullIsoCode__c FROM KVH_States__mdt ]){
                    stateMap.put(mState.FullIsoCode__c.toUpperCase(),mState);
                }
                if (state != null && stateMap.containsKey(state.toUpperCase())){
                    state = stateMap.get(state.toUpperCase()).Label;
                }else{
                    state = '';//zip code was probally submitted but the quote object does not have that field
                }
            }
            Quote_Request__c quote = new Quote_Request__c();
            quote.First_Name__c = firstName;
            quote.Salutation__c = salutation;
            quote.Last_Name__c = lastName;
            quote.Email__c = email;
            quote.Phone__c = phoneNumber;
            quote.Country__c = country;
            quote.State__c  = state;
            quote.Company_Name__c = companyName;
            
            if (searchOption.equals('WhereToBuy')){
                quote.Type__c = 'Sales Request';
            }else{
                quote.Type__c = 'Service Request';
            }
            quote.Comments__c  =  comments;
            quote.Product_Interest__c = productId;
            quote.Partner_Account__c = accountId;
            quote.Representative__c = contactId;
        	String contactQuery = 'SELECT ID FROM Contact WHERE Email = \'' + email + '\'';
            List<Contact> contact = database.query(contactQuery);
            if (contact.size() == 0){
                Lead newLead = new Lead();
                newLead.LeadSource = 'RFQ';
                newLead.Status = 'Passed_to_Partner';
                newLead.Salutation = salutation;
                newLead.Phone = phoneNumber;
                newLead.Email = email;
                newLead.FirstName = firstName;
                newLead.LastName = lastName;
                newLead.Lead_Type__c = 'Customer';
                newLead.Market__c = market;
                newLead.Market_Sector__c = sector;
                newLead.Description = comments;
                newLead.Product_Interest__c = product;
                newLead.mkto2__Inferred_Country__c = country;
                if(companyName == null){
                    newLead.Company = firstName + ' ' + lastName;
                }
                else{
                    newLead.Company = companyName;
                }
                
                insert newLead;
                quote.New_Lead__c = newLead.Id;	
                System.debug('New Lead Entered');
            }else{
                quote.Found_Contact__c = contact[0].Id;
            }
            insert quote;
            System.debug('New Quote Added');
            System.debug('Success');
            return 'Success';
        }
        catch(Exception ex){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'sfsupport@kvh.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Where To Buy Failure');
            mail.setSenderDisplayName('Salesforce Support');
            mail.setReplyTo('sfsupport@kvh.com');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('Salutation: ' + salutation + ',' + 'First Name: ' + firstName + ',' + 'Last Name: ' + lastName + ',' + 'email: ' + email + ',' + 
                                  'phoneNumber: ' + phoneNumber + ',' + 'Country: ' + country + ',' + 'State: ' + state + ',' + 'Product Id: ' + productId + ',' + 
                                  'Account Id: ' + accountId +  ',' + 'Contact Id: ' + contactId);
            mail.setHtmlBody('<p>' +'Salutation: ' + salutation + ',' + 'First Name: ' + firstName + ',' + 'Last Name: ' + lastName + ',' + 'email: ' + email + ',' + 
                             'Phone Number: ' + phoneNumber + ',' + 'Country: ' + country + ',' + 'State: ' + state + ',' + 'Product Id: ' + productId + ',' + 
                             'Account Id: ' + accountId +  ',' + 'Contact Id: ' + contactId  + '</p>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return 'Failure';
        }
    }
}