public class ProductAmazon_RestClass {
    public boolean ProductAmazon_RestMethod(string binaryString, String folderName, String filename) {
        //Get custom setting
        List<AmazonS3_Integration__c> amaIn = new List<AmazonS3_Integration__c>();
        amaIn = AmazonS3_Integration__c.getall().values();
        boolean checkFlag = false;
        if (amaIn.size() > 0 && binaryString != null && binaryString != '') {
            String key = amaIn[0].Key__c;
            String secret = amaIn[0].Secret__c;
            
            String formattedDateString = Datetime.now().formatGMT('EEE,   dd MMM yyyy HH:mm:ss z');
            String bucketname = amaIn[0].Bucketname__c;
            String host = amaIn[0].Host__c;
            String method = 'PUT';
            String contenttype = 'application/json';
            //Request starts
            HttpRequest req = new HttpRequest();
            req.setMethod(method);
            req.setEndpoint('https://' + bucketname + '.' + host + '/' + folderName + '/' + filename );
            req.setHeader('Host', bucketname + '.' + host);
            req.setTimeout(120000);
            req.setHeader('Content-Length', string.valueOf(binaryString.length()));
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-Type', contenttype);
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('Date', formattedDateString);
            //req.setHeader('ACL', 'public-read');
            req.setBody(binaryString);
            String stringToSign = method + '\n\n' + contenttype + '\n' + formattedDateString + '\n/' + bucketname + '/' + folderName + '/' + filename;
            String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
            String signed = createSignature(stringToSign, secret);
            String authHeader = 'AWS' + ' ' + key + ':' + signed;
            req.setHeader('Authorization', authHeader);
            Http http = new Http();
            try {
                //Execute web service call
                HTTPResponse res = http.send(req);
                System.debug('RESPONSE STRING: ' + res.toString());
                System.debug('RESPONSE STATUS: ' + res.getStatus());
                System.debug('STATUS_CODE: ' + res.getStatusCode());
                if (res.getStatusCode() == 200)
                    checkFlag = true;
                else{
                    ModificationJSON_Helper.wrapperBatchError wrap = new ModificationJSON_Helper.wrapperBatchError();
                    wrap.className = 'ProductAmazon_RestClass.ProductAmazon_RestMethod';
                    wrap.errorType = 'Rest Callout';
                    wrap.errorList = res.toString();
                    ModificationJSON_Helper.sendMailToAdmin(wrap);
                }
                
            } catch (System.CalloutException ae) {
                system.debug('AWS Service Callout Exception: ' + ae);
                ModificationJSON_Helper.wrapperBatchError wrap = new ModificationJSON_Helper.wrapperBatchError();
                wrap.className = 'ProductAmazon_RestClass.ProductAmazon_RestMethod';
                wrap.errorsWrapper = ae;
                wrap.errorType = 'Rest Callout';
                ModificationJSON_Helper.sendMailToAdmin(wrap);
            }
        }
        return checkFlag;
    }
    
    public string createSignature(string canonicalBuffer, String secret) {
        string sig;
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(canonicalBuffer), blob.valueof(secret));
        sig = EncodingUtil.base64Encode(mac);
        return sig;
    }
}