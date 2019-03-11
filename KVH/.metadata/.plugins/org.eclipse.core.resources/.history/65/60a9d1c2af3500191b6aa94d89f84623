/**
* @createdby 		:	Teertha prasad
* @createddate 		:	28/06/2016
* @last modifiedby  :	Teertha prasad
* @last modifieddate: 	28/06/2016
* @description 		:	Class Used In Address Trigger for address fields autopopulate
**/
public class Address_Trigger_Handler {
    
    /**
* @last modified by 	:	Teertha prasad
* @last modified date 	:	09/09/2016
* @description 			:	onBefore Method.
* @return 				:	void
* @param				:	List of Activation Subscriber Records
* @invoke 				:	From Act_Subscriber Trigger 
**/  
    public static void onBefore(List<Address__c> lstAddress){
        isBefore(lstAddress);
    }
    
    /**
* @last modified by 	:	Teertha prasad
* @last modified date 	:	09/09/2016
* @description 			:	isBefore Method.
* 							mapping country and state, ISO
* @return 				:	void
* @param				:	List of Address Records
* @invoke 				:	From onBefore Method 
**/ 
    private static void isBefore(List<Address__c> lstAddress){
        /*
map<string, KVH_Countries__mdt> readMapCountry = new map<string, KVH_Countries__mdt>();
CountryStateMethods util = new CountryStateMethods(); 
readMapCountry = util.getCountryMap();

map<string, KVH_States__mdt> readMapState = new map<string, KVH_States__mdt>();
readMapState = util.getNamedStateMap();

for(Address__c objAddress : lstAddress){
if(objAddress.ISO_3166_2_Code__c != null){
objAddress.Country__c = ((!readMapCountry.isEmpty() && readMapCountry.containsKey(objAddress.ISO_3166_2_Code__c.trim())) ? readMapCountry.get(objAddress.ISO_3166_2_Code__c.trim()).TrimmedName__c : '' );
objAddress.Country_ISO_Code_3166_3__c =	((!readMapCountry.isEmpty() && readMapCountry.containsKey(objAddress.ISO_3166_2_Code__c.trim())) ? readMapCountry.get(objAddress.ISO_3166_2_Code__c.trim()).IsoCode_3__c : '' );
if(objAddress.State__c != null){
objAddress.State_Province_ISO_Code__c = ((!readMapState.isEmpty() && readMapState.containsKey(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim())) ? readMapState.get(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim()).IsoCode__c : '' );
objAddress.State_ISO_Code__c = ((!readMapState.isEmpty() && readMapState.containsKey(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim())) ? readMapState.get(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim()).FullIsoCode__c : '' );
}
}
}*/
        Map<string, KVH_Countries__mdt> readMapCountry = new Map<string, KVH_Countries__mdt>();
        Map<string, KVH_States__mdt> readMapState = new Map<string, KVH_States__mdt>();
        CountryStateMethods util = new CountryStateMethods(); 
        
        
        Set<string> lstCountryISO = new Set<string>();
        for(Address__c objAddress : lstAddress){
            if(objAddress.ISO_3166_2_Code__c != null){
                lstCountryISO.add(objAddress.ISO_3166_2_Code__c);
            }
        }
        readMapCountry = util.getCountryMap(lstCountryISO);
        readMapState = util.getNamedStateMap(lstCountryISO);
        for(Address__c objAddress : lstAddress){
            if(objAddress.ISO_3166_2_Code__c != null){
                objAddress.Country__c = ((!readMapCountry.isEmpty() && readMapCountry.containsKey(objAddress.ISO_3166_2_Code__c.trim())) ? readMapCountry.get(objAddress.ISO_3166_2_Code__c.trim()).TrimmedName__c : '' );
                objAddress.Country_ISO_Code_3166_3__c =	((!readMapCountry.isEmpty() && readMapCountry.containsKey(objAddress.ISO_3166_2_Code__c.trim())) ? readMapCountry.get(objAddress.ISO_3166_2_Code__c.trim()).IsoCode_3__c : '' );
                if(objAddress.State__c != null){
                    objAddress.State_Province_ISO_Code__c = ((!readMapState.isEmpty() && readMapState.containsKey(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim())) ? readMapState.get(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim()).IsoCode__c : '' );
                    objAddress.State_ISO_Code__c = ((!readMapState.isEmpty() && readMapState.containsKey(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim())) ? readMapState.get(objAddress.ISO_3166_2_Code__c.trim()+'@@'+objAddress.State__c.trim()).FullIsoCode__c : '' );
                }
            }
        }
    }
    
    
}