({
    
    callServer: function(component, method, callback, params, cacheable) {
        var action = component.get(method);
        if (params) action.setParams(params);
        if (cacheable) action.setStorable();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback.call(this, response.getReturnValue());
                this.hideSpinner(component);
            } else if (state === "INCOMPLETE") {
                console.log('incomplete');
                this.hideSpinner(component, event);
            } else if (state === "ERROR") {
                console.log('ERROR: ');
                console.log(response);
                this.hideSpinner(component);
            }
        }) ;
        $A.enqueueAction(action);
    },
    showSpinner: function(component) {
        console.log('showhelper');
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner : function(component) {         
        console.log('hidehelper');
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    fetchAllProducts : function(component,event, helper,message,selectedoption,selectedcontents, init){
        //alert("hello");
        helper.showSpinner(component);
        
        var action = component.get("c.getProducts");
        //Setting parameters for server side call
        action.setParams({
            searchString : null,
            productIds : null,
            contentType : null
        });
        //Firing server side call
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                console.log('data loaded');
                //Preparing Product list
                if(response.getReturnValue().products){
                    component.set("v.allProducts", response.getReturnValue().products);
                    console.log(response.getReturnValue().products);
                }else{
                    component.set("v.allProducts", []);
                }
                //Preparing Document list
                if(response.getReturnValue().documents){
                    console.log('setting docs');
                    console.log(response.getReturnValue().documents);
                    component.set("v.allDocuments", response.getReturnValue().documents);
                    console.log(component.get("v.allDocuments"));
                }else{
                    console.log('no docs');
                    component.set("v.allDocuments", []);
                }
                if(init){
                    console.log('in init');
                    this.filterProducts(component,event, helper,message,selectedoption,selectedcontents, false, false);
                    console.log(selectedcontents);
                    component.set("v.searchpanel", true);
                    component.set("v.quickLink", false);
                    component.set("v.salesKit", false);
                    var appEvent = $A.get("e.c:QuickLinkAppEvent");
                    appEvent.setParams({
                        "contenttypes" : selectedcontents
                    });
                    appEvent.fire();
                }
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
        $A.enqueueAction(action);
    },
    filterProducts : function(component,event, helper,message,selectedoption,selectedcontents, newql, proddet){
        console.log('in filterProducts',selectedcontents);
        var quicklinktemp = component.get("v.selectedQuickLink"); 
        if(selectedoption != null || message != null){
            component.set("v.selectedQuickLink", null); 
        }
        var quicklink = component.get("v.selectedQuickLink");
        if(quicklink == null || newql){
            var docList = component.get("v.allDocuments");
            var prodList  = component.get("v.allProducts");
        } else{
            var docList = component.get("v.documents");
            var prodList  = component.get("v.products");
        }
        component.set("v.selectedQuickLink",quicklinktemp); 
        console.log(selectedoption);
        console.log(prodList);
       // console.log('prodlist length ' + prodList.length);
      //  console.log('doclist length ' + docList.length);
        if(message){
            var mess = message.toUpperCase();
            var searchStrings = mess.split(' ');
        } else{
            var searchStrings = null;
        }
        var filterDocRes = [];
        var filterDocSubs = [];
        var filterDocSub = {};
        var filterDocTypes = [];
        var filterDocType = {};
        var filterProd = [];
        var filterProdLine = {};
        var filterProds = [];
        var v = 0;
        var w = 0;
        var x = 0;
        var y = 0;
        var z = 0;
        var prods = selectedoption;
        console.log('size of docs: '+ docList.length);
        for (var i=0; i<docList.length; i++){
            filterDocSubs = [];
            y=0;
            var d = docList[i];
            for(var l=0; l<d.docSubs.length; l++){
                filterDocRes = [];
                x=0;
                var sub = d.docSubs[l];
                for (var m=0; m<sub.documents.length; m++){
                    var q = 0;
                    var r = 0;
                    var s = 0;
                    var docu = sub.documents[m];
                    var compare = docu.ct.Product_Document__r.Title_Display_Name__c;
                    var title = compare.toUpperCase();
                    if((typeof(message) != "undefined" && message != '' && message != null)  && (typeof(selectedoption) != "undefined" && selectedoption != '' && selectedoption != null) && selectedcontents.length>0){
                        console.log('1');
                        for(n=0;n<prods.length; n++){
                            if(docu.ct.Product_Document__r.Associated_ProductIds__c.indexOf(prods[n]) != -1){
                                q=1;
                            }	
                        }
                        for (n=0; n<searchStrings.length; n++){
                            if(title.indexOf(searchStrings[n]) != -1 || d.doctype.indexOf(searchStrings[n]) != -1){
                                r=1;
                            }
                        }
                        for(n=0; n<selectedcontents.length; n++){
                            if(selectedcontents.includes(d.doctype)){
                                s=1;
                            }
                        }
                        if(q+r+s == 3){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    }
                    else if((typeof(message) != "undefined" && message != '' && message != null) && (typeof(selectedoption) != "undefined" && selectedoption != '' && selectedoption != null)){
                        console.log('2');
                        for(n=0;n<prods.length; n++){
                            if(docu.ct.Product_Document__r.Associated_ProductIds__c.indexOf(prods[n]) != -1){
                                q=1;
                            }	
                        }
                        for (n=0; n<searchStrings.length; n++){
                            if(title.indexOf(searchStrings[n]) != -1 || d.doctype.indexOf(searchStrings[n]) != -1){
                                r=1;
                            }
                        }
                        if(q+r == 2){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    } else if((typeof(message) != "undefined" && message != '' && message != null) && selectedcontents.length>0){
                        console.log('3');
                        for (n=0; n<searchStrings.length; n++){
                            if(title.indexOf(searchStrings[n]) != -1 || d.doctype.indexOf(searchStrings[n]) != -1){
                                r=1;
                            }
                        }
                        for(n=0; n<selectedcontents.length; n++){
                            if(selectedcontents.includes(d.doctype)){
                                s=1;
                            }
                        }
                        if(r+s == 2){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    } else if((typeof(selectedoption) != "undefined" && selectedoption != '' && selectedoption != null) && selectedcontents.length>0){
                        console.log('4');
                        for(n=0;n<prods.length; n++){
                            if(docu.ct.Product_Document__r.Associated_ProductIds__c.indexOf(prods[n]) != -1){
                                q=1;
                            }	
                        }
                        for(n=0; n<selectedcontents.length; n++){
                            if(selectedcontents.includes(d.doctype)){
                                s=1;
                            }
                        }
                        if(q+s == 2){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    } else if(typeof(message) != "undefined" && message != '' && message != null){
                        console.log('5');
                        for (n=0; n<searchStrings.length; n++){
                            if(title.indexOf(searchStrings[n]) != -1){
                                r=1;
                            }
                        }
                        if(r == 1){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    } else if(selectedcontents.length>0){
                        console.log('6');
                        for(n=0; n<selectedcontents.length; n++){
                            if(selectedcontents.includes(d.doctype)){
                                s=1;
                            }
                        }
                        if(s == 1){
                            filterDocRes[x] = docu;
                            x++;
                        }
                        
                    } else {
                        console.log('7');
                        for(n=0;n<prods.length; n++){
                            console.log('ids: ' + docu.ct.Product_Document__r.Associated_ProductIds__c);
                            if(docu.ct.Product_Document__r.Associated_ProductIds__c.indexOf(prods[n]) != -1){
                                q=1;
                            }	
                        }
                        if(q == 1){
                            filterDocRes[x] = docu;
                            x++;
                        }
                    }
                } //closes document loop
                if(filterDocRes.length != 0){
                    
                    filterDocSub = {documents: filterDocRes, subType: sub.subType};
                    filterDocSubs[y] = filterDocSub;
                    y++;
                }
            } //closes docsubs loop
            console.log('@@@@ filterDocSubs');
            console.log(filterDocSubs);
            if(filterDocSubs.length != 0){
                filterDocType = {doctype: d.doctype, docSubs: filterDocSubs, prodIdSet: d.prodIdSet, prodcats: d.prodcats, titles: d.titles};
                filterDocTypes[z] = filterDocType;
                z++;
            }
        } // closes docList loop
        console.log('length: ' + filterDocTypes.length);
        component.set("v.docNumber", filterDocTypes.length);
        component.set("v.documents", filterDocTypes);
        if(proddet){
            console.log('in proddet');
            for(var i=0; i<prodList.length; i++){
                var pid = prodList[i];
                console.log(pid);
                for(var j=0; j<pid.productItemList.length; j++){
                    var pi = pid.productItemList[j];
                    console.log(pi);
                    if(selectedoption.includes(pi.productItem.Product_Market_Sector__r.Product__c)){
                        var productdetail = pi;
                        console.log('made it: ' + productdetail);
                    }
                }
            }
        }else if(searchStrings || selectedoption){
            for(var i=0; i<prodList.length; i++){
                filterProd = [];
                w=0;
                var pid = prodList[i];
                for(var j=0; j<pid.productItemList.length; j++){
                    var pi = pid.productItemList[j];
                    var productname = (pi.productItem.Catalog_Display_Name__c != undefined ? pi.productItem.Catalog_Display_Name__c.toUpperCase() : '');
                    if(selectedoption && searchStrings){
                        for(k=0; k<searchStrings.length; k++){
                            if(selectedoption.includes(pi.productItem.Product_Market_Sector__r.Product__c && productname.indexOf(searchStrings[k]) != -1)){
                                filterProd[w] = pi;
                                w++;
                            }
                        } 
                    } else if(selectedoption){
                        if(selectedoption.includes(pi.productItem.Product_Market_Sector__r.Product__c)){
                            filterProd[w] = pi;
                            w++;
                        }
                    } else {
                        for(k=0; k<searchStrings.length; k++){
                            if(productname.indexOf(searchStrings[k]) != -1){
                                filterProd[w] = pi;
                                w++;
                            }
                        }
                    }
                } if(filterProd.length > 0){
                    filterProdLine = {prodLineSeries: pid.prodLineSeries, productItemList: filterProd};
                    filterProds[v] = filterProdLine;
                    v++;
                }   
            }
        } else{
            filterProds = prodList;
        }
        if(proddet){ //if this is a product detail page sorting
            component.set("v.product", productdetail);
            component.set("v.document", filterDocTypes);
        } else{
            component.set("v.products", filterProds);
        }
        
        if(filterProds.length == 0 && filterDocTypes.length == 0){
            component.set("v.noResultFlag", true);
        } else{
            component.set("v.noResultFlag", false);
        }  
    }
})