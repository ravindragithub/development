/***********************************************************************************************************************
Name: UtillityClassTgrAddressObject
Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
Purpose: This is used to populate stateISO code from pw_ccpro__State__c Object.
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0    Gopi Kishore. K       11/13/2014        Initial Development                          
***********************************************************************************************************************/
public Class UtillityClassTgrAddressObject{
    public static void PopulateStateISOCode(List<Address__c> addressStateISOCode){
        if(HelperClass.UtillityClassTgrAddressObjectMethod){
            Map<String,String> stateISOCode = New Map<String,String>();
            List<pw_ccpro__State__c> stateCodes = [SELECT ID,pw_ccpro__IsoCode__c,name FROM pw_ccpro__State__c];
            for(pw_ccpro__State__c ISOCode:stateCodes){
                    stateISOCode.PUT(ISOCode.name,ISOCode.pw_ccpro__IsoCode__c);
            }
            for(Address__c ISOCodeFunction:addressStateISOCode){
                if(stateISOCode.ContainsKey(ISOCodeFunction.State__c))
                ISOCodeFunction.State_Province_ISO_Code__c = stateISOCode.get(ISOCodeFunction.State__c);
            }
        }
    }
}