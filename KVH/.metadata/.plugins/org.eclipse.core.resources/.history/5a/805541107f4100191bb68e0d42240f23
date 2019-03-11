@RestResource(urlMapping='/V1/subscriptions/*')
global without sharing class REST_subscriptions  {

    private static string loadQueryString() {
        string s = 'SELECT Id, Name, Asset__r.Name, Asset_Account_Vessel__c, ';
        s += 'SBQQ__Account__r.Name, SBQQ__Contract__r.Billing_Account__c, ';
        s += 'SBQQ__Contract__r.Billing_Account__r.Billing_Account_ID__c, ';
        s += 'SBQQ__Product__r.Name, SBQQ__Product__r.Catalog_Display_Name__c, SBQQ__Product__r.Data_Rate_Plan__c, ';
        s += 'Status__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name, ';
        //HTSSF-332
        s += 'SBQQ__Product__r.Amount_Free__c, SBQQ__Product__r.Allowance_Units__c, ';
        s += 'SBQQ__Product__r.Overage_Alert_Default__c, SBQQ__Product__r.Overage_Alerts_Units__c, ';
        s += 'SBQQ__Product__r.Airtime_Rate_Plan_Type__c, ';
        //HOTFIX MP=2834
        s += 'Traffic_Identifier__c, ';
        //HTSSF-335 
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.download_cir__c, ';
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.in_bmc_download_mir__c, ';
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.in_bmc_upload_mir__c, ';
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.out_bmc_download_mir__c, ';
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.out_bmc_upload_mir__c, ';
        s += 'SBQQ__Product__r.HTS_Subscriber_Plan__r.upload_cir__c, ' ;
        //HTSSF-355
        s += 'SBQQ__TerminatedDate__c, ';
        s += 'SBQQ__Contract__r.Billing_Account__r.Billing_Cycle__c ';
        s += 'FROM SBQQ__Subscription__c ';
        return s;
    }

    @HttpGet
    global static SBQQ__Subscription__c[] doGet() {
        string queryString1 = loadQueryString();
        system.debug(queryString1);
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.statusCode = 200; //optomistic initialization.....

        List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
        String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String idSearch = req.params.get('customernumber');
        String assetName = req.params.get('asset');
        //TRY wrapper starts here...
        if (identifier.left(3) == 'a6k') {  //direct Id Lookup
            subs = Database.query(queryString1 + 'WHERE Id = \'' + identifier + '\'');
            if (subs.size()==0){
                res.statusCode = 404;
                system.debug('no such subscriptions');
            }

        }else if (identifier.left(6) == 'search') { //search for Subscriptions by Billing Account ID or Asset.Name
            String whereClause = '';
            if(idSearch != null && assetName != null){
              //both in WHERE clause
              whereClause = 'WHERE Asset__r.Name = \'' + assetName + '\'';
              whereClause += ' AND SBQQ__Contract__r.Billing_Account__r.Billing_Account_ID__c = \'' + idSearch + '\'';

            } else if(assetName != null){
                //asset name in WHERE clause
                whereClause = 'WHERE Asset__r.Name = \'' + assetName + '\'';

            } else if (idSearch != null){
                //external account number in where search
                whereClause = 'WHERE SBQQ__Contract__r.Billing_Account__r.Billing_Account_ID__c = \'' + idSearch + '\'';

            }
            subs = Database.query(queryString1 + whereClause);
            if (subs.size()==0){
                res.statusCode = 404;
                system.debug('no associated subscriptions');
            } //end of search logic...

        } else {
            res.statusCode = 400;
            system.debug('no such subscriptions');
        }
        return subs;
    }
}