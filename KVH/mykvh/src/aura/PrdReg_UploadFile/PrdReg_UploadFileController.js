({
    doInit: function(component, event, helper){
        helper.getCheckList(component);
    },
    handleUploadFinished: function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var documentName = (uploadedFiles[0].name).substring(0, (uploadedFiles[0].name).lastIndexOf("."));
        var suffix = component.get('v.suffix');
        
        helper.callAction(
            component,
            'c.updateFileName',
            function(result){
                component.set("v.attachmentList",result);
                helper.showToast('success', 'Success', 'File uploaded successfully.');
                helper.getCheckList(component);
            },
            {
                prodRegId: component.get("v.productRegId"),
                documentId: documentId,
                documentName: documentName+suffix
            }
        );
    },
    onFileDelete : function(component, event, helper){
        var docId = event.currentTarget.id;
        if (confirm("Are you sure you want to remove the attachment?")){
            helper.callAction(
                component,
                'c.deleteAttachment',
                function(result){
                    component.set("v.attachmentList",result);
                    helper.showToast('success', 'Success', 'File removed successfully.');
                    helper.getCheckList(component);
                },
                {
                    docId: docId,
                    prdRegId: component.get("v.productRegId")
                }
            );
        }
    }
})