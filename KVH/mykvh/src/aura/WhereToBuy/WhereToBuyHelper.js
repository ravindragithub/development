({
	searchhelper : function(component) {
		 try {
            var valid = true;
            component.set('v.errorMessage',null);
            
            //alert(component.get('v.selectedState'));
            console.log(component.get("v.selectedSector"));
            console.log(!component.get("v.selectedSector"));
            console.log(component.get("v.selectedSector") == "Select Sector (Required)");
            console.log(component.get("v.selectedSector") == "None");
            
            
            if(!component.get("v.selectedCountry") || component.get("v.selectedCountry") === 'None'){
                component.set("v.countryNotSelected", true);
                valid = false;
            }else if(!component.get('v.zipcode') &&
               (component.get("v.dependentFlag") && (!component.get('v.selectedState')|| component.get('v.selectedState') === "None"))){
                component.set("v.stateNotSelected", true);
                component.set("v.zipNotEntered", true);
                valid = false;
            }else if(!component.get("v.selectedMarket") || component.get("v.selectedSector") == "None" || component.get("v.selectedMarket") == "Select Market (Required)"){
                component.set("v.marketNotSelected", true);
                valid = false;
            }else if(!component.get("v.selectedSector") || component.get("v.selectedSector") == "None" || component.get("v.selectedSector") == "Select Sector (Required)" || component.get("v.selectedSector") == "Select Market (Required)"){
                component.set("v.sectorNotSelected", true);
                valid = false;
            }else if(!component.get("v.prodId") || component.get("v.prodId") == "None"){
                component.set("v.productNotSelected", true);
                valid = false;
            }
            if(valid){
                component.set("v.countryNotSelected", false);
                component.set("v.stateNotSelected", false);
                component.set("v.zipNotEntered", false);
                component.set("v.marketNotSelected", false);
                component.set("v.sectorNotSelected", false);
                component.set("v.productNotSelected", false);
                component.set("v.spinner", true);
                setTimeout(function(){ console.log("WhereToBuyController.js search"); }, 5000);
                var action = component.get("c.searchPartner");
                action.setParams({
                    zipcode : component.get("v.zipcode"),
                    country : component.get("v.selectedCountry"),
                    market : component.get("v.selectedMarket"),
                    sector : component.get("v.selectedSector"),
                    prodId : component.get("v.prodId"),
                    distance : component.get("v.selectedDistance"),
                    unit : component.get("v.selectedUnit"),
                    searchOption : component.get("v.selectedSearch"),
                    state : component.get("v.selectedState")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //show partner section
                        var showpartnerevent = $A.get("e.c:showwheretobuypartnersection");
                        showpartnerevent.setParams({
                                "show" : true
                            });
                        showpartnerevent.fire();
                        //console.log(response.getReturnValue().accountlist);
                        //console.log(response.getReturnValue().filter);
                        var event = $A.get("e.c:SendPartners");
                        if (component.get('v.zipcode')){
                        	event.setParams({
                                "partners" : response.getReturnValue().accountlist,
                                "productId" : component.get("v.prodId"),
                    			"searchOption" : component.get("v.selectedSearch"),
                                "stateCountry" : component.get("v.zipcode") + "_" + response.getReturnValue().country,
                                "location" : component.get("v.zipcode") + ", " + component.get("v.selectedCountry")
                            });
                        }else if (component.get("v.dependentFlag")){
                        	event.setParams({
                                "partners" : response.getReturnValue().accountlist,
                                "productId" : component.get("v.prodId"),
                    			"searchOption" : component.get("v.selectedSearch"),
                                "stateCountry" : response.getReturnValue().state + "_" + response.getReturnValue().country,
                                "location" : component.get("v.selectedState") + ", " + component.get("v.selectedCountry")
                            });
                        }else{
                        	event.setParams({
                                "partners" : response.getReturnValue().accountlist,
                                "productId" : component.get("v.prodId"),
                    			"searchOption" : component.get("v.selectedSearch"),
                                "stateCountry" : response.getReturnValue().country,
                                "location" : component.get("v.selectedCountry")
                            });
                        }
                        event.fire();
                        
                        
                        component.set("v.spinner", false);
                    }else if (state === "INCOMPLETE") {
                        console.log(state);
                		component.set("v.spinner", false);
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
                        component.set("v.spinner", false);
                    }
                });
                $A.enqueueAction(action);
            }else{
                console.log('state');	
                var event = $A.get("e.c:SendPartners");
                event.setParams({
                    "partners" : undefined,
                    "productId" : undefined,
                    "searchOption" : undefined,
                    "stateCountry" : undefined,
                    "location" : undefined
                });
                event.fire();
                var event = $A.get("e.c:UpdateWhereToBuyMap");
                event.setParams({accountList : undefined});
                event.setParams({productId : undefined});
                event.setParams({searchOption : undefined});
                event.setParams({stateCountry : undefined});
                event.fire();
                component.set("v.spinner", false);
            }
        }catch(err) {
            console.log(err);
            component.set("v.spinner", false);
        }
	},
    fetchProductIdFromURL : function(component,urlstr){
        component.set("v.selectedSearch", "WhereToBuy");
        component.set("v.WhereToBuychecked", true);
        component.set("v.WhereToServicechecked", false);
        
        var params = urlstr.split("?");
        var ProductID = '';
        var isService = false;
        
        if(params != undefined){
            if(params.length > 1){
                for(var i = 1;i < params.length;i++){
                    var paramlist = params[i].split('&');
                   
                    if(paramlist != undefined && paramlist.length > 0){
                        for(var j=0;j<paramlist.length;j++){
                            var param = paramlist[j].split("=");
                            console.log(param);
                            if(param.length == 2){
                                
                                if(param[0] == 'ProductID'){
                                    ProductID = param[1];   
                                }else if(param[0] == 's' && param[1] == 'service'){
                                    isService = true;
                                    component.set("v.selectedSearch", "WhereToService");                                   
                                    component.set("v.WhereToBuychecked", false);
        							component.set("v.WhereToServicechecked", true);
                                } 
                            }  
                        }
                        
                    }
                    
                }
            }
            
        } 
        
        if(ProductID != '')
            component.set("v.productId",ProductID);
       // alert(ProductID);
        component.set("v.isService",isService);
       
    },
    
    blankDefaultIds : function (component,event,helper) {
        alert("hello");
        var blankvalues;
        component.set("v.defaultproductId", blankvalues);
        component.set("v.defaultMarket", blankvalues);
        component.set("v.defaultSector", blankvalues);        
    }
})