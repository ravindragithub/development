({
    initialize : function(component, event, helper) {
        console.log("PickListController.js-initialize");
        console.log(component.get("v.objName"));
        console.log(component.get("v.fieldName"));
        //call the helper function with pass [component, Controller field and Dependent Field] Api name
        helper.fetchPicklistValues(component,
            component.get("v.objName"),
            component.get("v.fieldName")
        );
    },
    
    // function call on change tha Dependent field
    onFieldChange: function(component, event, helper) {
        console.log("PickListController.js-onFieldChange");
        component.set("v.selectedValue", event.getSource().get("v.value"));
        //alert('Dependent field selected:'+event.getSource().get("v.value"));
    }
})