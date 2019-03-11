({
    handleSatelliteTV : function(component, event, helper) {
        var selectValue = event.getSource().get('v.label');
        component.set("v.SatelliteTVProvider",selectValue); 
        component.set("v.simpleLTEActivation.Satellite_TV_Provider__c",selectValue);    
        if(selectValue == 'DISH Network'){
            component.set("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c","");  
            component.set("v.simpleLTEActivation.DIRECTV_Account_Number__c", "");   
        }else{
            component.set("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c",""); 
        }
        var a = component.get('c.perAccValidation');
        $A.enqueueAction(a);  		
    },
    handleDISHNetwork : function(component, event, helper) {
        var selectValue = event.getSource().get('v.title');
        component.set("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c",selectValue);      
        var a = component.get('c.perAccValidation');
        $A.enqueueAction(a);  				
    },
    handleDirectTV : function(component, event, helper) {
        var selectValue = event.getSource().get('v.title');
        if(selectValue == 'Existing')
            component.set("v.DirectTVCheck",true);  
        else{
            component.set("v.DirectTVCheck",false); 
            component.set("v.simpleLTEActivation.DIRECTV_Account_Number__c","");       
        }
        component.set("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c",selectValue);       
        var a = component.get('c.perAccValidation');
        $A.enqueueAction(a);  		
    },
    perAccValidation : function(component, event, helper) {
        if(!$A.util.isEmpty(component.get("v.simpleLTEActivation.Satellite_TV_Provider__c")) ){
            if($A.util.isEmpty(component.get("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c")) && 
               component.get("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c")  == 'New'){
                component.set("v.perAccRequired",false);
            }else if($A.util.isEmpty(component.get("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c")) && 
                     component.get("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c")  == 'Existing' &&
                     !$A.util.isEmpty(component.get("v.simpleLTEActivation.DIRECTV_Account_Number__c"))){
                component.set("v.perAccRequired",false);
            }else if(!$A.util.isEmpty(component.get("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c")) &&
                     $A.util.isEmpty(component.get("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c"))){
                component.set("v.perAccRequired",false);
            }else{
                component.set("v.perAccRequired",true);
            }
            
        }else{
            component.set("v.perAccRequired",true);
        }
    }
})