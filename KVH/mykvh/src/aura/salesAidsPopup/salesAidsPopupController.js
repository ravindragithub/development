({
	showSpinner : function (component, event, helper) {
       component.set("v.showspinner",true);
       //document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.remove('hideEl')
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.showspinner",false);  
        //document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.add('hideEl')
    },
    decreaseqty : function(component, event, helper) {
		var documentObj = component.get("v.documentobj");
        
        if(documentObj.quantity > 0){
            documentObj.quantity = documentObj.quantity -1;
            component.set("v.documentobj",documentObj);
        }
     
	},
    increaseqty : function(component, event, helper) {
        var documentObj = component.get("v.documentobj");
		documentObj.quantity = documentObj.quantity + 1;     
        component.set("v.documentobj",documentObj);
	},
    showaddtocartpopup  : function(component, event, helper) {
        component.set("v.errormessage","");
        component.set("v.successmessage","");
        component.set("v.showaddtocartbuttton",true);
        
        
       // alert("hello");
    	component.set("v.showpopup","block");
        var docId = event.getParam("docId");
               
        var action = component.get("c.fetchOrderLine");
        console.log(action);
        //Setting parameters for server side call
        action.setParams({           
            docId : docId
        });
        //Firing server side call
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.documentobj",response.getReturnValue());
             
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleProductSearchEvent: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    hideAddCartPopup : function(component, event, helper) {
       // alert("hello");
    	component.set("v.showpopup","none");
        var blankDocumentObj;
        component.set("v.documentobj",blankDocumentObj)
	},
    addtocart : function(component, event, helper) {
        component.set("v.errormessage","");
       
        var salesAidsObj = component.get("v.documentobj");       
        
        //check quantity more then zero
        if(salesAidsObj.quantity > 0){
            //add selected product to cart
            var action = component.get("c.addToCart");
            //Setting parameters for server side call
            action.setParams({           
                salesAidsjson : JSON.stringify(salesAidsObj)
            });
            //Firing server side call
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnedsalesAidsObj = response.getReturnValue();
                    //successfully added to cart
                    if(returnedsalesAidsObj.isError == false && returnedsalesAidsObj.salesOrderItemId != undefined){
                        
                        component.set("v.documentobj",returnedsalesAidsObj);
                        //hide add to cart button and show message
                        component.set("v.showaddtocartbuttton",false);
                        component.set("v.successmessage",returnedsalesAidsObj.message);
                    }else if(returnedsalesAidsObj.isError == true){
                        //alert(returnedsalesAidsObj.message);
                        component.set("v.errormessage",returnedsalesAidsObj.message);
                    }    
                    
                    //fire update cart event to update the cart count
                    var appEvent = $A.get("e.c:SalesAidsUpdateCartEvent");  
                    console.log(appEvent);
                    appEvent.fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message on handleProductSearchEvent: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set("v.errormessage","at least 1 can be order.");
        }
	}
    
})