/***********************************************************************************************************************
 Name: passingXMlValuestoKVH
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to pass XML to "http://www.kvhupdate.com"
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      25/03/2014       Initial Development                                   
***********************************************************************************************************************/

public class passingXMlValuestoKVH
{
    public Static String myValuesToKVHSite(String myXml,boolean stopCallOutForWebservice,String environment)
    {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        if(environment=='production'){
            req.setEndpoint(system.label.KVHUpdateURL_Production);
        }else if(environment=='sandbox'){
            req.setEndpoint(system.label.KVHUpdateURL_Sandbox);
        }
        req.setMethod('POST');
        req.setCompressed(false);
        req.setBody(myXml);
        req.setHeader('Content-Type', 'text/xml');

        try {
        
            if(!stopCallOutForWebservice)
            res = http.send(req);
        } catch(System.CalloutException e) {
            throw e;
        }
        return res.getBody();
    }
}