({
	getAttachmentList: function(component, documentId, documentName) {
        var productRegId = component.get("v.productRegId");
        if(productRegId){
            var action = component.get("c.getListAttachment");
            action.setParams({ 
                ProdRegId: productRegId,
                documentId: documentId,
                documentName: documentName+'_CkList'
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.attachmentList",response.getReturnValue());
                    this.getCheckList(component);
                }else if (state === "ERROR") {
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
        }
	},
    deleteFile: function(component, docId) {   
        var action = component.get("c.deleteAttachmentList");
        action.setParams({ 
            docId: docId, 
            ProdRegId : component.get("v.productRegId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.attachmentList",response.getReturnValue());
                this.getCheckList(component);
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
    getCheckList: function(component){
        var attachmentList = component.get('v.attachmentList');
        component.set('v.disabled',false);
        if(attachmentList){
            var checkList = [];
            for(var i in attachmentList){
                if((attachmentList[i].attachName).endsWith('_CkList')){
                    checkList.push(attachmentList[i]);
                }    
            }
            if(checkList.length>0){
                component.set('v.disabled',true);
            }
            component.set('v.checkList',checkList);    
        }
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
    }
})