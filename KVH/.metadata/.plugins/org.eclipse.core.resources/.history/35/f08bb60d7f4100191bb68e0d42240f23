@RESTResource(urlmapping='/V1/billingaccts/*')
global without sharing class REST_BillingAcct {
    
    private static string loadQueryString1(){     //setup query string
        string s = 'SELECT Id, Name, Account__c, Account__r.Name, E_bill_URL__c, Main_Contact__r.Name, Main_Contact__r.Id, '; 
        s += 'Billing_Account_ID__c, Revenue_Category__c, Billing_Cycle__c, Account_Effective_Date__c ';
        s += 'FROM Billing_Account__c ';
        return s;
    }
    @HttpGet
    //Responds to an HttpGet naturally... 
    //Given a Billing Account ID this Class returns the list of platforms and the Billing Account data
    global static Billing_Account__c[] doGet(){
        string queryString1 = loadQueryString1();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //declare return list
        List<Billing_Account__c> BillingAcct = new List<Billing_Account__c>();
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug(identifier);
        String IDSearch = req.params.get('customernumber');
        system.debug(IDSearch);
        if (identifier.left(3) == 'a5s') {  
            Try {
                BillingAcct = Database.query(queryString1 + 'WHERE Id = \'' + identifier + '\'');
                if (BillingAcct.size()==0){
                    res.statusCode = 404;
                    system.debug('no such billing accounts'); }} Catch (Exception e) { res.statusCode = 500; }     //Something bad happened... Should never get here!
            }
        else if(identifier.left(3) == '001') {
            Try{
                BillingAcct = Database.query(queryString1 + 'WHERE Account__c = \'' + identifier + '\'');
                if (BillingAcct.size()==0) {
                    res.statusCode = 404;
                    system.debug('no such billing accounts'); }} Catch (Exception e) { res.statusCode = 500; }     //Something bad happened... Should never get here!

                }
        else if (identifier.left(6) == 'search') {          
                Try {
                BillingAcct = Database.query(queryString1 + 'WHERE Billing_Account_ID__c = \'' + IDSearch + '\'');
                if (BillingAcct.size()==0){
                    res.statusCode = 404;
                    system.debug('no such billing accounts'); }} Catch (Exception e) { res.statusCode = 500; }     //Something bad happened... Should never get here!
            }
        else {
                res.statusCode = 400;
                system.debug('no such billing accounts');
        }
        return BillingAcct;
    }
}