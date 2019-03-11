public class ModificationJSON_Helper {
    public static Map<string, string> ModificationJSONMethod(List<sObject> sObjectlist, string masterObjectName, ContentVersion existingCV) {
        Map<string, string> outputJSONMap = new Map<string, string>();
        string masterObjectAPIName = '';
        if (masterObjectName == 'Products') {
            masterObjectAPIName = 'Product2';
        } else if (masterObjectName == 'Product-Options') {
            masterObjectAPIName = 'SBQQ__ProductOption__c';
        } else if (masterObjectName == 'Product-Features') {
            masterObjectAPIName = 'SBQQ__ProductFeature__c';
        } else if (masterObjectName == 'Product-Attributes') {
            masterObjectAPIName = 'Product_Attribute__c';
        }

        set<Id> existingIds = new set<Id>();
        set<Id> amazonIds = new set<Id>();
        set<Id> deletedIds = new set<Id>();
        for (sObject temp : sObjectlist) {
            SObject newRec = temp;
            existingIds.add(string.valueof(newRec.get('Id')));
        }


        //Get Map of API name vs type
        Map<string, string> fieldNameAPIMap = new Map<string, string>();
        system.debug( '==masterObjectAPIName==' + masterObjectAPIName);
        fieldNameAPIMap = ProductAmazonJSONGeneratorHelper.getSchemaLabelAPIMap(masterObjectAPIName);

        //Retrieve the JSON file from content to JSON string
        String afterblob = EncodingUtil.base64Encode(existingCV.VersionData);
        blob finalblob = EncodingUtil.base64Decode(afterblob);
        string retriveJSON = finalblob.toString();
        Map<String, Object> rootValue = (Map<String, Object>)JSON.deserializeUntyped(retriveJSON);
        //End
        List<Object> lstProducts = (List<Object>)rootValue.get(masterObjectName);
        Map <Id, List<sObject>> updatedTaxonomy = new Map <Id, List<sObject>>();
        system.debug(lstProducts.size() + '==lstProducts==' + lstProducts);
        system.debug(sObjectlist.size() + '==sObjectlist==' + sObjectlist);
        List<sObject> updatedModifiledScope = new List<sObject>();
        List<sObject> updatedMainScope = new List<sObject>();
        Map<String, Object> amazonAttributesMap = new Map<String, Object>();
        DateTime rightNow =  DateTime.now();
        DateTime d36hAgo = rightNow.addHours(-36);
        for (Object customer : lstProducts) {
            Map<String, Object> customerAttributes = (Map<String, Object>)customer;
            amazonAttributesMap.put(string.valueof(customerAttributes.get('Id')), customerAttributes);
            amazonIds.add(string.valueof(customerAttributes.get('Id')));
        }
        for (Id objId : amazonIds) {
            if (!existingIds.contains(objId))
                deletedIds.add(objId);
        }
        string checkTaxRec = '';
        for (sObject temp : sObjectlist) {
            boolean checkModifiedRec = false;
            boolean checkMainRec = true;
            SObject newRec = temp;
            SObject[] childList = new SObject[] {};
            if (masterObjectName == 'Products')
                childList = temp.getSObjects('Product_Markets_Sectors__r');
            Map<String, Object> fieldsToValue = temp.getPopulatedFieldsAsMap();
            if (amazonAttributesMap.containsKey(string.valueof(newRec.get('Id')))) {
                //system.debug(string.valueof(newRec.get('Id')) + '====****====');
                string isCheckSystem = '';
                string isCheckAmazon = '';
                Map<String, Object> customerAttributes = (Map<String, Object>)amazonAttributesMap.get(string.valueof(newRec.get('Id')));
                if (masterObjectName == 'Products') {
                    if (
                        boolean.valueOf(newRec.get('IsActive')) == true &&
                        string.valueOf(newRec.get('Display_Product__c')) == 'Yes'
                    )
                        isCheckSystem = 'true';
                    else if (
                        boolean.valueOf(newRec.get('IsActive')) == false ||
                        string.valueOf(newRec.get('Display_Product__c')) == 'No'
                    )
                        isCheckSystem = 'false';
                    if (
                        customerAttributes.get('Display_Product__c') == 'Yes' ||
                        customerAttributes.get('IsActive') == true
                    )
                        isCheckAmazon = 'true';

                } else if (masterObjectName == 'Product-Options') {
                    if (
                        boolean.valueOf(newRec.get('Configured_Sku_IsActive__c')) == true &&
                        string.valueOf(newRec.get('Configured_Sku_Display_Product__c')) == 'Yes' &&
                        boolean.valueOf(newRec.get('Optional_Sku_IsActive__c')) == true &&
                        string.valueOf(newRec.get('Optional_Sku_Display_Product__c')) == 'Yes' &&
                        boolean.valueOf(newRec.get('Display_in_Catalog__c')) == true
                    )
                        isCheckSystem = 'true';
                    else if (
                        boolean.valueOf(newRec.get('Configured_Sku_IsActive__c')) == false ||
                        string.valueOf(newRec.get('Configured_Sku_Display_Product__c')) == 'No' ||
                        boolean.valueOf(newRec.get('Optional_Sku_IsActive__c')) == false ||
                        string.valueOf(newRec.get('Optional_Sku_Display_Product__c')) == 'No' ||
                        boolean.valueOf(newRec.get('Display_in_Catalog__c')) == false
                    )
                        isCheckSystem = 'false';

                    if (
                        customerAttributes.get('Configured_Sku_IsActive__c') == true ||
                        customerAttributes.get('Configured_Sku_Display_Product__c') == 'Yes' ||
                        customerAttributes.get('Optional_Sku_IsActive__c') == true ||
                        customerAttributes.get('Optional_Sku_Display_Product__c') == 'Yes' ||
                        customerAttributes.get('Display_in_Catalog__c') == true
                    )
                        isCheckAmazon = 'true';
                } else if (masterObjectName != 'Products' && masterObjectName != 'Product-Options') {
                    if (
                        boolean.valueOf(newRec.get('Configured_Sku_IsActive__c')) == true &&
                        string.valueOf(newRec.get('Configured_Sku_Display_Product__c')) == 'Yes'
                    )
                        isCheckSystem = 'true';
                    else if (
                        boolean.valueOf(newRec.get('Configured_Sku_IsActive__c')) == false ||
                        string.valueOf(newRec.get('Configured_Sku_Display_Product__c')) == 'No'
                    )
                        isCheckSystem = 'false';

                    if (
                        customerAttributes.get('Configured_Sku_IsActive__c') == true ||
                        customerAttributes.get('Configured_Sku_Display_Product__c') == 'Yes'
                    )
                        isCheckAmazon = 'true';
                }
                for (String attributeName : customerAttributes.keyset()) {
                    datetime dateModifed = datetime.valueof(newRec.get('LastModifiedDate'));
                    if (attributeName != 'Taxonomy' && attributeName != 'LastModifiedDate' ) {
                        /*
                        system.debug(attributeName + '^^^^attributeName1^^^^^^');
                        system.debug(newRec.get(attributeName)  + '^^^^check value^^^^^^'+customerAttributes.get(attributeName));
                        system.debug((newRec.get(attributeName) != null || customerAttributes.get(attributeName) != '') + '^^^^^^^^^^');
                        system.debug((newRec.get(attributeName) != customerAttributes.get(attributeName)) + '^^^^equals NOT^^^^^^');
                        system.debug((dateModifed > = d36hAgo ) + '^^^^dateModifed^^^^^^');
                        system.debug((isCheckSystem == 'true')  + '^^^^checksystem^^^^^^');*/
                        //Condition 1 : If DisplayProduct == Yes AND IsActive == True AND Modified in last 36 hours AND Modification was made to a field we are sending to S3:
                        if (
                            (newRec.get(attributeName) != null || customerAttributes.get(attributeName) != '') && // Null check in both list value
                            (newRec.get(attributeName) != customerAttributes.get(attributeName)) && // Not equal check
                            (fieldNameAPIMap.get(attributeName) != 'DATE' && fieldNameAPIMap.get(attributeName) != 'DATETIME') && //date or datetime check
                            (dateModifed > = d36hAgo ) && // Last modified in 36hrs check
                            (isCheckSystem == 'true') //given condition check
                        ) {
                            checkModifiedRec = true;
                            checkMainRec = true;
                            system.debug('===First 1st if loop===');
                        }
                        //Condition 1 : For date/datetime fieldsToValue
                        else if (
                            (newRec.get(attributeName) != null || customerAttributes.get(attributeName) != '') && // Null check in both list value
                            (newRec.get(attributeName) != customerAttributes.get(attributeName)) && // Not equal check
                            (fieldNameAPIMap.get(attributeName) == 'DATE' || fieldNameAPIMap.get(attributeName) == 'DATETIME') && //date or datetime check
                            (dateModifed > = d36hAgo ) && // Last modified in 36hrs check
                            (isCheckSystem == 'true') //given condition check
                        ) {
                            Date outputDate;
                            if (customerAttributes.get(attributeName) != '') {
                                string amazonDate = string.valueOf(customerAttributes.get(attributeName));
                                String[] amazonDates = amazonDate.split('-');
                                outputDate = date.newinstance(Integer.valueOf(amazonDates[0]), Integer.valueOf(amazonDates[1]), Integer.valueOf(amazonDates[2]));
                            }

                            if (newRec.get(attributeName) != outputDate) {
                                checkModifiedRec = true;
                                checkMainRec = true;
                                system.debug('===First 2nd if loop===');
                            }
                        }
                        //Condition 2 :(DisplayProduct == No OR IsActive == False) AND Modified in last 36 hours AND in Master file (DisplayProduct == Yes OR IsActive == True):
                        else if (
                            (newRec.get(attributeName) != null || customerAttributes.get(attributeName) != '') && // Null check in both list value
                            (newRec.get(attributeName) != customerAttributes.get(attributeName)) && // Not equal check
                            (fieldNameAPIMap.get(attributeName) != 'DATE' && fieldNameAPIMap.get(attributeName) != 'DATETIME') && //date or datetime check
                            (dateModifed > = d36hAgo ) && // Last modified in 36hrs check
                            (isCheckSystem == 'false' && isCheckAmazon == 'true')//given condition check
                            //given condition check
                        ) {
                            checkModifiedRec = true;
                            checkMainRec = false;
                            system.debug('===First 3rd if loop===');
                        }
                    } else if (attributeName == 'Taxonomy' && childList != null) {

                        set<string> amazonProdMS = new set<string>();
                        set<string> sfdcProdMS = new set<string>();
                        List<Object> tempCustom = (List<Object>)customerAttributes.get(attributeName);
                        for (Object taxstr : tempCustom) {
                            string abc = string.valueof(taxstr);
                            amazonProdMS.add(abc);
                        }
                        if (childList != null) {
                            for (SObject childTemp : childList ) {
                                string conctStr = '';
                                Map<String, String> tempChildMap = new Map<String, String>();

                                if (string.valueof(childTemp.get('Market__c')) != null)
                                    tempChildMap.put('Market__c', string.valueof(childTemp.get('Market__c')));
                                else
                                    tempChildMap.put('Market__c', '');
                                if (string.valueof(childTemp.get('Product_ID__c')) != null)
                                    tempChildMap.put('Product_ID__c', string.valueof(childTemp.get('Product_ID__c')));
                                else
                                    tempChildMap.put('Product_ID__c', '');
                                if (string.valueof(childTemp.get('Product_Line__c')) != null)
                                    tempChildMap.put('Product_Line__c', string.valueof(childTemp.get('Product_Line__c')));
                                else
                                    tempChildMap.put('Product_Line__c', '');
                                if (string.valueof(childTemp.get('Product_Name__c')) != null)
                                    tempChildMap.put('Product_Name__c', string.valueof(childTemp.get('Product_Name__c')));
                                else
                                    tempChildMap.put('Product_Name__c', '');
                                if (string.valueof(childTemp.get('Product_Series__c')) != null)
                                    tempChildMap.put('Product_Series__c', string.valueof(childTemp.get('Product_Series__c')));
                                else
                                    tempChildMap.put('Product_Series__c', '');
                                if (string.valueof(childTemp.get('Sector__c')) != null)
                                    tempChildMap.put('Sector__c', string.valueof(childTemp.get('Sector__c')));
                                else
                                    tempChildMap.put('Sector__c', '');
                                sfdcProdMS.add(String.valueOf(tempChildMap));
                            }
                            system.debug(amazonProdMS + '===amazonProdMS===');
                            system.debug(sfdcProdMS + '####sfdcProdMS####');
                            for (string objId : amazonProdMS) {
                                if (!sfdcProdMS.contains(objId)) {
                                    checkModifiedRec = true;
                                    checkMainRec = true;
                                }
                            }
                            for (string objId : sfdcProdMS) {
                                if (!amazonProdMS.contains(objId)) {
                                    checkModifiedRec = true;
                                    checkMainRec = true;
                                }
                            }
                            updatedTaxonomy.put(string.valueof(newRec.get('Id')), new List<sObject>(childList));
                        } else {
                            checkTaxRec = 'empty';
                        }
                    }
                }
            } else {
                if (childList != null) {
                    set<string> sfdcProdMS = new set<string>();
                    for (SObject childTemp : childList ) {
                        string conctStr = '';
                        Map<String, String> tempChildMap = new Map<String, String>();

                        if (string.valueof(childTemp.get('Market__c')) != null)
                            tempChildMap.put('Market__c', string.valueof(childTemp.get('Market__c')));
                        else
                            tempChildMap.put('Market__c', '');
                        if (string.valueof(childTemp.get('Product_ID__c')) != null)
                            tempChildMap.put('Product_ID__c', string.valueof(childTemp.get('Product_ID__c')));
                        else
                            tempChildMap.put('Product_ID__c', '');
                        if (string.valueof(childTemp.get('Product_Line__c')) != null)
                            tempChildMap.put('Product_Line__c', string.valueof(childTemp.get('Product_Line__c')));
                        else
                            tempChildMap.put('Product_Line__c', '');
                        if (string.valueof(childTemp.get('Product_Name__c')) != null)
                            tempChildMap.put('Product_Name__c', string.valueof(childTemp.get('Product_Name__c')));
                        else
                            tempChildMap.put('Product_Name__c', '');
                        if (string.valueof(childTemp.get('Product_Series__c')) != null)
                            tempChildMap.put('Product_Series__c', string.valueof(childTemp.get('Product_Series__c')));
                        else
                            tempChildMap.put('Product_Series__c', '');
                        if (string.valueof(childTemp.get('Sector__c')) != null)
                            tempChildMap.put('Sector__c', string.valueof(childTemp.get('Sector__c')));
                        else
                            tempChildMap.put('Sector__c', '');
                        sfdcProdMS.add(String.valueOf(tempChildMap));
                    }
                    updatedTaxonomy.put(string.valueof(newRec.get('Id')), new List<sObject>(childList));
                }
                updatedModifiledScope.add(temp);
            }
            //system.debug(checkMainRec + '====(((((*****)))))====' + checkModifiedRec);
            if (checkMainRec && checkTaxRec != 'empty')
                updatedMainScope.add(temp);
            if (checkModifiedRec && checkTaxRec != 'empty')
                updatedModifiledScope.add(temp);
        }
        system.debug(deletedIds.size() + '==deletedIds==' + deletedIds);
        system.debug(amazonIds.size() + '==amazonIds==' + amazonIds);
        system.debug(existingIds.size() + '==existingIds==' + existingIds);
        system.debug(updatedTaxonomy + '####updatedTaxonomy#####');
        //Condition 3 : Else if Product is in Master File AND Product is not in SF: # product somehow got deleted
        if (deletedIds.size() > 0 || checkTaxRec == 'empty') {
            sObject newTemp = Schema.getGlobalDescribe().get(masterObjectAPIName).newSObject();
            for (Id tempId : deletedIds) {
                Map<String, Object> customerAttributes = (Map<String, Object>)amazonAttributesMap.get(tempId);
                for (String attributeName : customerAttributes.keyset()) {
                    if (attributeName == 'Id')
                        newTemp.put(attributeName, string.valueof(customerAttributes.get(attributeName)));
                    else if (attributeName == 'IsActive' ||
                             attributeName == 'Configured_Sku_IsActive__c' ||
                             attributeName == 'Optional_Sku_IsActive__c')
                        newTemp.put(attributeName, false);
                    else if (attributeName == 'Display_Product__c' ||
                             attributeName == 'Configured_Sku_Display_Product__c' ||
                             attributeName == 'Optional_Sku_Display_Product__c')
                        newTemp.put(attributeName, 'No');
                }
                system.debug(newTemp + '******');
                updatedModifiledScope.add(newTemp);
            }
        }

        system.debug(updatedModifiledScope.size() + '==updatedModifiledScope==' + updatedModifiledScope);
        system.debug(updatedMainScope.size() + '==updatedMainScope==' + updatedMainScope);
        string modifiedString = '';
        string mainString = '';
        string mainStringSFDC = '';
        if (updatedModifiledScope.size() > 0) {
            if (updatedTaxonomy != null)
                modifiedString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedModifiledScope, masterObjectName, 'amazons3', updatedTaxonomy,null);
            else
                modifiedString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedModifiledScope, masterObjectName, 'amazons3', null,null);
        }
        if (modifiedString != '')
            outputJSONMap.put('modifedJSON', modifiedString);
        if (updatedMainScope.size() > 0) {
            if (updatedTaxonomy != null) {
                mainString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'amazons3', updatedTaxonomy,null);
                mainStringSFDC = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'sfdc', updatedTaxonomy,null);
            } else {
                mainString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'amazons3', null,null);
                mainStringSFDC = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'sfdc', null,null);

            }
        }
        if (mainString != '') {
            outputJSONMap.put('mainString', mainString);
            outputJSONMap.put('mainStringSFDC', mainStringSFDC);
        } else {
            string tempstring = '{"' + masterObjectName + '" : [ ]}';
            outputJSONMap.put('mainString', tempstring);
            outputJSONMap.put('mainStringSFDC', tempstring);
        }
        //system.debug(outputJSONMap.size()+'==outputJSONMap=='+outputJSONMap);
        //return null;
        return outputJSONMap;
    }
    public static void createContentVersion(string inputJSON, string cvTitle) {
        //Create new Content File same we store in Amazon S3
        ContentVersion cv = new ContentVersion();
        cv.versionData = blob.valueOf(inputJSON);
        cv.Title = cvTitle;
        cv.pathOnClient = cvTitle;
        insert cv;
    }
    public static string getTodayDate() {
        Datetime datetimeToday = Datetime.now();
        Date dateToday = datetimeToday.dateGMT();
        String sMonth = String.valueof(dateToday.month());
        String sDay = String.valueof(dateToday.day());
        if (sMonth.length() == 1) {
            sMonth = '0' + sMonth;
        }
        if (sDay.length() == 1) {
            sDay = '0' + sDay;
        }
        String sToday = String.valueof(dateToday.year()) + '-' + sMonth + '-' + sDay ;
        return sToday;
    }
    public static void sendMailToAdmin(ModificationJSON_Helper.wrapperBatchError wrapperTemp) {
        system.debug(wrapperTemp + '=====wrapperTemp====');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {System.label.UAccount_Share_Report_Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Failure in Product Integration:: ' + wrapperTemp.errorType);
        mail.setUseSignature(false);
        mail.saveAsActivity = false;
        string td1 = '"border:1px solid #1797c0; width=200px;"';
        string htmlBody = '<div ><p>Hi ' + UserInfo.getName()  + ',</p><p>Salesforce completed running <b>Apex Batch Code</b>.</p>';
        htmlBody += '<p>Results:</p>';
        htmlBody += '<center><table style="border:2px solid #1797c0; border-collapse:collapse;">';
        htmlBody += '<tr><td style=' + td1 + '>Class Name</td><td style=' + td1 + '>' + wrapperTemp.className + '</td></tr>';
        htmlBody += '<tr><td style=' + td1 + '>Completed Date</td><td style=' + td1 + '>' + system.now() + '</td></tr>';
        if (wrapperTemp.errorsWrapper != null )
            htmlBody += '<tr><td style=' + td1 + '>Error</td><td style=' + td1 + '>' + wrapperTemp.errorsWrapper + '</td></tr>';
        else
            htmlBody += '<tr><td style=' + td1 + '>Error</td><td style=' + td1 + '>' + wrapperTemp.errorList + '</td></tr>';

        htmlBody += '</table></center>';
        htmlBody += '</div>';
        mail.setHtmlBody(htmlBody);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    public class wrapperBatchError {
        public string className;
        public string errorType;
        public string errorList;
        public Exception errorsWrapper;
    }

}