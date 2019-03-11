public class ProductDoc_ModificationJSON_Helper {
    public static Map<string, string> ProductDocModificationJSONMethod(List<sObject> sObjectlist, string masterObjectName, ContentVersion existingCV, Map <Id, List<sObject>> productMSList, Map <Id, List<Content_Type__c>> contentTypeNewList) {
        Map<string, string> outputJSONMap = new Map<string, string>();
        string masterObjectAPIName = '';
        if (masterObjectName == 'Public-Documents') {
            masterObjectAPIName = 'Prod_Documents__c';
        }
        set<Id> existingIds = new set<Id>();
        set<Id> amazonIds = new set<Id>();
        set<Id> deletedIds = new set<Id>();
        for (sObject temp : sObjectlist) {
            SObject newRec = temp;
            existingIds.add(string.valueof(newRec.get('Id')));
        }
        //Retrieve the JSON file from content to JSON string
        String afterblob = EncodingUtil.base64Encode(existingCV.VersionData);
        blob finalblob = EncodingUtil.base64Decode(afterblob);
        string retriveJSON = finalblob.toString();
        Map<String, Object> rootValue = (Map<String, Object>)JSON.deserializeUntyped(retriveJSON);
        //End
        //Get Map of API name vs type
        Map<string, string> fieldNameAPIMap = new Map<string, string>();
        fieldNameAPIMap = ProductAmazonJSONGeneratorHelper.getSchemaLabelAPIMap(masterObjectAPIName);
        //End
        List<Object> lstProducts = (List<Object>)rootValue.get(masterObjectName);
        system.debug(lstProducts.size() + '==lstProducts==' + lstProducts);
        system.debug(sObjectlist.size() + '==sObjectlist==' + sObjectlist);
        system.debug(productMSList.size() + '==productMSList==' + productMSList);
        List<sObject> updatedModifiledScope = new List<sObject>();
        List<sObject> updatedMainScope = new List<sObject>();
        Map <Id, List<sObject>> updatedTaxonomy = new Map <Id, List<sObject>>();
        Map <Id, List<Content_Type__c>> productDocContentTypeMap = new Map <Id, List<Content_Type__c>>();
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
        string checkContRec = '';

        for (sObject temp : sObjectlist) {
            boolean checkModifiedRec = false;
            boolean checkMainRec = true;
            SObject newRec = temp;

            Map<String, Object> fieldsToValue = temp.getPopulatedFieldsAsMap();
            if (amazonAttributesMap.containsKey(string.valueof(newRec.get('Id')))) {
                system.debug(string.valueof(newRec.get('Id')) + '====****====');
                string isCheckSystem = '';
                string isCheckAmazon = '';
                Map<String, Object> customerAttributes = (Map<String, Object>)amazonAttributesMap.get(string.valueof(newRec.get('Id')));
                if (
                    boolean.valueOf(newRec.get('KVH_com__c')) == true &&
                    boolean.valueOf(newRec.get('Active__c')) == true &&
                    string.valueOf(newRec.get('File_Access__c')) == 'Public'
                )
                    isCheckSystem = 'true';
                else if (
                    boolean.valueOf(newRec.get('KVH_com__c')) == false ||
                    boolean.valueOf(newRec.get('Active__c')) == false ||
                    string.valueOf(newRec.get('File_Access__c')) == 'Private'
                )
                    isCheckSystem = 'false';
                if (
                    customerAttributes.get('KVH_com__c') == true ||
                    customerAttributes.get('Active__c') == true ||
                    customerAttributes.get('File_Access__c') == 'Public'
                )
                    isCheckAmazon = 'true';
                for (String attributeName : customerAttributes.keyset()) {
                    datetime dateModifed = datetime.valueof(newRec.get('LastModifiedDate'));
                    if (attributeName != 'Market Sector Taxonomy' &&
                            attributeName != 'Content Type Taxonomy' &&
                            attributeName != 'LastModifiedDate') {
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
                        } else if (
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
                        } else if (
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
                    } else if (attributeName == 'Market Sector Taxonomy' ) {
                        SObject[] childList = new SObject[] {};

                        if(productMSList.containskey(string.valueof(newRec.get('Id'))))
                        childList = productMSList.get(string.valueof(newRec.get('Id')));
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
                            //system.debug(amazonProdMS + '===amazonProdMS===');
                            //system.debug(sfdcProdMS + '####sfdcProdMS####');
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
                    } else if (attributeName == 'Content Type Taxonomy') {
                        SObject[] childList = new SObject[] {};

                        if (contentTypeNewList.containskey(string.valueof(newRec.get('Id'))))
                        childList = contentTypeNewList.get(string.valueof(newRec.get('Id')));
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

                                if (string.valueof(childTemp.get('Content_Main_Type__c')) != null)
                                    tempChildMap.put('Content_Main_Type__c', string.valueof(childTemp.get('Content_Main_Type__c')));
                                else
                                    tempChildMap.put('Content_Main_Type__c', '');
                                if (string.valueof(childTemp.get('Content_Sub_Type__c')) != null)
                                    tempChildMap.put('Content_Sub_Type__c', string.valueof(childTemp.get('Content_Sub_Type__c')));
                                else
                                    tempChildMap.put('Content_Sub_Type__c', '');
                                sfdcProdMS.add(String.valueOf(tempChildMap));
                            }
                            //system.debug(amazonProdMS + '===amazonProdMS===');
                            //system.debug(sfdcProdMS + '####sfdcProdMS####');
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
                            productDocContentTypeMap.put(string.valueof(newRec.get('Id')), new List<sObject>(childList));
                        } else if (amazonProdMS.size() > 0) {
                            checkModifiedRec = true;
                            checkMainRec = true;
                        }
                    }
                }
            }  else {
                sObject[] childList = new SObject[] {};
                childList = productMSList.get(string.valueof(newRec.get('Id')));
                updatedTaxonomy.put(string.valueof(newRec.get('Id')), new List<sObject>(childList));
                sObject[] childList2 = new SObject[] {};
                childList2 = contentTypeNewList.get(string.valueof(newRec.get('Id')));
                productDocContentTypeMap.put(string.valueof(newRec.get('Id')), new List<sObject>(childList2));

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
        //Condition 3 : Else if Product is in Master File AND Product is not in SF: # product somehow got deleted
        if (deletedIds.size() > 0 || checkTaxRec == 'empty') {
            sObject newTemp = Schema.getGlobalDescribe().get(masterObjectAPIName).newSObject();
            for (Id tempId : deletedIds) {
                Map<String, Object> customerAttributes = (Map<String, Object>)amazonAttributesMap.get(tempId);
                for (String attributeName : customerAttributes.keyset()) {
                    if (attributeName == 'Id')
                        newTemp.put(attributeName, string.valueof(customerAttributes.get(attributeName)));
                    else if (attributeName == 'KVH_com__c' ||
                             attributeName == 'Active__c')
                        newTemp.put(attributeName, false);
                    else if (attributeName == 'File_Access__c')
                        newTemp.put(attributeName, 'Private');
                }
                system.debug(newTemp + '******');
                updatedModifiledScope.add(newTemp);
            }
        }
        system.debug(updatedModifiledScope.size() + '==updatedModifiledScope==' + updatedModifiledScope);
        system.debug(updatedMainScope.size() + '==updatedMainScope==' + updatedMainScope);
        system.debug(updatedTaxonomy.size() + '==updatedTaxonomy==' + updatedTaxonomy);
        string modifiedString = '';
        string mainString = '';
        string mainStringSFDC = '';
        if (updatedModifiledScope.size() > 0)
            modifiedString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedModifiledScope, masterObjectName, 'amazons3', updatedTaxonomy, productDocContentTypeMap);
        if (modifiedString != '')
            outputJSONMap.put('modifedJSON', modifiedString);
        if (updatedMainScope.size() > 0) {
            mainString = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'amazons3', updatedTaxonomy, productDocContentTypeMap);
            mainStringSFDC = ProductAmazonJSONGeneratorHelper.ProductAmazonIntegration(updatedMainScope, masterObjectName, 'sfdc', updatedTaxonomy, productDocContentTypeMap);
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
}