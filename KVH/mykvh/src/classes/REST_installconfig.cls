@RestResource(urlMapping='/V1/installconfig/*')
global with sharing class REST_installconfig {
    @HttpGet
    //Responds to an HttpGet naturally... 
    global static Install_Config__c[] doGet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Install_Config__c> returnList = new List<Install_Config__c>();                             //declare return list based on Inner Class...
        string identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);    //Get the identifier from the URI...
        system.debug(identifier);
        string IPSearch = req.params.get('ip');                                       //Set the search param from URI (there might not be one...)
        system.debug(IPSearch);
        if (identifier.left(3) == 'a0H'){   //direct record Access
            try{
                returnList = [SELECT Id, Gateway_IP__c, Modem_IP_Address__c, Asset__c, Asset_Product__c, Account_Name__c, RecordTypeId,
                        (SELECT Hubs__c,Id,Inactive_Public_IP__c,Install_Config__c,Name,Private_Static_IP__c,Region__c FROM PC_Static_IPs__r), 
                        (SELECT Account_Name__c,Asset_Name__c,Gateway__c,Id,Inactive__c,Install_Config__c,Modem_IP__c,Name,Region__c,Static_IP_Type__c,Subnet__c FROM Private_Static_IPs__r)
                        FROM Install_Config__c WHERE Id =: identifier];
                if(returnList.size() == 0){
                    system.debug('No rows returned from Query against ' + identifier);
                    res.statusCode = 404;                                               //return 404 and empty list
                }
            } catch (exception e){ res.statusCode = 500; system.debug(e.getMessage()); }     //Something bad happened... Should never get here!
            
        } else if(identifier.left(6) == 'search'){  //execute a search by IP
            system.debug('Execute an IP Install & Config Query against ' + IPSearch);
            try{
                returnList = [SELECT Id, Gateway_IP__c, Modem_IP_Address__c, Asset__c, Asset_Product__c, Account_Name__c, RecordTypeId,
                        (SELECT Hubs__c,Id,Inactive_Public_IP__c,Install_Config__c,Name,Private_Static_IP__c,Region__c FROM PC_Static_IPs__r), 
                        (SELECT Account_Name__c,Asset_Name__c,Gateway__c,Id,Inactive__c,Install_Config__c,Modem_IP__c,Name,Region__c,Static_IP_Type__c,Subnet__c FROM Private_Static_IPs__r)
                        FROM Install_Config__c WHERE Modem_IP_Address__c =: IPSearch];
                if(returnList.size() == 0){
                    system.debug('No rows returned from Query against ' + IPSearch);
                    res.statusCode = 404;                                               //return 404 and empty list
                } else if (returnList.size() > 1){
                    system.debug('Multiple rows returned from Query against ' + IPSearch);
                    res.statusCode = 300;                                               //return 300 and all found records
                }
            } catch (exception e){ res.statusCode = 500; system.debug(e.getMessage()); }     //Something bad happened... Should never get here!
            
        } else {    //bad request
            res.statusCode = 400;
            res.addHeader('Error', 'Record Id Required for GET');
        }
        return returnList;
    }
}