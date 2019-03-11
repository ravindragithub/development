({
	handlePortalViewChange: function(component, event, helper) {
        var selectedOption = event.getParam("selectedOption");
        component.set("v.selectedView", selectedOption);
        var action = component.get("c.Documentlistgetall");
        action.setParams({ selectedView : selectedOption });
        console.log("portal view is: " + selectedOption );
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Documentlist", response.getReturnValue());
                console.log("success " + response.getReturnValue() )
            } else{
                console.log("state = " +state)
            }
        });
        $A.enqueueAction(action);
    },
    sortByName: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },
    sortByDate: function(component, event, helper) {
        helper.sortBy(component, "Created_Date__c");
    },
    download : function (component,event,helper) {
        var TC = component.get("v.document.ct.Product_Document__r.Display_Terms_and_Conditions_Page__c");
        var ht = component.get("v.document.ct.Product_Document__r.Display_HTML_Page__c");
        console.log('TC' + TC);
        console.log('ht' + ht);
        if(TC || ht){
        window.open(
            $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/TCandHTML?id="+component.get("v.document.ct.Product_Document__c"),
            "", "width=500,height=500");
        } else{
            window.open( 
                $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/downloaddocument?id="+component.get("v.document.ct.Product_Document__c"),
            "", "width=500,height=500");
        }

    }
})