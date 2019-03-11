({
    search : function(component, event, helper) {
        helper.showSpinner(component);
        window.setTimeout(
            $A.getCallback(function() {
                var selectedActProducts = component.get("v.selectedProductsAct");
                var selectedRetProducts = component.get("v.selectedProductsRet");
                var selectedProducts = [];
                
                if(selectedActProducts.length >0 && selectedRetProducts.length >0){
                    selectedProducts.push(selectedActProducts);
                    selectedProducts.push(selectedRetProducts);
                } else if (selectedActProducts.length >0){
                    selectedProducts = selectedActProducts;
                } else if (selectedRetProducts.length >0) {
                    selectedProducts = selectedRetProducts;
                }
                if(selectedProducts.length >0){
                    var tempProduct = selectedProducts.filter(function(prod){
                        return (prod.indexOf('prodId') != -1);
                    });
                    console.log(tempProduct);
                    var tempProductMap = tempProduct.map(function(prod, index, array){
                        return prod.split(':')[1] ;
                    });
                    console.log(tempProductMap);
                }
                var selectedContents= component.get("v.selectedContent");
                var tempContentsMap = selectedContents.map(function(prod, index, array){
                    return prod.split(':')[1] ;
                });
                console.log(tempContentsMap);
                var searchstring = component.get("v.searchString");
                console.log(searchstring);
                var appEvent = $A.get("e.c:ProductSearchEvent");
                appEvent.setParams({
                    "message" : searchstring,
                    "selectedoption": tempProductMap,
                    "selectedcontents": tempContentsMap
                });
                appEvent.fire();
                helper.hideSpinner(component);
            }), 1
        );
        
    },
    clear : function(component,event,helper) {
        helper.showSpinner(component);
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.selectedProducts", []);
                component.set("v.selectedContent", []);
                component.set("v.searchString", '');
                console.log('in clear event');
                var appEvent = $A.get("e.c:ClearOptionsEvent");
                appEvent.fire();
                console.log('back from clear');
                helper.hideSpinner(component);
            }), 1
        );
    },
    
    handleFilterEvent : function(component, event, helper){
        helper.showSpinner(component);
        window.setTimeout(
            $A.getCallback(function() {
                var sectionName = event.getParam("sectionName") ;
                var selectedOption = event.getParam("selectedOption") ;
                console.log('selectedOption' + selectedOption+ ' section: '+ sectionName);
                var act = component.get("v.selectedProductsAct");
                var ret = component.get("v.selectedProductsRet");
                var selectedProducts = [];
                if(sectionName && selectedOption){
                    if(sectionName === 'Active Products'){
                        component.set("v.selectedProductsAct", selectedOption); 
                    }else if(sectionName === 'Content Types'){
                        component.set("v.selectedContent", selectedOption);
                    } else if(sectionName === 'Retired Products'){
                        component.set("v.selectedProductsRet", selectedOption);
                    }
                }
                var activeProducts = component.get("v.selectedProductsAct");
                var retiredProducts = component.get("v.selectedProductsRet");
                var content = component.get("v.selectedContent");
                if(activeProducts.length>0 && retiredProducts.length>0){
                    selectedProducts = activeProducts.concat(retiredProducts);
                } else if(activeProducts.length>0){
                    selectedProducts = activeProducts;
                } else if(retiredProducts.length>0){
                    selectedProducts = retiredProducts;
                }
                var tempProduct = selectedProducts.filter(function(prod){
                    return (prod.indexOf('prodId') != -1);
                });
                var tempProductMap = tempProduct.map(function(prod, index, array){
                    return prod.split(':')[1] ;
                });
                var selectedContents= component.get("v.selectedContent");
                var tempContentsMap = selectedContents.map(function(prod, index, array){
                    return prod.split(':')[1] ;
                });
                console.log('map: '+tempProductMap);
                var appEvent = $A.get("e.c:ProductSearchEvent");
                appEvent.setParams({
                    "message" : component.get("v.searchString"),
                    "selectedoption": tempProductMap,
                    "selectedcontents": tempContentsMap
                });
                appEvent.fire();
                helper.hideSpinner(component);
            }), 1
        );
        
    },
    
    handleUpdateSearchEvent : function(component, event, helper){
        helper.showSpinner(component);
        var updateSearch = event.getParam("searchinput") ;
        console.log('string '+updateSearch);
        component.set("v.searchString", updateSearch);
        var selectedActProducts = component.get("v.selectedProductsAct");
        var selectedRetProducts = component.get("v.selectedProductsRet");
        if(selectedActProducts.length >0 && selectedRetProducts.length >0){
            var selectedProducts = selectedActProducts + ',' + selectedRetProducts;
        } else if(selectedRetProducts.length >0){
            var selectedProducts = selectedRetProducts;
        } else {
            var selectedProducts = selectedActProducts;
        } 
        
        var tempProduct = selectedProducts.filter(function(prod){
            return (prod.indexOf('prodId') != -1);
        });
        console.log(tempProduct);
        var tempProductMap = tempProduct.map(function(prod, index, array){
            return prod.split(':')[1] ;
        });
        console.log(tempProductMap);
        var selectedContents= component.get("v.selectedContent");
        console.log('contents: '+ selectedContents);
        var tempContentsMap = selectedContents.map(function(prod, index, array){
            return prod.split(':')[1] ;
        });
        console.log('map: '+tempContentsMap);
        component.set("v.selectedContentMap", tempContentsMap);
        component.set("v.selectedProductsMap", tempProductMap);
        helper.hideSpinner(component);
        document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.add('hideEl');
    }
})