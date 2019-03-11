({
   
	openProductRegistrationPopup : function(component, event, helper){    
          var modalBody;
          var modalHeader;
            $A.createComponents([
                ["c:mykvh_MyRegistereedProductRegistrationPrint",{"productRegId" : component.get("v.assetObj").prodReg.Id,
                                                                  "autoPrint":false}],
                ["c:mykvh_MyRegistereedProductRegistrationPopHeader",{"productRegId" : component.get("v.assetObj").prodReg.Id}]
            ],
            function(components, status){
                if (status === "SUCCESS") {
                    modalBody = components[0];
					modalHeader = components[1];
                    component.find('overlayLib').showCustomModal({
                       header: modalHeader,
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
    pophandleClick :  function(component, event, helper){  
        component.set("v.continueclicked",false);
        component.set("v.buttonName","POP");
        helper.alertOpenHelper(component, event, helper,'New Proof of Purchase');
    },
    ckListhandleClick : function(component, event, helper){
        component.set("v.continueclicked",false);
        component.set("v.buttonName","CkList");
        helper.alertOpenHelper(component, event, helper,'New Installation Checklist');
    },
    newdocumentIdChange : function(component, event, helper){
        if(component.get("v.newdocumentId") && component.get("v.newdocumentId") != ""){  
            helper.addSuffixInNewDocument(component, event, helper);
        }
    }
   
})