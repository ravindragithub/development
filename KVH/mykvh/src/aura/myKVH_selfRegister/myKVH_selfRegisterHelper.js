({
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },
    
    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleSelfRegister: function (component, event, helpler) {
        component.set("v.spinner", true);   
        var accountId = component.get("v.accountId");
        var regConfirmUrl = component.get("v.regConfirmUrl");
        var firstname = component.find("firstname").get("v.value");
        var lastname = component.find("lastname").get("v.value");
        var email = component.find("email").get("v.value");
        var includePassword = component.get("v.includePasswordField");
        var emailValue = component.get("v.emailValue");
        var postalValue = component.get("v.postalValue");
        var telephoneValue = component.get("v.telephoneValue");
        var declineValue = component.get("v.declineValue");
        var password = component.find("password").get("v.value");
        var confirmPassword = component.find("confirmPassword").get("v.value");
        var action = component.get("c.selfRegister");
        var extraField = component.get("v.extraFields");
        var extraFields = JSON.stringify(extraField);   // somehow apex controllers refuse to deal with list of maps
        var startUrl = component.get("v.startUrl");
        var destination = component.get("v.destination");
        var serialNumber = component.get("v.serialNumber");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        var isValidMobile = true;
        for(var key in extraField){
            if(extraField[key].fieldPath == 'MobilePhone' && (extraField[key].value == '' ||extraField[key].value == null)){
                isValidMobile = false;
            }        
        }
        console.log(component.get("v.selectedCountry"));
        console.log(component.get("v.selectedState"));
        if (firstname == '' || firstname == null){
            this.showToastHelper(component,'First Name is required.');            
            component.set("v.spinner", false);   
            //component.set("v.errorMessage",'First Name is required.');
            //component.set("v.showError",true);
            return;
        }else if (lastname == '' || lastname == null){
            this.showToastHelper(component,'Last Name is required.');
            component.set("v.spinner", false);   
            //component.set("v.errorMessage",'Last Name is required.');
            //component.set("v.showError",true);
            return;
        }else if (email == '' || email == null){
            this.showToastHelper(component,'Email is required.');
            component.set("v.spinner", false);   
            //component.set("v.errorMessage",'Email is required.');
            return;
        }else if(!email.match(regExpEmailformat)){
            component.set("v.spinner", false);   
            this.showToastHelper(component,'Invalid Email Adress');
            return;
        }else if(!isValidMobile){
            this.showToastHelper(component,'Mobile Phone is required');
            component.set("v.spinner", false);   
            return;
        }       
        else if(component.get("v.selectedCountry") == null || component.get("v.selectedCountry") == ''){
            this.showToastHelper(component,'Country is required');
            component.set("v.spinner", false);   
            return;
        }   
        else if(component.get("v.selectedState") == null || component.get("v.selectedState") == ''){
            this.showToastHelper(component,'State is required');
            component.set("v.spinner", false);   
            return;
        }   
            else if(
                !component.get("v.emailValue") && 
                !component.get("v.postalValue") &&
                !component.get("v.telephoneValue") &&
                !component.get("v.acceptAllValue") &&
                !component.get("v.declineValue")
            )     {
                this.showToastHelper(component,'Please select the type of communication you wish to receive.');
                component.set("v.spinner", false);   
                return;
            }       
        startUrl = decodeURIComponent(startUrl);
        var isemailChecked = component.find("emailCheckbox").get("v.checked");
        action.setParams({firstname:firstname,lastname:lastname,email:email,
                          password:password, confirmPassword:confirmPassword, 
                          accountId:accountId, regConfirmUrl:regConfirmUrl, 
                          extraFields:extraFields, startUrl:startUrl, 
                          includePassword:includePassword, serialNumber:serialNumber, 
                          emailValue:emailValue, postalValue:postalValue, 
                          telephoneValue:telephoneValue,declineValue:declineValue,
                          countryValue:component.get("v.selectedCountry"),stateValue:component.get("v.selectedState"),
                          destination:destination});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            console.log(rtnValue);
            if (rtnValue !== null) {
                rtnValue = rtnValue.substring(1, rtnValue.length-1); 
                console.log(rtnValue);
                var urlText,labelText;
                if(rtnValue == 'User already exists'){
                    rtnValue = '[We recognize you already have a myKVH account. Please click the "Already a myKVH user?" button at the bottom of the page to log in. KVH Airtime Services Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) Phone: +1 401.851.3862  Email: airtimeservices@kvh.com]';
                    this.showToastLoginHelper(component,rtnValue); 
                }
                else if(rtnValue == 'LTE User'){
                    rtnValue = 'You have already registered on myKVH. To activate your TracPhone LTE-1, please {1} here.';
                    urlText = 'https://lteactivate.kvh.com';
                    labelText = 'log in';
                    this.showToastLoginHelper(component,rtnValue,urlText,labelText);  
                }
                    else if(rtnValue == 'Customer Portal User'){
                        rtnValue = 'You are already registered on myKVH as a mini-VSAT Broadband customer. To activate your TracPhone LTE-1, please {1} here.';
                        urlText = 'http://kvh.force.com/mykvh';
                        labelText = 'log in';
                        this.showToastLoginHelper(component,rtnValue,urlText,labelText);  
                    } 
                else                    
                    this.showToastLoginHelper(component,rtnValue);
                component.set("v.spinner", false);   
            }
        });
        $A.enqueueAction(action);
    },
    
    getExtraFields : function (component, event, helpler) {
        var action = component.get("c.getExtraFields");
        action.setParam("extraFieldsFieldSet", component.get("v.extraFieldsFieldSet"));
        action.setCallback(this, function(a){            
            console.log('==='+ a.getReturnValue());
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.extraFields',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    setBrandingCookie: function (component, event, helpler) {        
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    },
    
    showToastHelper : function(component,text) {
        console.log(text);
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Error', 
            "type": "error",
            "duration": "15000",
            'message' : text
        }); 
        showToast.fire();
        console.log('exit');
    },
    showToastLoginHelper : function(component,text,urlText,labelText) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            type: 'warning',
            message: 'text',
            duration:' 15000',
            messageTemplate: text,
            messageTemplateData: ['Already a myKVH user?', {
                url: urlText,
                label: labelText,
            }]
        });
        resultsToast.fire();
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
})