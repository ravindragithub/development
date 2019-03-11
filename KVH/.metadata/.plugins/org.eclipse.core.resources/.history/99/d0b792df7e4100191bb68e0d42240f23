({
    FieldValidation : function(component, event, helper) {
        var isValidMMSI = true; 
        var isValidIMO = true; 
        var inputMMSII = component.find('LTEFieldMMSII');
        var valueMMSII = inputMMSII.get('v.value');
        var inputIMO = component.find('LTEFieldIMO');
        var valueIMO = inputIMO.get('v.value');
        //console.log(valueMMSII);
        //console.log(valueIMO);
        if(valueMMSII != null && valueMMSII != '')
            isValidMMSI = helper.handleMMSIIValidation(component,inputMMSII,valueMMSII);  
        else{
            component.find('LTEFieldMMSII').set('v.value','');
            component.find('LTEFieldMMSII').set("v.errors", null); 
        }
        if(valueIMO != null  && valueIMO != '')
            isValidIMO = helper.handleIMOValidation(component,inputIMO,valueIMO);
        else{
            component.find('LTEFieldIMO').set('v.value','');            
            component.find('LTEFieldIMO').set("v.errors", null); 
        }
        if(isValidMMSI && isValidIMO && helper.handleUploadAction(component) && 
           (component.get("v.simpleLTEActivation.Vessel_Type__c") != null && component.get("v.simpleLTEActivation.Vessel_Type__c") != '')
          )
            component.set("v.vesselInfoRequired",false);        
        else
            component.set("v.vesselInfoRequired",true);
    },
    vesselInfoValidation : function(component, event, helper) {
        if(helper.handleUploadAction(component) && 
           (component.get("v.simpleLTEActivation.Vessel_Type__c") != null && component.get("v.simpleLTEActivation.Vessel_Type__c") != '')
          )
            component.set("v.vesselInfoRequired",false);        
        else
            component.set("v.vesselInfoRequired",true);
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Flag__c",currentvalue);  
    },
    handleMarketValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var oldvalue = event.getParam("oldValue");
        //console.log(oldvalue);
        if(typeof oldvalue != 'undefined'){
            component.set("v.simpleLTEActivation.Market__c",currentvalue); 
            var a = component.get('c.vesselInfoValidation');
            $A.enqueueAction(a);
        }
    },
    handleSectorValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        var oldvalue = event.getParam("oldValue");
        if(typeof oldvalue != 'undefined'){
            component.set("v.simpleLTEActivation.Sector__c",currentvalue); 
            var a = component.get('c.vesselInfoValidation');
            $A.enqueueAction(a);
        }
    },
    handleVesselTypeValue : function (component, event, helper) {
        var a = component.get('c.vesselInfoValidation');
        $A.enqueueAction(a);
    },
})