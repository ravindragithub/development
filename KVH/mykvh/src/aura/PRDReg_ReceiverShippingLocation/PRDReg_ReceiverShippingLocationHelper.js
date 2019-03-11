({	
    handleUploadAction : function(component) {
        var allValid = component.find('LTEFieldCont').reduce(function (validSoFar, inputCmp) {
            //inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },    
    showToastHelper : function(component,text) {  
        var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'title' : 'Error', 
                "type": "error",
                'message' : text 
            }); 
            showToast.fire(); 
    },
})