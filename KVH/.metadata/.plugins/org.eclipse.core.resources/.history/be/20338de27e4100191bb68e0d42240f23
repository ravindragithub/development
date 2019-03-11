({	 
    submitCase : function (component, event, helper) {
        if( helper.checkFieldValidity(component, event, helper)  )
            component.set("v.saveAirtimeValid",true);        
        else{
            component.set("v.saveAirtimeValid",false);  
            alert('Please enter the required fields.');
        }
    },
    nextLayout : function(component, event, helper) { 
        if(!$A.util.isEmpty(component.get("v.productType")))
            component.set("v.productTypeCheckFlag",false); 
        else
            alert('Select atleast one value');
    },
    backLayout : function(component, event, helper) { 
        component.set("v.productTypeCheckFlag",true);   
        component.set("v.productType","");         
    }, 
    
    getAirtimeType : function(component, event, helper) {        
        var fieldName = event.getSource().get("v.label");
        component.set("v.productType",fieldName);
    },
})