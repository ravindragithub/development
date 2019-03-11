({
    validateLTEForm: function(component) {        
        var validLTE = false;
        if(component.get("v.subInfoRequired")){
            component.set("v.newLTEActivationError", "Complete the invalid field in Subscriber Information Section.");            
        }else if(component.get("v.billingInfoRequired")){
            component.set("v.newLTEActivationError", "Complete the invalid field in Billing Information Section.");
        }else if(component.get("v.payInfoRequired")){
            component.set("v.newLTEActivationError", "Complete the invalid field in Payment Information Section.");                      
        }else if(component.get("v.vesselInfoRequired")){
            component.set("v.newLTEActivationError", "Complete the invalid field in Vessel Information Section.");                      
        }else if(component.get("v.onboardRequired")){
            component.set("v.newLTEActivationError", "Complete the invalid field in Onboard Contact Section.");  
        }else if(component.get("v.simpleLTEActivation.Antenna_Serial_No__c") == '' ||
                 component.get("v.simpleLTEActivation.Antenna_Serial_No__c") == null){
            component.set("v.newLTEActivationError", "Complete the invalid field for Antenna Serial Number.");  
        }else{
            validLTE = true;
            component.set("v.newLTEActivationError", "");
        }
        if(!validLTE)
            this.handleShowError(component,component.get("v.newLTEActivationError"));
        return(validLTE);
    },
    
    helperLTERegistration : function(component, event, helper) {
        console.log('SaveLTERegistration ::');
        var action = component.get("c.SaveLTERegistration");
        action.setParams({ updateLTEAct : component.get("v.simpleLTEActivation") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("State ::" + state); 
            if (state === "SUCCESS") {
                console.log("Save completed successfully.");                    
                helper.handleShowModal(component, event, helper);   
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.submitFormOnce", false);
                        component.set("v.spinner", false);
                        var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
                        sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
                        helper.handleShowError(component,sMsg);   
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);      
    },
    handleShowError : function(component,text) {
        var errortext = text;
        var isItFalse = component.get("v.simpleLTEActivation.Inhibit_Transform__c");
        if(isItFalse)  { 
            $A.createComponent(
                'c:LTE_ShowToast_cmp', {
                    title: errortext,                    
                },
                function(newButton, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(newButton);
                        component.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE" || status === "ERROR") {
                        console.log("No response from server or client is offline."+ errorMessage)
                    }
                }
            );
        }
        else{
            var showToast = $A.get("e.force:showToast"); 
            showToast.setParams({ 
                'title' : 'Error', 
                "type": "error",
                "mode": 'sticky',
                'message' : errortext
            }); 
            showToast.fire(); 
        }
    },
    handleShowModal: function(component, event, helper) {
        var isItFalse = component.get("v.simpleLTEActivation.Inhibit_Transform__c");
        if(isItFalse)  {            
            window.location = '/mykvh/apex/LTE_Activation_Portal_Confirm'; 
        } 
        else{
            var address = '/lte-confirmation/';
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": address,
                "isredirect" :false
            });
            urlEvent.fire();
        }
    },
    getCountryHelper : function(component, event, helper) {
        var action = component.get("c.getCountry");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("From server: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var opts = [];
                var i;
                var countryList = response.getReturnValue();
                if(countryList.length != 0){
                    for(i in countryList){                        
                        var detailtemp = {};
                        detailtemp = { 'class': '', 'label': '', 'value': '' };
                        detailtemp.class = "optionClass";
                        detailtemp.label = countryList[i].TrimmedName__c;
                        detailtemp.value = countryList[i].IsoCode_2__c;
                        opts.push(detailtemp);
                    }
                }                
                component.set("v.countryList", opts);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);        
    },    
    getContactHelper : function(component, event, helper) {
        var action = component.get("c.getContactInfo");
        action.setCallback(this, function(response) {
            setTimeout(function () {
                //if (newState == -1) {
                //alert('VIDEO HAS STOPPED');
                //}
            }, 10000);
            var state = response.getState();
            //console.log("From server: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                if(response.getReturnValue().firstName != null && response.getReturnValue().firstName != ''){
                    component.set("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c", response.getReturnValue().firstName);
                    component.set("v.firstnameFlag", true);
                }
                if(response.getReturnValue().lastName != null && response.getReturnValue().lastName != ''){
                    component.set("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c", response.getReturnValue().lastName);
                    component.set("v.lastnameFlag", true);
                }
                if(response.getReturnValue().email != null && response.getReturnValue().email != ''){                    
                    component.set("v.simpleLTEActivation.Subscriber_Email__c", response.getReturnValue().email);
                    component.set("v.simpleLTEActivation.Contact_email__c", response.getReturnValue().email);
                    component.set("v.emailFlag", true);
                }
                if(response.getReturnValue().mobilePhone != null && response.getReturnValue().mobilePhone != ''){
                    component.set("v.simpleLTEActivation.Subscriber_Phone__c", response.getReturnValue().mobilePhone);
                    component.set("v.phoneFlag", true);
                }
                if(response.getReturnValue().country != null && response.getReturnValue().country != ''){
                    component.set("v.simpleLTEActivation.Subscriber_Country__c", response.getReturnValue().country);
                    component.set("v.countryFlag", true);
                }
                if(response.getReturnValue().state != null && response.getReturnValue().state != ''){
                    component.set("v.simpleLTEActivation.Subscriber_State_Province_Territory__c", response.getReturnValue().state);
                    component.set("v.stateFlag", true);
                }
                if(response.getReturnValue().serialNumber != null && response.getReturnValue().serialNumber != ''){
                    component.set("v.simpleLTEActivation.Antenna_Serial_No__c", response.getReturnValue().serialNumber);
                    component.set("v.serviceRequired", false);
                    component.set("v.antennaFlag", true);  
                    component.set("v.simpleLTEActivation.Is_serial_was_passed__c", true);                    
                }
                var device = $A.get("$Browser.formFactor");
                component.set("v.simpleLTEActivation.Device__c", device);    
                component.set("v.simpleLTEActivation.Contact__c", response.getReturnValue().Id);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action); 
    },
    setScroller : function(component,indexId) {
        var xdiv = document.getElementById(indexId);
        var box = { left : 0 ,top : 0};
        try{
            box = xdiv.getBoundingClientRect();
        }
        catch(e){}
        var x = box.left;
        var y = box.right;
        window.scrollTo(y,x);
    },
})