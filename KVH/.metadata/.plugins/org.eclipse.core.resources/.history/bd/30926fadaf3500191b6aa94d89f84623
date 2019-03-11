({
    
    /**
     * function used to go back to search panel from Product detail page
     * used with lightning button on Product detail page
     */
    backToSearch : function (component) {
        component.set("v.searchpanel", true);
        helper.hideSpinner(component);
    },
    /**
     * function used to hide and show Quick Links
     * used with back button on SalesToolkit detail page
     * used with Clear button event handling
     */
    backToQuickLinks : function (component) {
        window.setTimeout(
            $A.getCallback(function() {
                console.log('prodresultclear');
                component.set("v.salesKit", false);
                component.set("v.products", null);
                component.set("v.product", null);
                component.set("v.documents", null);
                component.set("v.document", null);
                component.set("v.selectedQuickLink", null);
                component.set("v.quickLink",true);   
                component.set("v.refining", false);
                component.set("v.noResultFlag", false);
                component.set("v.searchpanel", true);
                 component.set("v.showsalesaids", false);
            }), 1
        );
    },
    /**
     * function used to handle the Sales Kit quick link optionsclick
     * gets the event params and fires server side apex method
     * on callback, show the list of available Sales Kit options
     */
    handleSalesKitQuickLink : function (component,event,helper) {
        helper.showSpinner(component);
        var quickaction = event.getParam("quickaction");
        helper.callServer(
            component,
            'c.buildToolKit',
            function(result) {
                console.log(result);
                component.set("v.quickLink", false);
                component.set("v.products", result.products);
                component.set("v.documents", result.documents);
                component.set("v.selectedQuickLink", quickaction);
                component.set("v.refining", true);
            },
            {
                toolKitName: quickaction
            },
            false
        );
    },
    /** function to handle the portal change
	 * It updates the user record with the new portal view
	 **/
    handlePortalViewChange: function(component, event, helper) {
        
        var selectedOption = event.getParam("selectedOption");
        component.set("v.selectedView", selectedOption);
        component.set("v.refining", false);
        var action = component.get("c.portalChange");
        action.setParams({ portalView : selectedOption });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //document.location.reload();
                document.location.href = './productresources';
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handlePortalViewChange: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
     * function used to handle the quick link click
     * gets the event params and fires server side apex method
     * on callback, show the list of available products and documents for selected quick link
     */
    handleQuickLink : function (component,event,helper) {
        helper.showSpinner(component);
        var quickaction = event.getParam("quickaction");
        var salesKitFlag = event.getParam("salestoolkit");
        var ctypes = event.getParam("contenttypes");
        console.log("hello jitu");
        console.log(ctypes);
        //sales Aids adding this condition
        if(quickaction == 'Sales Aids'){
            component.set("v.showsalesaids", true);
            component.set("v.salesKit", false);
            component.set("v.products", null);
            component.set("v.documents", null);
            component.set("v.selectedQuickLink", quickaction);
            component.set("v.quickLink", false);
            
            //search sales aids
            var compEvent = $A.get("e.c:SearchSalesAidsEvent");
            console.log(compEvent);
            compEvent.setParams({
                "selectedProducts" : "",
                "selectedContentTypes" : "",
                "searchstring" : ""
            });
            compEvent.fire();
            helper.hideSpinner(component);
            var appEvent = $A.get("e.c:SalesAidsUpdateCartEvent");  
            console.log(appEvent);
            appEvent.fire();
            
        } else if(salesKitFlag){
            document.location.href = "./toolkitlanding"
        } else{
            //ctypes += ';Brochures';
            var tempContententType = [];
            if(tempContententType != undefined)
                tempContententType = ctypes.split(";");
            
            var blankArray = [];
            
            var fireAllProduct = component.get("v.fireAllProduct");
            if(fireAllProduct){
                component.set("v.fireAllProduct",false);
                helper.fetchAllProducts(component, event, helper,'',blankArray,tempContententType, true);
            }else{
                helper.filterProducts(component, event, helper,'',blankArray,tempContententType, false, false);
            }
            
            //helper.fetchAllProducts(component, event, helper,'',blankArray,tempContententType, true);
            component.set("v.quickLink", false);
            component.set("v.refining", true);
            component.set("v.selectedQuickLink", quickaction);
            component.set("v.products", null);
            var appEvent = $A.get("e.c:QuickLinkAppEvent");
            appEvent.setParams({
                "contenttypes" : ctypes.split(";")
            });
            appEvent.fire();
            //helper.hideSpinner(component);
            
            /*helper.callServer(
                component,
                'c.quickLink',
                function(result) {
                    var cts = result.contenttypes;
                    component.set("v.quickLink", false);
                    component.set("v.refining", true);
                    component.set("v.documents", result.documents);
                    component.set("v.selectedQuickLink", quickaction);
                    if(cts.length == 1){
                        component.set("v.dticonname", "chevron-down");
                        component.set("v.dthidesection", "slds-is-expanded");
                    }
                    var appEvent = $A.get("e.c:QuickLinkAppEvent");
                    appEvent.setParams({
                        "contenttypes" : result.contenttypes
                    });
                    appEvent.fire();
                },
                {
                    quickLink: quickaction,
                    salesKit: salesKitFlag
                },
                true
            );*/
        }
        
    },
    
    /**
     * function used to handle ShowProductDetail event. Shows the product detail page.
     * gets the event params and fires server side apex method
     * on callback, show the list of available resources for selected Product
     */
    handleShowProductDetail : function (component, event, helper) {
        helper.showSpinner(component);
        window.setTimeout(
            $A.getCallback(function() {
                var prodid = event.getParam("prodid");
                console.log(prodid);
                var selectedoption = [];
                selectedoption.push(prodid);
                var selectedcontent = [];
                helper.filterProducts(component, event, helper,null,selectedoption,selectedcontent, false, true);
                component.set("v.searchpanel", false);
                helper.hideSpinner(component);
            }), 5
        );
        /*var tilekeys = 0;
        var action = component.get("c.productDetail");
        action.setStorable(); //setting action as Storable to avoid server callout for same product
        action.setParams({
            productId : event.getParam("product")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.document", response.getReturnValue().documents);
                component.set("v.productImages", response.getReturnValue().productimageurl)  ;
                component.set("v.product", response.getReturnValue().product);
                component.set("v.searchpanel", false);
                //component.set("v.banners", response.getReturnValue().banners);
                //component.set("v.videos", response.getReturnValue().videos);
                component.set("v.refining", true);
                var arrayOfBannerKeys = [];
                var arrayOfVideoKeys = [];
                /*for (var singlekey in response.getReturnValue().banners) {
                    arrayOfBannerKeys.push(singlekey);
                }
                for (var singlekey in response.getReturnValue().videos) {
                    arrayOfVideoKeys.push(singlekey);
                }
                component.set("v.bannerKeys", arrayOfBannerKeys);
                component.set("v.videoKeys", arrayOfVideoKeys);
                console.log('banner keys:  '+ arrayOfBannerKeys+'video keys:  '+arrayOfVideoKeys);
                helper.hideSpinner(component);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handleShowProductDetail: " +
                                    errors[0].message);
                    }
                    
                } else {
                    console.log("Unknown error");
                }
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);*/
    },
    
    /**
     * function used to handle Search button click
     * gets the event params and fires server side apex method
     * on callback, show the list of available products and documents for selected options
     
    handleProductSearchEvent1 :function(component, event, helper){
        var message = event.getParam("message");
        var selectedoption = event.getParam("selectedoption");
        var selectedcontents = event.getParam("selectedcontents");
        console.log("selectedcontents");
        console.log(selectedcontents);
        console.log('hi...: '+message);
        //For Sales Aids call different method to search sales Aids else calling normal functionality
        var selectedQuickLink = component.get("v.selectedQuickLink");
        if(selectedQuickLink == 'Sales Aids'){
            console.log('here: '+message + ' ' + selectedoption + ' '+ selectedcontents);
            var compEvent = $A.get("e.c:SearchSalesAidsEvent");
            console.log(compEvent);
            
            compEvent.setParams({
                "selectedProducts" : selectedoption,
                "selectedContentTypes" : selectedcontents,
                "searchstring" : message
            });
            compEvent.fire();            
        }else{
            if((typeof(message) == "undefined" || message == '' || message == null) && selectedoption == '' && selectedcontents == ''){
                component.set("v.salesKit", false);
                component.set("v.noResultFlag", false);
                component.set("v.products", null);
                component.set("v.documents", null);
                component.set("v.selectedQuickLink", null);
                component.set('v.quickLink',true);
                console.log('no result: ' + v.noResultFlag);
                return;
            } else{
                component.set("v.searchpanel", true);
                component.set("v.quickLink", false);
                component.set("v.salesKit", false);
                console.log('looking here: '+ message + ' '+ selectedoption + ' ' + selectedcontents);
                var action = component.get("c.getProducts");
                //Setting parameters for server side call
                action.setParams({
                    searchString : message,
                    productIds : selectedoption,
                    contentType : selectedcontents
                });
                //Firing server side call
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log(JSON.stringify(response.getReturnValue()) );
                        //Preparing Product list
                        if(response.getReturnValue().products){
                            component.set("v.products", response.getReturnValue().products);
                        }else{
                            component.set("v.products", []);
                        }
                        //Preparing Document list
                        if(response.getReturnValue().documents){
                            component.set("v.documents", response.getReturnValue().documents);
                        }else{
                            component.set("v.documents", []);
                        }
                        //Showing mis-spelled box if no Products or Documents returned
                        if(response.getReturnValue().products &&
                           response.getReturnValue().documents &&
                           response.getReturnValue().products.length === 0 &&
                           response.getReturnValue().documents.length === 0){
                            component.set("v.noResultFlag", true);
                        }else{
                            component.set("v.noResultFlag", false);
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
            }
        }
    },*/
    handleProductSearchEvent :function(component, event, helper){
       
        //helper.showSpinner(component);
        var message = event.getParam("message");
        var selectedoption = event.getParam("selectedoption");
        var selectedcontents = event.getParam("selectedcontents");
        //For Sales Aids call different method to search sales Aids else calling normal functionality
        var selectedQuickLink = component.get("v.selectedQuickLink");
        if(selectedQuickLink == 'Sales Aids'){
            console.log('here: '+message + ' ' + selectedoption + ' '+ selectedcontents);
            var compEvent = $A.get("e.c:SearchSalesAidsEvent");
            console.log(compEvent);
            compEvent.setParams({
                "selectedProducts" : selectedoption,
                "selectedContentTypes" : selectedcontents,
                "searchstring" : message
            });
            compEvent.fire();     
        } else {       
           
            if((typeof(message) == "undefined" || message == '' || message == null) && (selectedoption== undefined || selectedoption == '') && selectedcontents.length == 0){               
               
                component.set("v.salesKit", false);
                component.set("v.refining", false);
                component.set("v.noResultFlag", false);
                component.set("v.products", null);
                component.set("v.documents", null);
                component.set("v.selectedQuickLink", null);
                component.set("v.quickLink", true);
                component.set("v.product", null);
                component.set("v.searchpanel", true);
                component.set("v.document", null);
                component.set("v.showsalesaids", false);
                component.set("v.fireAllProduct",true);
                //helper.hideSpinner(component);
                return;
            } else {
                console.log('looking here: '+ message + ' '+ selectedoption + ' ' + selectedcontents);
                var fireAllProduct = component.get("v.fireAllProduct");
                if(fireAllProduct){
                    component.set("v.fireAllProduct",false);
                    helper.fetchAllProducts(component, event, helper,message,selectedoption,selectedcontents, true);
                }else{
                    helper.filterProducts(component, event, helper,message,selectedoption,selectedcontents, false, false);
                }
                component.set("v.searchpanel", true);
                component.set("v.quickLink", false);
                component.set("v.salesKit", false);
                //helper.hideSpinner(component);
                /*var action = component.get("c.fakeMethod");
                //Firing server side call so spinner will engage
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        helper.filterProducts(component, event, helper,message,selectedoption,selectedcontents, false);
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message on initial loading docs/products" +
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error"); 
                        }
                        
                    }
                    helper.hideSpinner(component);
                });
                $A.enqueueAction(action);*/
            }                    
        }
    },
    doInit : function(component,event, helper){
       
        helper.showSpinner(component);
        
        var firecontenttypefiltersearch = false;
        var params = window.location.href.split("?");
        var firesalesAidssearch = false;
        var contenttype;
        if(params != undefined){
            if(params.length > 1){
                for(var i = 1;i < params.length;i++){
                    var paramlist = params[i].split('&');
                    
                    if(paramlist != undefined && paramlist.length > 0){
                        for(var j=0;j<paramlist.length;j++){
                            var param = paramlist[j].split("=");
                            console.log(param);
                            if(param.length == 2){
                                if(param[0] == 'salesaids' && param[1] == 'true'){
                                    firesalesAidssearch = true;                               
                                }else if(param[0] == 'contenttype'){
                                    contenttype = param[1];  
                                    firecontenttypefiltersearch = true;
                                } 
                            }  
                        }
                        
                    }
                    
                }
            }
        }     
        // alert(firesalesAidssearch);
        if(firesalesAidssearch){           
            component.set("v.showsalesaids", true);
            console.log('@@ showsalesaids==>'+component.get("v.showsalesaids"));
            component.set("v.salesKit", false);
            component.set("v.products", null);
            component.set("v.documents", null);
            component.set("v.selectedQuickLink", 'Sales Aids');
            component.set("v.quickLink", false);
            
            
            
            //search sales aids
            var compEvent = $A.get("e.c:SearchSalesAidsEvent");
            console.log(compEvent);
            compEvent.setParams({
                "selectedProducts" : "",
                "selectedContentTypes" : "",
                "searchstring" : ""
            });
            compEvent.fire();
        }

        //fire the content type filter if passed in url        
        if(firecontenttypefiltersearch){
            var tempSelectedContentType = [];
            var blankMap = [];
            tempSelectedContentType[0] = contenttype;
            helper.fetchAllProducts(component, event, helper,null,blankMap,tempSelectedContentType, true);
            /*var appEvent = $A.get("e.c:ProductSearchEvent");
            appEvent.setParams({
                "message" : "",
                "selectedoption": blankMap,
                "selectedcontents": tempSelectedContentType
            });
            appEvent.fire();  */         
        } else{
            //helper.fetchAllProducts(component, event, helper,null,null,null, false);
             window.setTimeout(
                 $A.getCallback(function() {
                     helper.hideSpinner(component);
                 }), 2000
             );
            
        }
    },
    showhidesection : function(component, event, helper) {
        var iconname = component.get("v.iconname");
        if(iconname == "chevron-down"){
            component.set("v.iconname","chevron-right pad-2");
            component.set("v.hidesection","slds-is-collapsed");
        }else{
            component.set("v.iconname","chevron-down");
            component.set("v.hidesection","slds-is-expanded");
        }
    }
})