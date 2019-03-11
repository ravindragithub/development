({
    doInit: function(component, event, helper) {
        helper.getCheckList(component);
    },
	handleUploadFinished: function(component, event, helper) {
		var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var documentName = (uploadedFiles[0].name).substring(0, (uploadedFiles[0].name).lastIndexOf("."));
        helper.getAttachmentList(component, documentId, documentName);
        if(uploadedFiles.length == 1)
            helper.handleShowInfo(component, uploadedFiles.length + " file uploaded successfully");
        else
            helper.handleShowInfo(component, uploadedFiles.length + " files uploaded successfully");
	},
    onFileDelete : function(component, event, helper) {
        var docId = event.currentTarget.id;
        if (confirm("Are you sure you want to remove the attachment?")) {   
            helper.deleteFile(component,docId);
        }
    }
})