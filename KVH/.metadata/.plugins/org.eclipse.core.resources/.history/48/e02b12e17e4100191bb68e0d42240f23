({
	doInit : function(component) {
        console.log('RequestAQuoteController - doInit');
		var url = window.location.href;
        var urlParams = {};
        url.replace(new RegExp("([^?=&]+)(=([^&]*))?", "g"),function($0, $1, $2, $3) {urlParams[$1] = $3;});
        var stateCountry;
        if(urlParams.Location != undefined)
       	 stateCountry = urlParams.Location.split('_');
        var state = '';
        var country = '';
        if (stateCountry.length > 1){
            state = stateCountry[0];
            country = stateCountry[1];
        }else if (stateCountry.length > 0){
            country = stateCountry[0];
        }
        console.log(country); 
        console.log(state); 
        component.set("v.country", country); 
        component.set("v.state", state); 
        var action = component.get("c.getInformation");
        action.setParams({
            "AccountId": urlParams.RepId,
            "ProductID": urlParams.ProductID,
            "searchOption": urlParams.Request
        });
        component.set("v.productId", urlParams.ProductID); 
        component.set("v.searchOption", urlParams.Request); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@ in get event list success');
                //console.log(response.getReturnValue()); 
                var resp =   response.getReturnValue();         
                component.set("v.accountName", resp.accountName);      
                component.set("v.accountStreet", resp.accountStreet);     
                component.set("v.accountCity", resp.accountCity);    
                if (resp.accountState && resp.accountZip){
                    component.set("v.accountStateZip", resp.accountState + ' ' + resp.accountZip);    
                }else if (resp.accountState){
                    component.set("v.accountStateZip", resp.accountState );    
                }else if (resp.accountZip){
                    component.set("v.accountStateZip",  resp.accountZip);    
                }else{
                    component.set("v.accountStateZip", '');
                }
                component.set("v.accountCountry", resp.accountCountry);   
                component.set("v.market", resp.market);      
                component.set("v.sector", resp.sector);     
                component.set("v.product", resp.product); 
                component.set("v.productLine", resp.productLine); 
                component.set("v.productSeries", resp.productSeries); 
                component.set("v.accountId", resp.accountId);     
                component.set("v.contactId", resp.contactId);     
               
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on handlePortalViewChangeEvent: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set('v.errorMessage',null);
    },
    
	requestQuoteWithData : function(component) {
        console.log('RequestAQuoteController - requestQuoteWithData');
        var valid = true;
        if(!component.get("v.salutation") || component.get("v.salutation") == 'None'){
            component.set('v.salutationNotSelected',true);
            valid = false;
        }else{
            component.set('v.salutationNotSelected',false);
        }
        
        if(!component.get("v.firstName")){
            component.set('v.firstNameNotEntered',true);
            valid = false;
        }else{
            component.set('v.firstNameNotEntered',false);
        }
        
        if(!component.get("v.lastName")){
            component.set('v.lastNameNotEntered',true);
            valid = false;
        }else{
            component.set('v.lastNameNotEntered',false);
        }
        
        if(!component.get("v.email")){
            component.set('v.emailNotEntered',true);
            valid = false;
        }else{
            component.set('v.emailNotEntered',false);
        }
        
        if(!component.get("v.phoneNumber")){
            component.set('v.phoneNumberNotEntered',true);
            valid = false;
        }else{
            component.set('v.phoneNumberNotEntered',false);
        }
        
        if (valid){
            component.set("v.spinner", true);
            component.set('v.salutationNotSelected',false);
            component.set('v.firstNameNotEntered',false);
            component.set('v.lastNameNotEntered',false);
            component.set('v.emailNotEntered',false);
            component.set('v.phoneNumberNotEntered',false);
            var action = component.get("c.insertQuoteRequested");
            action.setParams({
                "salutation": component.get("v.salutation") ,
                "firstName": component.get("v.firstName"),
                "lastName": component.get("v.lastName"),
                "email": component.get("v.email"),
                "companyName": component.get("v.companyName"),
                "phoneNumber": component.get("v.phoneNumber"),
                "country": component.get("v.country"),
                "state": component.get("v.state"),
                "market": component.get("v.market"),
                "sector": component.get("v.sector"),
                "comments": component.get("v.comments"),
                "productId": component.get("v.productId"),
                "accountId": component.get("v.accountId"),
                "contactId": component.get("v.contactId") ,
                "company": component.get("v.firstName" + "v.lastName") ,
                "product": component.get("v.product") ,
                "searchOption": component.get("v.searchOption") 
            });
            console.log('actionset');
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('@@ in get event list success');
                    //go to succes page    
                    window.location="/s/requestaquotesuccess";
                   
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message on handlePortalViewChangeEvent: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
	}
})