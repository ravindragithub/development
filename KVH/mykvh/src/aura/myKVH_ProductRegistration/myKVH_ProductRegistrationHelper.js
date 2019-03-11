({
    validateForm: function(component){
        var prodRegistration = component.get('v.prodRegistration');
        var validLTE = false;
        if(component.get("v.accountRequired")){
            component.find("accordion").set('v.activeSectionName', 'Account');
            this.showToast('error', 'Error!', 'Please enter all required fields in the "Account" section above.');
        }else if($A.util.isUndefined(component.get("v.installationRequired")) || component.get("v.installationRequired")){
            component.find("accordion").set('v.activeSectionName', 'Installation');
            this.showToast('error', 'Error!', 'Please enter all required fields in the "Installation" section above.');
        }else if($A.util.isUndefined(component.get("v.systemRequired")) || component.get("v.systemRequired")){
            component.find("accordion").set('v.activeSectionName', 'System');
            this.showToast('error', 'Error!', 'Please enter all required fields in the "System" section above.');                      
        }else if(prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c=='Yes' && 
                 prodRegistration.Subscriber_Country__c=='United States' && ($A.util.isUndefined(component.get("v.providerAccRequired")) || component.get("v.providerAccRequired"))){            
            component.find("accordion").set('v.activeSectionName', 'ProviderAccount');
            this.showToast('error', 'Error!', 'Please enter all required fields in the "Provider Account" section above.');                      
        }else{
            validLTE = true;
        }
        return(validLTE);
    },
    saveProductRegistration: function(component, helper){
        component.set("v.spinner", true);
        component.set("v.submitFormOnce", true);
        var action = component.get("c.saveProductRegistration");
        action.setParams({ updateProdReg : component.get("v.prodRegistration") });        
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state ::' + state);
            if(state === "SUCCESS"){
                if(response.getReturnValue()=='Success'){
                    helper.redirectToThankYou();
                    component.set("v.submitFormOnce", false);
                    component.set("v.spinner", false);
                }else{
                    component.set("v.submitFormOnce", false);
                    component.set("v.spinner", false);
                }
            }else if (state === "ERROR") {
                var errors = action.getError();
                console.log('errors ::' + errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.submitFormOnce", false);
                        component.set("v.spinner", false);
                        var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
                        sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
                        helper.showToast('error', 'Error!',sMsg);   
                        console.log("Error message: " + errors[0].message);
                    }
                } 
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
                component.set("v.submitFormOnce", false);
                component.set("v.spinner", false);
            }
        });    
        $A.enqueueAction(action);      
    },
    redirectToThankYou: function() {
        var address = '/mykvh-product-registration-confirmation/';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address,
            "isredirect" :false
        });
        urlEvent.fire();        
    },
    callAction: function(component, method, callback, params){
        component.set("v.spinner", true);
        var action = component.get(method);
        if(params) action.setParams(params);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                if(response.getReturnValue()){
                    callback.call(this, response.getReturnValue());
                }
                component.set("v.spinner", false);
            }else if(state === "INCOMPLETE"){
                this.showToast('error', 'Error!', 'Unknown error');
                component.set("v.spinner", false);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        this.showToast('error', 'Error!', errors[0].message);
                    }
                }else{
                    this.showToast('error', 'Error!', 'Unknown error');
                }
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getCountryOpts: function(component,countryList){
        var opts = [];
        if(countryList.length>0){
            for(var i in countryList){
                var contryOpt = {};
                contryOpt.label = countryList[i].TrimmedName__c;
                contryOpt.value = countryList[i].IsoCode_2__c;
                opts.push(contryOpt);
            }
        }
        component.set("v.countryOptions", opts);
    },
    showToast: function(typ, titl, msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": typ,
            "title": titl,
            "message": msg
        });
        toastEvent.fire();
    },
    setScroller: function(indexId){
        var xdiv = document.getElementById(indexId);
        var box = { left : 0 ,top : 0};
        try{
            box = xdiv.getBoundingClientRect();
        }
        catch(e){}
        var x = box.left;
        var y = box.right;
        window.scrollTo(y,x);
    }
})