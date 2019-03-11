({
    doInit : function(component, event, helper) {
        
        var releaseid = window.location.href.split("?")[1].split("=")[1];
        component.set("v.releaseid",releaseid);
        helper.getNewsDetail(component, event, helper);
    },
    backtoHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },
})