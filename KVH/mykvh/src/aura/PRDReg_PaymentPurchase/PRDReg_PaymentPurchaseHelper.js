({
    callAttachmentList : function(component, documentId, documentName) {  
        var action = component.get("c.getListAttachment");
        action.setParams({ 
            ProdRegId : component.get("v.simpleLTEActivation.Id"),
            documentId: documentId,
            documentName: documentName+'_POP'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.attachmentList",response.getReturnValue());
                this.getPopList(component);
                this.payPurchaseValHelper(component);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
    },
    getPopList: function(component){
        var attachmentList = component.get('v.attachmentList');
        component.set('v.disabled',false);
        if(attachmentList){
            var popList = [];
            for(var i in attachmentList){
                if((attachmentList[i].attachName).endsWith('_POP')){
                    popList.push(attachmentList[i]);
                }    
            }
            if(popList.length>0){
                component.set('v.disabled',true);
            }
            component.set('v.popList',popList);    
        }
    },
    deleteAttachmentList : function(component, docId) {   
        var action = component.get("c.deleteAttachmentList");
        action.setParams({ 
            docId: docId, 
            ProdRegId : component.get("v.simpleLTEActivation.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.attachmentList",response.getReturnValue());
                this.getPopList(component);
                this.handleShowInfo(component, "File removed successfully");
                this.payPurchaseValHelper(component);  
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });	
        $A.enqueueAction(action);      
    },
    handleUploadAction : function(component) {
        var allValid = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },
    payPurchaseValHelper : function(component) {
        if(this.handleUploadAction(component) && component.get("v.popList").length > 0 )
            component.set("v.purchaseRequired",false);        
        else
            component.set("v.purchaseRequired",true);   
    },    
    handleShowInfo : function(component,text) {     
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            title : 'Proof of Purchase',
            duration:'5000',
            type: 'info',
            mode: 'dismissible',
            message: text
        }); 
        showToast.fire(); 
    },    
})