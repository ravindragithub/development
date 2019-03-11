/**
 * Created by Jai Chaturvedi on 11/03/2017.
 */
({
    manageOptionValues: function(component) {
        var optionObject = component.get("v.portalOptions");
        console.log('optionObject');
        console.log(optionObject);
        var tempArray = [];
		
        for (var key in optionObject) {
            if (optionObject.hasOwnProperty(key)) {
                var tempObj = optionObject[key];
                if (tempObj.optionLabel !== component.get("v.currentOption")) {
                    tempArray.push(tempObj.optionLabel);
                }else{
                    component.set("v.optionBgColor", tempObj.bgOptionColor);
                    component.set("v.optionSize", tempObj.optionLabel.length);
                    component.set("v.bgOptionImage",tempObj.bgOptionImage);
                }
            }
        }
        component.set("v.remainingOptions",tempArray);
    },

    handleAvailableServiceEventHelper: function(component, event, helper, selectedOption) {
        var action = component.get("c.constructServices");
        action.setParams({
            selectedPortalView: selectedOption
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serviceArray = response.getReturnValue() ;
                helper.fireserviceEvent(component, event, helper,serviceArray);
				/*console.log("serviceArray");
                console.log(serviceArray);
                for( var i=0, l=serviceArray.length; i<l; i++ ) {
                    var singleServiceObject = serviceArray[i] ;
                    var appEvent = $A.get("e.c:PlaceAvailableServicesEvent");
                    appEvent.setParams({
                        "serviceName": singleServiceObject.serviceLabel,
                        "serviceAvailable": singleServiceObject.available,
                        "kvhUserRole": singleServiceObject.currentUser.myKVH_Role__c,                        
                    });
                    appEvent.fire();
                }*/

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    //console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fireserviceEvent : function(component, event, helper, serviceArray){
        	

    	    //alert("hello");
            console.log("serviceArray");
            console.log(serviceArray);
            for( var i=0, l=serviceArray.length; i<l; i++ ) {
                var singleServiceObject = serviceArray[i] ;
                var appEvent = $A.get("e.c:PlaceAvailableServicesEvent");
                console.log('@@@ fireserviceEvent ');
                console.log(singleServiceObject.currentUser);
                appEvent.setParams({
                "serviceName": singleServiceObject.serviceLabel,
                "serviceAvailable": singleServiceObject.available,
                "kvhUserRole": singleServiceObject.currentUser.myKVH_Role__c,                        
            });
                appEvent.fire();
        
        }
	},
    updateUserPortalView : function(component, event, helper, selectedOption){
        var action = component.get("c.setPortalviewForLoginUser");
       // alert(selectedOption);
        action.setParams({
            portalOption: selectedOption
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    //console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
    },

    onSelectChangeHelper: function(component, event, helper, selected) {
        var appEvent = $A.get("e.c:PortalViewOptionEvent");
        appEvent.setParams({
            "selectedOption": selected,
            "bgOptionImage" : component.get("v.bgOptionImage"),
            "bgColor" : component.get("v.optionBgColor")
        });
        appEvent.fire();
    },
    onSelectChangeHelper2: function(component, event, helper, selected) {
        var appEvent = $A.get("e.c:PortalViewChangeEvent");
        appEvent.setParams({
            "selectedOption": selected
        });
        appEvent.fire();
    },
    fetchCartInfo: function(component, event, helper) {
       
       
        var action = component.get("c.fetchCartInfo");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                if(response.getReturnValue().cartId != undefined)
                	component.set("v.cartId",response.getReturnValue().cartId);
                if(response.getReturnValue().itemCount != undefined){
                    component.set("v.lineitemcount",response.getReturnValue().itemCount);
                }else{
                    component.set("v.lineitemcount",0);
                }
					
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message on handleAvailableServiceEvent: " +errors[0].message);
                    }
                } else {
                    //console.log("Unknown error handleAvailableServiceEvent");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showsalesAidsCart: function(component, event, helper,cartinfo) {
    	var url = window.location.href ;
        if(cartinfo != undefined){
             //set cart info
            if(cartinfo.cartId != undefined)
                component.set("v.cartId",cartinfo.cartId);
            if(cartinfo.itemCount != undefined){
                component.set("v.lineitemcount",cartinfo.itemCount);
            }else{
                component.set("v.lineitemcount",0);
            }
        }
        if(url.indexOf("salesaids") > -1){            
            if(cartinfo == undefined){
            	helper.fetchCartInfo(component,event,helper);
            }
        }
    },
    toggleSpinner: function(cmp, event, helper) {
        var appEvent = $A.get("e.c:portalHideHomePageSpinner");             
		appEvent.fire();    }
})