({	 
    onChangeServiceType: function (component, event, helper) {
        var selectItem = component.find('ServiceType').get('v.value');
        component.set("v.caseRecord.Web_Product_or_Service_Type__c",selectItem);        
    },
    submitCase : function (component, event, helper) {
        if( helper.checkFieldValidity(component, event, helper)  &&
           !$A.util.isEmpty(component.get("v.caseRecord.Web_Product_or_Service_Type__c")) )
            component.set("v.saveValid",true);        
        else{
            component.set("v.saveValid",false);  
            alert('Please enter the required fields.');
        }
    },
})