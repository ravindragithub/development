({	  
    doInit: function(component, event, helper) {    
        helper.callAttachmentList(component, event, helper);
    },    
    handleUploadFinished: function (component, event,helper) {
        var uploadedFiles = event.getParam("files");
        helper.callAttachmentList(component, event, helper);
        if(uploadedFiles.length == 1)
            helper.handleShowInfo(component, "Upload" , uploadedFiles.length + " file uploaded successfully");
        else
            helper.handleShowInfo(component, "Upload" , uploadedFiles.length + " files uploaded successfully");    
    },
    deleteAttach : function(component, event, helper) {
        var docId = event.currentTarget.id;  
        var type = event.target.getAttribute("data-attriVal"); 
        if (confirm("Confirm to delete the Attachment?")) {   
            helper.deleteAttachmentList(component,docId,type);
        }        
    },
    downloadAttachment : function(component, event, helper) {
        var urlstring = $A.get("$Label.c.myKVH_Community_Prefix")  + '/servlet/servlet.FileDownload?file='+event.getSource().get("v.value");
        window.open(urlstring,'_blank');
    },
    downloadFiles : function(component, event, helper) {
        var urlstring = $A.get("$Label.c.myKVH_Community_Prefix")  + '/sfc/servlet.shepherd/version/download/'+event.getSource().get("v.value");
        window.open(urlstring,'_blank');
    },
})