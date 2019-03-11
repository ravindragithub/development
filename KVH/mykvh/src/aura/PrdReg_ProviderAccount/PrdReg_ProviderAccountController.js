({
	onSatelliteTVChange: function(component, event, helper){
        var selectValue = event.getSource().get('v.label');
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Satellite_TV_Provider__c = selectValue;
        prodRegistration.Dish_Network_Subscriber_Status__c = '';
        prodRegistration.DIRECTV_Subscriber_Status__c = '';
        prodRegistration.DIRECTV_Account_Number__c = '';
        component.set('v.prodRegistration',prodRegistration);
        
        var validation = component.get('c.validation');
        $A.enqueueAction(validation);
	},
    onChangeDISHNetwork: function(component, event, helper){
        var selectValue = event.getSource().get('v.title');
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Dish_Network_Subscriber_Status__c = selectValue;
        component.set('v.prodRegistration',prodRegistration);
             
        var validation = component.get('c.validation');
        $A.enqueueAction(validation);
    },
    onChangeDirectTV: function(component, event, helper){
        var selectValue = event.getSource().get('v.title');
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.DIRECTV_Subscriber_Status__c = selectValue;
        prodRegistration.DIRECTV_Account_Number__c = '';
        component.set('v.prodRegistration',prodRegistration);
             
        var validation = component.get('c.validation');
        $A.enqueueAction(validation);
    },
    validation: function(component, event, helper){
        component.set("v.providerAccRequired",true);
        var prodRegistration = component.get('v.prodRegistration');
        if(!$A.util.isEmpty(prodRegistration.Satellite_TV_Provider__c)){
            if(prodRegistration.Satellite_TV_Provider__c=='DirectTV'){
                if(!$A.util.isEmpty(prodRegistration.DIRECTV_Subscriber_Status__c)){
                    if(prodRegistration.DIRECTV_Subscriber_Status__c=='Existing' &&
                       !$A.util.isEmpty(prodRegistration.DIRECTV_Account_Number__c)){
                        component.set("v.providerAccRequired",false);
                    }else if(prodRegistration.DIRECTV_Subscriber_Status__c=='New'){
                        component.set("v.providerAccRequired",false);
                    }
                }
            }else if(prodRegistration.Satellite_TV_Provider__c=='DISH Network'){
                if(!$A.util.isEmpty(prodRegistration.Dish_Network_Subscriber_Status__c)){
                    component.set("v.providerAccRequired",false);
                }
            }
        }
    }
})