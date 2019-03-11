/**
 * Created by Jai Chaturvedi on 3/08/2017.
 */
({
    initialize : function (component,event,helper) {
        helper.fetchProductIdFromURL(component, window.location.href);
        console.log("WhereToBuyController.js initialize")
        component.set("v.spinner", true);
        var isService = component.get("v.isService");
       // alert(isService);
        var action = component.get("c.loadOptions");
        action.setParams({
            'productId': component.get("v.productId")
        });
       // action.setStorable();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.countries", response.getReturnValue().countries);
                component.set("v.market", response.getReturnValue().market);
                component.set("v.selectedMarket", "Select Market (Required)");
                component.set("v.spinner", false);
                var ms = response.getReturnValue().productmarketsector;
                if(ms != undefined && isService == false){
                    component.set("v.defaultproductId", ms.Product__c);
                    component.set("v.defaultMarket", ms.Market__c);
                    component.set("v.defaultSector", ms.Sector__c);
					component.set("v.countryNotSelected", true);                    
                }
            
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message in wheretobuy initialize: " +
                                    errors[0].message);
                        window.alert("Error message in wheretobuy initialize: " +
                                     errors[0].message);
                    }
                    window.alert("Unknown error try search again");
                } else {
                    console.log("Unknown error");
                    window.alert("Unknown error try search again");
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set('v.errorMessage',null);
    },
    close:function (component) {
        console.log("WhereToBuyController.js close")
        component.set('v.errorMessage',null);
    },
    stateChanged : function (component){
        component.set("v.stateNotSelected", false);
    },
    productChanged : function (component){
        component.set("v.productNotSelected", false);
    },
    zipcodeChanged : function (component){
        //if (component.get('zipcode') != ''){
        component.set("v.zipNotEntered", false);
        //}
    },
    marketChanged : function (component){
       
        if(component.get("v.selectedMarket") != "Select Market (Required)"){
           component.set("v.marketNotSelected", false);
        }
        component.set("v.sectorNotSelected", false);
        component.set("v.productNotSelected", false);
        console.log("WhereToBuyController.js marketChanged");
        component.set('v.filterCollection',null);
        component.set("v.loadFilter",false);
        component.set("v.selectedSector","Select Market (Required)");
        component.set("v.prodId","None")
    },
    
    findDependentFieldName : function (component){
        if(component.get("v.selectedCountry") !== 'None'){
        	component.set("v.countryNotSelected", false);
        }
        component.set("v.stateNotSelected", false);
        console.log("WhereToBuyController.js findDependentFieldName");
        var provinceCountries = ["Canada"];
        component.set('v.selectedState', null);
        if(provinceCountries.indexOf(component.get("v.selectedCountry")) >= 0){
            component.set("v.dpndentCountryPicklist","Select Province")
        }else{
            component.set("v.dpndentCountryPicklist","Select State")
        }
    },
    
    findPrdctLinePrdctSeries : function (component,event,helper){
        console.log("WhereToBuyController.js findPrdctLinePrdctSeries");
        component.set('v.filterCollection',null);
        component.set("v.loadFilter",false);
        component.set("v.prodId","None")
        if(component.get("v.selectedMarket") != "Select Market (Required)" && component.get("v.selectedSector") != "Select Sector (Required)"){
            component.set("v.sectorNotSelected", false);
            var action = component.get("c.searchMarketSector");
            action.setParams({
                market : component.get("v.selectedMarket"),
                sector : component.get("v.selectedSector"),
                searchOption : component.get("v.selectedSearch")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var filters = response.getReturnValue();
                    if(filters != undefined && filters.length>0){
                        component.set("v.filterCollection",response.getReturnValue());
                        component.set("v.loadFilter",true);
                        
                    }else{
                        component.set("v.loadFilter",false); 
                        component.set("v.filterCollection",null);
                    }
                    console.log(component.get("v.filterCollection"));
                    
                }else if (state === "INCOMPLETE") {
                    console.log(state);
                }else if (state === "ERROR") {
                    console.log(state);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message in wheretobuy initialize: " +
                                        errors[0].message);
                            window.alert("Error message in wheretobuy initialize: " +
                                         errors[0].message);
                        }
                        window.alert("Unknown error try search again");
                    } else {
                        console.log("Unknown error");
                        window.alert("Unknown error try search again");
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
        	component.set('v.filterCollection',null);
            component.set("v.loadFilter",false);
        }
    },
    
    search : function (component, event, helper) {
        
       helper.searchhelper(component);
    },
    
    handleFilterEvent : function(component, event){
        console.log("WhereToBuyController.js handleFilterEvent")
        var sectionName = event.getParam("sectionName");
        var selectedOption = event.getParam("selectedOption");
        if(sectionName && selectedOption){
            if(sectionName === 'Select Product (Required)'){
                // component.set("v.selectedProducts", selectedOption);
                //var selectedProducts = component.get("v.selectedProducts");
                var tempProduct = selectedOption.filter(function(prod){
                    return (prod.indexOf('prodId') != -1);
                });
                var prodIds = tempProduct.map(function(prod, index, array){
                    return prod.split(':')[1] ;
                });
                if(prodIds.length > 0){
                	component.set("v.prodId", prodIds[0]);
                }else{
                	component.set("v.prodId", "None");
                }
            }
        }
    },
    
    setSearch : function (component,event) {
        console.log("WhereToBuyController.js setSearch");
        //console.log(event.target.value);
        component.set("v.selectedSearch", event.target.value)
        //console.log(component.get("v.selectedSearch"));
    },
    
    resetState:function (component) {
        console.log("WhereToBuyController.js resetState")
        var zipcode = component.find("zipcode").get("v.value");
        component.set("v.disbaleState",false);
    },
    onRender : function(component, event, helper){
        var deviceHeight = document.documentElement.clientHeight;  
       // alert(deviceHeight);
        if(deviceHeight != undefined && deviceHeight > 200){
            var minHeight = deviceHeight-273;
        	component.set("v.miniheight",minHeight +"px");
        }
        
    }
})