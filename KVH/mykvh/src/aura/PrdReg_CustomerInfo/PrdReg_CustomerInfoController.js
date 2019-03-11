({
    doInit: function(component, event, helper) {
        var prodRegistration = component.get('v.prodRegistration');
        if(prodRegistration.Subscriber_First_Name__c!=''){
            component.set('v.disableFirstName',true);
        }
        if(prodRegistration.Subscriber_Last_Name__c!=''){
            component.set('v.disableLastName',true);
        }
        if(prodRegistration.Subscriber_Email__c!=''){
            component.set('v.disableEmail',true);
        }
        if(prodRegistration.Subscriber_Phone__c!=''){
            component.set('v.disablePhone',true);
        }
        if(prodRegistration.Subscriber_Country__c!=''){
            component.set('v.disableCountry',true);
            var contryCode = helper.getCountryCode(component, prodRegistration.Subscriber_Country__c);
            helper.getStateOpts(component,contryCode);
        }else{
            component.find('contrySelect').set('v.value','US');
            prodRegistration.Subscriber_Country__c = 'United States';
            component.set('v.prodRegistration',prodRegistration);
            helper.getStateOpts(component,'US');
        }
        if(prodRegistration.Subscriber_State_Province_Territory__c!=''){
            component.set('v.disableState',true);
        }
    },
    onCountrySelect: function(component, event, helper){
        var countryOptions = component.get("v.countryOptions");
        var contryCode = component.find('contrySelect').get('v.value');
        var index = countryOptions.findIndex(item => item.value == contryCode);
        var contryName = index>=0 ? countryOptions[index].label : null;
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Subscriber_Country__c = contryName;
        prodRegistration.Subscriber_State_Province_Territory__c = '';
        if(contryName!='United States'){
            prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c = '';
        }
        component.set('v.prodRegistration',prodRegistration);
        component.set('v.subsciberCountry',contryName);
        helper.getStateOpts(component,contryCode);
        var a = component.get('c.callValidateInfo');
        $A.enqueueAction(a);
    },
	onStateSelect: function(component, event, helper){
		var stateName = component.find('stateSelect').get('v.value');
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Subscriber_State_Province_Territory__c = stateName;
        component.set('v.prodRegistration',prodRegistration);
        var a = component.get('c.callValidateInfo');
        $A.enqueueAction(a);
	},
    callValidateInfo: function(component, event, helper){
        component.set('v.customerInfoChanged',true);
        var prodRegistration = component.get('v.prodRegistration');
        component.set('v.accountRequired',true);
        if(helper.validateInfo(component) && 
           prodRegistration.Subscriber_Country__c!=null && prodRegistration.Subscriber_Country__c!=''){
            var stateOptions = component.get('v.stateOptions');
            if((stateOptions.length>0 && !$A.util.isEmpty(prodRegistration.Subscriber_State_Province_Territory__c)) ||
               (stateOptions.length==0 && $A.util.isEmpty(prodRegistration.Subscriber_State_Province_Territory__c))){
                component.set('v.accountRequired',false);
            }
        }
    }
})