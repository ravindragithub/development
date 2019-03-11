({    
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
	validateUsername : function(component, event, helper) {        
        var username = component.find("username").get("v.value");
		var action = component.get("c.forgotPass");
        action.setParams({username:username,destination:component.get("v.destination"),
                          serialnumber:component.get("v.serialNumber")});
        action.setCallback(this, function(a){  
            var resultmap = a.getReturnValue();
            console.log(a.getReturnValue());
            
            if(resultmap.success){
                 var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/mykvh-forgot-password-confirm"
                });
                urlEvent.fire();            
            }else if(resultmap.error == 'wrong profile'){
                var profilename = resultmap.profilename;
                var msg = '';
                var redirectURL = '';
                var redirect = false;
                if(profilename == 'myKVH Customer of a Service Provider'){
                    msg = 'We have identified that you do not have access to myKVH Customer Portal. Click "Continue" to redirect to <a href="https://mvm.mykvh.com/">mini-VSAT Manager</a>.';
                    redirectURL = "https://login.mykvh.com/password/new";
                    redirect = true;
                }else if(resultmap.partnerprofile != undefined){
                    msg = 'We have identified that you are a KVH Partner Portal user. Click "Continue" to redirect to the <a href="' + $A.get("$Label.c.Community_URL") + '">Partner Portal</a>.';
                    redirectURL = $A.get("$Label.c.Community_URL")+'/PartnerReset';
                    redirect = true;
                }
                
                if(redirect){
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
                }
            }     
            else{                
                this.showToastHelper(component,resultmap.error);
            }
        });
        component.set("v.spinner",false);
        $A.enqueueAction(action);
    },    
    showToastHelper : function(component,text) {
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Error', 
            "type": "error",
            "mode": 'sticky',
            'message' : text 
        }); 
        showToast.fire(); 
    },    
})