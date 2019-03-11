({
	cancelclick : function(component, event, helper){      
        component.find("overlayLib2").notifyClose();
    },
    continueclick : function(component, event, helper){        
        component.set("v.showFileUpload",true);           
    } ,
     handleUploadFinished: function (component, event, helper) {     
        
        var uploadedFiles = event.getParam("files");   	
        //console.log(uploadedFiles);
        if(uploadedFiles && uploadedFiles.length > 0){
             component.set("v.newdocumentId",uploadedFiles[0].documentId);  
        }else{
            alert("File not upload, please try again or contact with support.");
        }              
        component.find("overlayLib2").notifyClose(); 
    } 
})