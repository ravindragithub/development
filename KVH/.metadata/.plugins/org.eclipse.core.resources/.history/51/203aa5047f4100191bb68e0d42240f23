public without sharing class LTEAct_Controller {
     /***********************************************
        Name        :    SaveLTERegistration
        Description :    Method to save the LTE Activation SObject 
    ************************************************/
    @AuraEnabled 
    public static void SaveLTERegistration(LTE_Activation__c updateLTEAct){
        User u = [Select Id,Name,AccountId,Destination__c,Serial_Number__c From User Where Id =: UserInfo.getUserId()];
        if(updateLTEAct.Account__c == null)
        updateLTEAct.Account__c = u.AccountId;
        system.debug('==updateLTEAct==' + updateLTEAct);
        insert updateLTEAct;        
        u.Destination__c = '';
        u.Serial_Number__c = '';
        update u;
    }
    /***********************************************
        Name        :    getCountry
        Description :    Method to get Country List from KVH_Countries__mdt metadata
    ************************************************/
    @AuraEnabled 
    public static List<KVH_Countries__mdt> getCountry(){
        List<KVH_Countries__mdt> countryValues = [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c 
                                                  FROM KVH_Countries__mdt
                                                  WHERE (Enabled__c =: true AND IsObsolete__c =: false)
                                                  ORDER BY TrimmedName__c ASC];
        return countryValues;
    }
    /***********************************************
        Name        :    getStateMap
        Description :    Method to get State Map from KVH_States__mdt metadata based on Country selected in Form
    ************************************************/
    @AuraEnabled 
    public static List<string> getStateMap(string countryCode){
        List<string> stateValues = new List<string>();
        for(KVH_States__mdt tempState : [SELECT Id, CountryIsoCode_2__c,IsoCode__c,TrimmedName__c
                                         FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: countryCode ORDER BY TrimmedName__c ASC])
            stateValues.add(tempState.TrimmedName__c);                           
        
        return stateValues;
    }
    /***********************************************
        Name        :    getContactInfo
        Description :    Method to get Contact Information of the Loggedin USer
    ************************************************/
    @AuraEnabled 
    public static Map<String, Object> getContactInfo(){
        UserInfo.getUserId();
        List<Contact> contactId = new List<Contact>();
        List<User> userInformation = [Select Contact.Id,Serial_Number__c From User Where Id =: UserInfo.getUserId() LIMIT 1];
        if (userInformation.size() > 0){
            system.debug(userInformation.get(0).Contact.Id);
            contactId = [Select Id, Email, Phone, FirstName,MailingCountry,MailingState, LastName, LTE_Antenna_Number__c From Contact Where Id =: userInformation.get(0).Contact.Id LIMIT 1];
        }
        Map<String, Object> returnMap = new Map<String, Object>();
        returnMap.put('email','');
        returnMap.put('mobilePhone','');
        returnMap.put('firstName','');
        returnMap.put('lastName','');
        returnMap.put('serialNumber','');
        returnMap.put('Id','');
        returnMap.put('contact','');
        if (contactId.size() > 0){
            Contact cntct = contactId.get(0);
            returnMap.put('email',cntct.Email);
            returnMap.put('mobilePhone',cntct.Phone);
            returnMap.put('firstName',cntct.FirstName);
            returnMap.put('lastName',cntct.LastName);
            returnMap.put('serialNumber',userInformation[0].Serial_Number__c);
            returnMap.put('Id',cntct.Id);
            returnMap.put('contact',cntct);
            returnMap.put('country',cntct.MailingCountry);
            returnMap.put('state',cntct.MailingState);
        }
        return returnMap;
    }
    /***********************************************
        Name        :    getVesselTypeMap
        Description :    Method to get all Vessel Type data from the salesforce system
    ************************************************/
    @AuraEnabled 
    public static Map<string,Map<string,List<String>>> getVesselTypeMap(){
        Map<string,Map<string,List<String>>> newVesselTypeMap = new Map<string,Map<string,List<String>>>();
        List<Platform_Market_Sector__c> lstPlatformMS = new List<Platform_Market_Sector__c>([SELECT Id,Name, Market__c,
                                                                                             Sector__c, LTE_Vessel_Card__c 
                                                                                             FROM Platform_Market_Sector__c 
                                                                                             ORDER BY Name ASC]);
        for(Platform_Market_Sector__c tempMS : lstPlatformMS){
            if(tempMS.Market__c != null){
                if(newVesselTypeMap.containskey(tempMS.Market__c)){
                    Map<string,List<String>> innerMap = newVesselTypeMap.get(tempMS.Market__c);
                    if(innerMap.containskey(tempMS.Sector__c)){
                        List<String> lstName = innerMap.get(tempMS.Sector__c);
                        lstName.add(tempMS.Name);
                        innerMap.put(tempMS.Sector__c, lstName);
                    } else {
                        innerMap.put(tempMS.Sector__c, new List<String> { tempMS.Name });
                    }
                    if(tempMS.Market__c != null)
                        newVesselTypeMap.put(tempMS.Market__c, innerMap);
                }
                else{
                    Map<string,List<String>> tempMap = new Map<string,List<String>>();
                    if(tempMap.containskey(tempMS.Sector__c)){
                        List<String> lstName = tempMap.get(tempMS.Sector__c);
                        lstName.add(tempMS.Name);
                        tempMap.put(tempMS.Sector__c, lstName);
                    } else {
                        tempMap.put(tempMS.Sector__c, new List<String> { tempMS.Name });
                    }
                    if(tempMS.Market__c != null)
                        newVesselTypeMap.put(tempMS.Market__c, tempMap);
                }   
            }
        }
        return newVesselTypeMap;
    }
}