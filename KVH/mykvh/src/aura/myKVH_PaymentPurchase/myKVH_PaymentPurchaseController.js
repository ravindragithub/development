({
    doInit: function(component, event, helper) {     
        //helper.callAttachmentList(component, event, helper);
    },    
	handleUploadFinished: function (component, event,helper) {
        var uploadedFiles = event.getParam("files");
        helper.callAttachmentList(component, event, helper);
        alert("Files uploaded : " + uploadedFiles.length);
    },
    openPicker : function(component, event, helper) {
        var docId = event.currentTarget.id;  
        if (confirm("Confirm to delete the Attachment?")) {   
            helper.deleteAttachmentList(component,docId);
        }        
    }
})