({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            //console.log('==runningUser==' + JSON.stringify(a.getReturnValue()));
            component.set("v.runningUser",a.getReturnValue());            
        });
        $A.enqueueAction(action);
        
    },
    navtoprofile : function(component) {
                
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mykvh-my-profile"
        });
        urlEvent.fire();
    },
    refreshHome : function(component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });        
        urlEvent.fire();        
    },
    navtochangePassword : function(component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mykvh-changepassword"
        });
        urlEvent.fire();
    },
    logout : function(component, event, helper) {
        var commURL = $A.get("$Label.c.myKVH_community_url");
        if(commURL.indexOf(".force")>0){
			commURL = commURL.substring(0,commURL.length-3);
           
        }
        var redirectURL = commURL+'/secur/logout.jsp?retUrl=' + $A.get("$Label.c.myKVH_community_url") + 'login/';
        window.location.replace(redirectURL);
    },
})