({    
    handleUploadAction : function(component) {
        var allValid = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            //inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },  
    showToastHelper : function(component,text) {        
        var isItFalse = component.get("v.inhibitTransform");
        console.log("this is the inhibit value: " + isItFalse);
        if(isItFalse)  {            
            $A.createComponent(
                'c:LTE_ShowToast_cmp', {
                    title: text,                    
                },
                function(newButton, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(newButton);
                        component.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE" || status === "ERROR") {
                        console.log("No response from server or client is offline."+ errorMessage)
                    }
                }
            );
        } 
        else{
            var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'title' : 'Error', 
                "type": "error",
                'message' : text 
            }); 
            showToast.fire(); 
        }
    },
})