({
	showSpinner : function (component, event, helper) {
        component.set("v.showspinner","slds-show");
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.showspinner","slds-hide");  
    },
    showAddCartPopup : function(component, event, helper) {
       component.set("v.errormessage","");
        var docId = event.target.getAttribute('data-id');
        console.log(docId);
        var salesAidsMap = component.get("v.SalesAidsMap");
        var salesAidsObj = salesAidsMap[docId];
        console.log(salesAidsObj.productName);
        component.set("v.documentobj",salesAidsObj);
        component.set("v.showaddtocartbuttton",true);
        component.set("v.successmessage","");
		component.set("v.showpopup","block");
	},
    hideAddCartPopup : function(component, event, helper) {
		component.set("v.showpopup","none");
	},
    decreaseqty : function(component, event, helper) {
		var documentObj = component.get("v.documentobj");
        
        if(documentObj.quantity > 0){
            documentObj.quantity = documentObj.quantity -1;
            component.set("v.documentobj",documentObj);
        }
        
        if(documentObj.quantity == 1){
            component.set("v.disableddcreasebtn",true);
        }
        
	},
    increaseqty : function(component, event, helper) {
        var documentObj = component.get("v.documentobj");
		documentObj.quantity = documentObj.quantity + 1;
        if(documentObj.quantity > 0){
            component.set("v.disableddcreasebtn",false);
        }
        component.set("v.documentobj",documentObj);
	},
    searchSalesAids : function(component, event, helper) {
        component.set("v.showblankerror",false);
        var searchstring = event.getParam("searchstring");
        var selectedProducts = event.getParam("selectedProducts");
        var selectedContentTypes = event.getParam("selectedContentTypes");
        
        
        //alert("from sales aids"+ searchstring + ' ' + selectedProducts + ' ' +selectedContentTypes);
        var action = component.get("c.fetchSalesAids");
        //Setting parameters for server side call
        action.setParams({
            searchString : searchstring,
            selectedProducts : JSON.stringify(selectedProducts),
            selectedContentTypes : JSON.stringify(selectedContentTypes)
        });
        //Firing server side call
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.categories", response.getReturnValue().categorylist);
                component.set("v.SalesAidsMap", response.getReturnValue().salesAidsMap);
                
                var categorylist = response.getReturnValue().categorylist;
                if(categorylist.length == 0){
                   //alert("No Product found.");
                   component.set("v.showblankerror",true);
                }
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
    },
    addtocart : function(component, event, helper) {
        component.set("v.errormessage","");
        var docId = event.target.getAttribute('data-id');
        
        var salesAidsMap = component.get("v.SalesAidsMap");
        var salesAidsObj = salesAidsMap[docId];        
        console.log(JSON.stringify(salesAidsObj));
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
                        
                        var categorylist = component.get("v.categories");
                       
                        for(var i=0;i<categorylist.length;i++){
                            var subcategorylist = categorylist[i].subcategorylist;
                             
                            if(subcategorylist != undefined){
                                for(var j =0;j<subcategorylist.length;j++){
                                    var rows = subcategorylist[j].rows;
                                    if(rows != undefined){
                                        for(var row=0;row<rows.length;row++){
                                            var documentlist = rows[row].salesAidslist;
                                            for(var k=0;k<documentlist.length;k++){
                                                var salesAidsobjtemp = documentlist[k];                                           
                                                if(salesAidsobjtemp.productDocId == docId){
                                                    documentlist[k] = returnedsalesAidsObj;
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        component.set("v.categories",categorylist);
                        //set the return sales aids to the map for updating the same sles order line if any update
                        salesAidsMap[docId] = returnedsalesAidsObj;
                        component.set("v.SalesAidsMap",salesAidsMap);
                        //update the popup salesAids object with the new values return from the controller
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