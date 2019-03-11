public class ProductAmazonJSONGeneratorHelper {
    public static string ProductAmazonIntegration(List<sObject> sObjectlist, string masterObjectLabel, string sourceFile, Map <Id, List<sObject>> taxonomyList, Map <Id, List<Content_Type__c>> contentTypeList) {
        string childObjectName = '';
        string childObjectName2 = '';
        string relationshipField = '';
        string masterObjectAPIName = '';
        string childObjectLabel = '';
        String[] fieldToAddParent;
        String[] fieldToAddChild;
        String[] fieldToAddChild2;
        //Static input Field needs to add in JSON
        if (masterObjectLabel == 'Products') {
            masterObjectAPIName = 'Product2';
            childObjectName = 'Product_Market_Sector__c';
            //childObjectLabel = 'Product Market Sector';
            relationshipField = 'Product_Markets_Sectors__r';
            fieldToAddParent = new String[] {'Id', 'Catalog_Display_Name__c', 'Catalog_Long_Description__c', 'ProductCode',
                                             'Display_Product__c', 'IsActive', 'Product_Line1__c', 'Product_Series__c', 'Retired__c', 'Retired_Date__c', 'LastModifiedDate'
                                            };
            fieldToAddChild = new String[] {'Market__c', 'Sector__c', 'Product_Line__c', 'Product_Series__c', 'Product_Name__c', 'Product_ID__c'};
        } else if (masterObjectLabel == 'Product-Options') {
            masterObjectAPIName = 'SBQQ__ProductOption__c';
            fieldToAddParent = new String[] {'Id', 'SBQQ__ConfiguredSKU__c', 'Configured_Sku_Catalog_Display_Name__c',
                                             'Configured_Sku_Catalog_Long_Description__c', 'Configured_Sku_IsActive__c', 'Configured_Sku_Display_Product__c',
                                             'Optional_Sku_Catalog_Display_Name__c', 'Optional_Sku_Catalog_Long_Description__c', 'Optional_Sku_IsActive__c',
                                             'Optional_Sku_Display_Product__c', 'Display_in_Catalog__c', 'SBQQ__Feature__c', 'Feature_Name__c', 'SBQQ__Number__c', 'KVH_P_N__c',
                                             'Product_ID_18_char__c', 'LastModifiedDate'
                                            };

        } else if (masterObjectLabel == 'Product-Features') {
            masterObjectAPIName = 'SBQQ__ProductFeature__c';
            fieldToAddParent = new String[] {'Id', 'Name', 'SBQQ__ConfiguredSKU__c',  'Configured_Sku_Display_Product__c', 'Configured_Sku_IsActive__c',
                                             'Configured_Sku_Catalog_Display_Name__c', 'Configured_Sku_Catalog_Long_Description__c',
                                             'SBQQ__Number__c', 'LastModifiedDate'
                                            };
        } else if (masterObjectLabel == 'Product-Attributes') {
            masterObjectAPIName = 'Product_Attribute__c';
            fieldToAddParent = new String[] {'Id', 'Name', 'Configured_SKU__c',  'Configured_Sku_Display_Product__c', 'Configured_Sku_IsActive__c',
                                             'Configured_Sku_Catalog_Display_Name__c', 'Configured_Sku_Catalog_Long_Description__c',
                                             'Product_Attribute_Public_Name__c', 'Product_Attribute_Value__c', 'LastModifiedDate'
                                            };
        }
        //Work In progress for Product Document
        else if (masterObjectLabel == 'Public-Documents') {
            masterObjectAPIName = 'Prod_Documents__c';
            childObjectName = 'Product_Market_Sector__c';
            //childObjectLabel = 'Product Market Sector';
            fieldToAddParent = new String[] {'Id', 'Name', 'Title_Display_Name__c', 'Sub_Title__c', 'File_Access__c', 'File_Extension__c',
                                             'Size_Description__c', 'Revision__c', 'Language__c', 'Associated_Content_Types__c', 'Image_URL__c', 'Alternate_Text__c', 'Hosting_URL__c', 'Marketo_URL__c',
                                             'Gated_Document__c', 'Site_Core_URL__c', 'Insertion_Code__c', 'KVH_com__c', 'Active__c', 'Display_HTML_Page__c', 'Html_Field__c',
                                             'Display_Terms_and_Conditions_Page__c', 'Terms_and_Conditions_1__c', 'Sales_Aid__c', 'File_Description__c', 'LastModifiedDate'
                                            };
            fieldToAddChild = new String[] {'Market__c', 'Sector__c', 'Product_Line__c', 'Product_Series__c', 'Product_Name__c', 'Product_ID__c'};
            childObjectName2 = 'Content_Type__c';
            fieldToAddChild2 = new String[] {'Content_Main_Type__c', 'Content_Sub_Type__c'};
        }
        //End
        string inputJSON;
        Map<string, schema.describefieldresult> fieldNameDescribleFieldMap = new Map<string, schema.describefieldresult>();
        Map<string, schema.describefieldresult> fieldNameDescribleFieldMapChild = new Map<string, schema.describefieldresult>();
        Map<string, schema.describefieldresult> fieldNameDescribleFieldMapChild2 = new Map<string, schema.describefieldresult>();
        //For Parent
        if (masterObjectAPIName != '')
            fieldNameDescribleFieldMap = ProductAmazonJSONGeneratorHelper.getSchemaMap(masterObjectAPIName);
        //For Child
        if (childObjectName != '')
            fieldNameDescribleFieldMapChild = ProductAmazonJSONGeneratorHelper.getSchemaMap(childObjectName);
        if (childObjectName2 != '')
            fieldNameDescribleFieldMapChild2 = ProductAmazonJSONGeneratorHelper.getSchemaMap(childObjectName2);
        if (sObjectlist.size() > 0) {
            JSONGenerator gen = JSON.createGenerator(true);
            //Main Array started
            gen.writeStartObject();
            gen.writeFieldName(masterObjectLabel);
            gen.writeStartArray();
            for (sObject prod : sObjectlist) {
                //Each Parent Object Node started
                gen.writeStartObject();
                SObject newRec = prod;
                for (string temp : fieldToAddParent) {
                    if (fieldNameDescribleFieldMap.containsKey(temp)) {
                        string inputstr;
                        if (sourceFile == 'amazons3')
                            inputstr = fieldNameDescribleFieldMap.get(temp).getLabel();
                        else
                            inputstr = fieldNameDescribleFieldMap.get(temp).getName();
                        if (string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'STRING' ||
                                string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'ID') {
                            if (newRec.get(temp) != null )
                                gen.writeStringField(inputstr, string.valueof(newRec.get(temp)));
                            else
                                gen.writeStringField(inputstr, '');
                        } else if (string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'DOUBLE') {
                            if (newRec.get(temp) != null)
                                gen.writeNumberField(inputstr, integer.valueof(newRec.get(temp)));
                            else
                                gen.writeStringField(inputstr, '');
                        } else if (string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'BOOLEAN') {
                            if (newRec.get(temp) != null)
                                gen.writeBooleanField(inputstr, boolean.valueof(newRec.get(temp)));
                            else
                                gen.writeBooleanField(inputstr, false);

                        } else if (string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'DATE') {
                            if (newRec.get(temp) != null)
                                gen.writeDateField(inputstr, date.valueof(newRec.get(temp)));
                            else
                                gen.writeStringField(inputstr, '');
                        } else if (string.valueof(fieldNameDescribleFieldMap.get(temp).getSoapType()) == 'DATETIME') {
                            if (newRec.get(temp) != null)
                                gen.writeDateTimeField(inputstr, datetime.valueof(newRec.get(temp)));
                            else
                                gen.writeStringField(inputstr, '');
                        }
                    }
                }
                SObject[] childList = new SObject[] {};
                if (relationshipField != '' && taxonomyList == null) {
                    childList = prod.getSObjects(relationshipField);
                } else if (taxonomyList != null) {
                    if (taxonomyList.containskey(string.valueof(newRec.get('Id'))))
                        childList = taxonomyList.get(string.valueof(newRec.get('Id')));
                }

                if (childList != null && childList.size() > 0) {
                    if (masterObjectLabel == 'Products')
                        gen.writeFieldName('Taxonomy');
                    if (masterObjectLabel == 'Public-Documents')
                        gen.writeFieldName('Market Sector Taxonomy');
                    gen.writeStartArray();

                    for (SObject prodChild : childList) {
                        SObject newChildRec = prodChild;
                        gen.writeStartObject();
                        for (string tempChild : fieldToAddChild) {
                            if (fieldNameDescribleFieldMapChild.containsKey(tempChild)) {
                                if (newChildRec.get(tempChild) != null)
                                    gen.writeStringField(tempChild, string.valueof(newChildRec.get(tempChild)));
                                else
                                    gen.writeStringField(tempChild, '');
                            }
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    if (contentTypeList != null) {
                        if (contentTypeList.containskey(string.valueof(newRec.get('Id')))) {
                            gen.writeFieldName('Content Type Taxonomy');
                            gen.writeStartArray();
                            for (SObject prodChild : contentTypeList.get(string.valueof(newRec.get('Id')))) {
                                SObject newChildRec = prodChild;
                                gen.writeStartObject();
                                for (string tempChild : fieldToAddChild2) {
                                    if (fieldNameDescribleFieldMapChild2.containsKey(tempChild)) {
                                        if (newChildRec.get(tempChild) != null)
                                            gen.writeStringField(tempChild, string.valueof(newChildRec.get(tempChild)));
                                        else
                                            gen.writeStringField(tempChild, '');
                                    }
                                }
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }

                    }

                }
                gen.writeEndObject();
                //Each Parent Object Node ended
            }
            gen.writeEndArray();
            gen.writeEndObject();
            //Main Array ended
            inputJSON = gen.getAsString();
            //system.debug('===inputJSON==='+inputJSON);
        }
        return inputJSON;
    }
    //Method to return list of id from JSON
    public static set<id> getExistingIds(ContentVersion existingCV, string masterObjectAPIName) {
        String afterblob = EncodingUtil.base64Encode(existingCV.VersionData);
        blob finalblob = EncodingUtil.base64Decode(afterblob);
        string retriveJSON = finalblob.toString();
        set<id> existingId = new set<id>();

        Map<String, Object> rootValue = (Map<String, Object>)JSON.deserializeUntyped(retriveJSON);
        List<Object> lstProducts = (List<Object>)rootValue.get(masterObjectAPIName);
        for (Object customer : lstProducts) {
            Map<String, Object> customerAttributes = (Map<String, Object>)customer;
            for (String attributeName : customerAttributes.keyset()) {
                if (customerAttributes.containskey('Id')) {
                    existingId.add(string.valueof(customerAttributes.get('Id')));
                }
            }
        }
        return existingId;
    }

    //Method to create Map of Field API name v/s Describe Field Result
    public static Map<string, Schema.describefieldresult> getSchemaMap(string sObjectName) {
        Map<string, schema.describefieldresult> fieldNameDescribleFieldMap = new Map<string, schema.describefieldresult>();
        SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult childRec = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldMap = sObjectType.getDescribe().fields.getMap();
        for (Schema.SObjectField sfield : sObjectFieldMap.Values()) {
            schema.describefieldresult dfield = sfield.getDescribe();
            fieldNameDescribleFieldMap.put(dfield.getname(), sfield.getDescribe() );
        }
        return fieldNameDescribleFieldMap;
    }
    //Method to create Map of Field API v/s Field Name
    public static Map<string, string> getSchemaLabelAPIMap(string sObjectName) {
        system.debug(sObjectName + '123===');
        Map<string, string> fieldNameDescribleFieldMap = new Map<string, string>();
        SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult childRec = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldMap = sObjectType.getDescribe().fields.getMap();
        system.debug(sObjectFieldMap + '123===');
        for (Schema.SObjectField sfield : sObjectFieldMap.Values()) {
            schema.describefieldresult dfield = sfield.getDescribe();
            fieldNameDescribleFieldMap.put(dfield.getName(), string.valueof(dfield.getSoapType()) );
        }
        return fieldNameDescribleFieldMap;
    }
}