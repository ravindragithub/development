({
	alertOpenHelper :  function(component, event, helper,buttonname){  
        component.set("v.newdocumentId","");
        var modalBody;         
            $A.createComponents([
                ["c:mykvh_MyRegisteredProductsNewUploadAlert",
                 	{"message" : "Only one attachment is allowed per product. By uploading this new file, your previous attachment will be overwritten.",                   
                     "recordID" : component.get("v.assetObj.prodReg.Id"),
                     "buttonName" : buttonname,
                     "newdocumentId" : component.getReference("v.newdocumentId")
                     }]
            ],
            function(components, status){
                if (status === "SUCCESS") {
                    modalBody = components[0];					
                    component.find('overlayLib').showCustomModal({
                       header: "",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "my-modal,my-custom-class,my-other-class",
                       closeCallback: function() {
                           //alert('You closed the alert!');
                       }
                   })
                }
            }
           );
    },
    addSuffixInNewDocument : function(component, event, helper){
         component.set("v.spinner", true);
        var action = component.get("c.updateNewDocuemntSuffix");  
        action.setParams({ suffix : component.get("v.buttonName"),
                          documentId : component.get("v.newdocumentId"),
                          prodRegId : component.get("v.assetObj.prodReg.Id")
                         });

         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 if(response.getReturnValue()){
                     if(component.get("v.buttonName") == 'POP'){
                         component.set("v.assetObj.popDocument.documentId",response.getReturnValue());                        
                     }else if(component.get("v.buttonName") == 'CkList'){
                         component.set("v.assetObj.ckListDocument.documentId",response.getReturnValue());
                     }
                      
                 }
                
                 component.set("v.spinner", false);                 
             }else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message in initialize: " +
                                     errors[0].message);
                         window.alert("Error message in initialize: " +
                                      errors[0].message);
                     }
                     window.alert("Unknown error try search again");
                 } else {
                     console.log("Unknown error");
                     window.alert("Unknown error try search again");
                 }
                 component.set("v.spinner", false);
             }
         });
         $A.enqueueAction(action);
    }
})