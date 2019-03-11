({
    
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },
    
    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    getUrlParameter : function(component, event, helper) {
        var url = window.location.href;
        var urlParams = {};
        url.replace(new RegExp("([^?=&]+)(=([^&]*))?", "g"),function($0, $1, $2, $3) {urlParams[$1] = $3;});
        var destination = urlParams.de;
        var serialNumber = urlParams.sn;  
        if(destination != undefined){           
            component.set("v.destination",destination);
        }
        
        if(serialNumber != undefined){
            component.set("v.serialNumber",serialNumber);
        }
    },
    validProfileHelper : function (component, event, helper) { 
        component.set("v.showError",false);
        component.set("v.spinner", true);
        var username = component.find("username").get("v.value");        
        var action = component.get("c.validProfile");
        var partnerProfilesLabel = $A.get("$Label.c.Partner_Profiles");
        var partnerProfiles = partnerProfilesLabel.split(',');
        var partnerProfileCheck = false;
        action.setParams({username:username});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            console.log('==rtnValue==' + rtnValue);
            if (rtnValue !== null) {
                for(var i = 0; i < partnerProfiles.length; i++) {
                    if(rtnValue == partnerProfiles[i])
                        partnerProfileCheck = true;
                }    
                var msg = "";
                var redirectURL = ""
                if(rtnValue == 'myKVH Customer of a Service Provider' || partnerProfileCheck){
                    if(rtnValue == 'myKVH Customer of a Service Provider'){
                        msg = 'We have identified that you do not have access to myKVH Customer Portal. Click "Continue" to redirect to <a href="https://mvm.mykvh.com/">mini-VSAT Manager</a>.';
                        redirectURL = "https://mvm.mykvh.com/";
                    }else if(partnerProfileCheck){
                        msg = 'We have identified that you are a KVH Partner Portal user. Click "Continue" to redirect to the <a href="' + $A.get("$Label.c.Community_URL") + '">Partner Portal</a>.';
                        redirectURL = $A.get("$Label.c.Community_URL");
                    }
                    $A.createComponent('c:LoginRedirect_Modal', {
                        message: msg,
                        redirectURL: redirectURL,
                    }, function attachModal(modalCmp, status) {
                        if (component.isValid() && status === 'SUCCESS') {
                            var body = component.get("v.body");
                            body.push(modalCmp);
                            component.set("v.body", body);    
                        }
                    });  
                    
                   /* window.setTimeout(
                        $A.getCallback(function() {
                            if(rtnValue == 'myKVH Customer of a Service Provider')
                               helper.navigateTomyKVH(component, 'https://mvm.mykvh.com/');
                            else if(partnerProfileCheck)
                                helper.navigateTomyKVH(component, 'https://partners.kvh.com/');
                        }), 2000
                    );*/
                }
                else  {
                    this.handleLogin(component, event, helper)
                }
            }
            else  {
                this.handleLogin(component, event, helper)
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    handleLogin: function (component, event, helper) {
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");
        var destination = component.get("v.destination");
        var serialNumber = component.get("v.serialNumber");
        //startUrl = decodeURIComponent(startUrl);
        action.setParams({username:username, password:password, startUrl:startUrl,destination:destination,serialNumber:serialNumber});
        action.setCallback(this, function(a){            
            var rtnValue = a.getReturnValue();
            console.log('==rtnValue==' + rtnValue);
            if (rtnValue !== null) {
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
            }            
            component.set("v.spinner", false); 
        });
        $A.enqueueAction(action);
    },  
    navigateTomyKVH : function(component, urlLink) {
        window.open(urlLink,'_top');
    },
    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isUsernamePasswordEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isSelfRegistrationEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
            console.log(a.getReturnValue());
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communitySelfRegisterUrl',rtnValue);
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
    }
})