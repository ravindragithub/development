({
	handleValueChange : function(component, event, helper) {
        console.log("Component Value Change Handler invoked!");
        var statusLog = component.get("v.messages");
        statusLog.push({timeStamp: new Date().toUTCString(), value: event.getParam("value")});
        component.set("v.messages", statusLog)
	}
})