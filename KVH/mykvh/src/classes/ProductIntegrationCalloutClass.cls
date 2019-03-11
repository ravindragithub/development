public class ProductIntegrationCalloutClass {
    public static HttpResponse getInfoFromExternalService() {
        string bodyStr = '"{ \"Product\" : [ { \"Id\" : \"01t2D0000002i4OQAQ\", \"Catalog_Display_Name__c\" : \"Test\", \"Catalog_Long_Description__c\" : \"<strike><u><i><b>Testing....</b></i></u></strike>\", \"ProductCode\" : \"012a0000001WFd2\", \"Display_Product__c\" : \"Yes\", \"IsActive\" : true, \"Product_Line1__c\" : \"Compasses\", \"Product_Series__c\" : \"Europe\", \"Retired__c\" : true, \"Retired_Date__c\" : \"2018-05-30\", \"LastModifiedDate\" : \"2018-04-03T09:56:52.000Z\" }, { \"Id\" : \"01t1B000004V4vtQAC\", \"Catalog_Display_Name__c\" : \"TracPhone V7 HTS\", \"Catalog_Long_Description__c\" : \"\", \"ProductCode\" : \"\", \"Display_Product__c\" : \"Yes\", \"IsActive\" : true, \"Product_Line1__c\" : \"Satellite Communications\", \"Product_Series__c\" : \"mini-VSAT Broadband\", \"Retired__c\" : false, \"Retired_Date__c\" : \"\", \"LastModifiedDate\" : \"2018-04-01T08:43:37.000Z\",  } ] }"';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://kvh-product-data-sandbox.s3.us-east-1.amazonaws.com/Product/Product.json');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(bodyStr);
        HttpResponse res = http.send(request);
        return res;
    }
}