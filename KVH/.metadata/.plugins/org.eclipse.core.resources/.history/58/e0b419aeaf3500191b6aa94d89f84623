/**
 * Created by Jai Chaturvedi on 15/03/2017.
 */
({
    handleClick : function(component, event, helper){
        //console.log(component.get("v.urlLink"));
        //window.location.assign(component.get("v.urlLink")+'?view='+component.get("v.selectedView"));
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: component.get("v.urlLink"),
            isredirect: true
        });
        urlEvent.fire();
    }
})