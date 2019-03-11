({
	doInit : function(component, event, helper) {
        
		var releaseid = window.location.href.split("?")[1].split("=")[1];
        component.set("v.releaseid",releaseid);
        helper.getNewsDetail(component, event, helper);
	}
})