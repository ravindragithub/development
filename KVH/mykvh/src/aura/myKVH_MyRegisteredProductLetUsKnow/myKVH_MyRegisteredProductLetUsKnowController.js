({
	handleSubmit : function(component, event, helper) {
        var isError = false;
        if(!component.get("v.subject")){
            isError = true;            
        }
        
         if(!component.get("v.body")){
            isError = true;
        }
        
        if(!isError){
            component.set("v.spinner", true);
            var action = component.get("c.createSupportCase");  
             action.setParams({
                    "subject" :  component.get("v.subject"),
                    "description" : component.get("v.body"),
                 	"documentIds" : component.get("v.documentIds"),
                 	"caseRecordTypeName" : component.get("v.caseRecordTypeName"),
                });   
             action.setCallback(this, function(response) {
                 var state = response.getState();
                 if (state === "SUCCESS") {
                                   
                    component.set("v.spinner", false);  
                      var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Support case successfully created.",
                            "type" : "success"
                        });
                        toastEvent.fire();
                     	var blanklist = [];
                     	component.set('v.documentIds',blanklist);
                     	component.find("overlayLib2").notifyClose();
                 }else if (state === "ERROR") {
                     var errors = response.getError();
                     if (errors) {
                         if (errors[0] && errors[0].message) {
                             console.log("Error message in wheretobuy initialize: " +
                                         errors[0].message);
                             window.alert("Error message in wheretobuy initialize: " +
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
		
	},
    onFileDelete : function(component, event, helper) {
        var docId = event.currentTarget.id;
        var docIds = [];
        docIds.push(docId);
    	component.set("v.spinner", true);
        var action = component.get("c.deleteDocuments");  
        action.setParams({
            "docIds" :  docIds
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var attachmentlist = component.get('v.attachmentlist');
                var newAttlist = [];
                for(var i=0;i<attachmentlist.length;i++){
                    if(attachmentlist[i].documentId != docId){
                        newAttlist.push(attachmentlist[i]);
                    }
                }
                component.set('v.attachmentlist',newAttlist);
                component.set("v.spinner", false);  
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                        window.alert("Error message : " +
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
	},
    handleCancel : function(component, event, helper) {
		component.find("overlayLib2").notifyClose();
	},
    handleUploadFinished: function (component, event, helper) {     
        var attachmentlist = component.get('v.attachmentlist');
        var uploadedFiles = event.getParam("files");   	
        console.log(uploadedFiles);
        var documentIds = component.get('v.documentIds');
        if(uploadedFiles && uploadedFiles.length > 0){
            for(var i=0;i<uploadedFiles.length;i++){
                documentIds.push(uploadedFiles[i].documentId);
                attachmentlist.push(uploadedFiles[i]);
            }
        }
        console.log(documentIds);
        component.set('v.attachmentlist',attachmentlist);
        
        component.set('v.documentIds',documentIds);
        
       /* if(uploadedFiles && uploadedFiles.length > 0){
             component.set("v.newdocumentId",uploadedFiles[0].documentId);  
        }else{
            alert("File not upload, please try again or contact with support.");
        }              
        component.find("overlayLib2").notifyClose(); */
    } 
})