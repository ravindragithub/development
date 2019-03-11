trigger ValidateCustomAddressCountryField on address__c (before insert, before update) {
    //pw_ccpro.CountryValidator2.Validate(Trigger.new, Trigger.oldMap);
    
    /*Populating stateISO Code while creating new address from state Object.
    Updated By Gopi*/
    
    if(Trigger.isBefore){
        UtillityClassTgrAddressObject.PopulateStateISOCode(Trigger.new);
        Address_Trigger_Handler.onBefore(Trigger.new);
    }  
}