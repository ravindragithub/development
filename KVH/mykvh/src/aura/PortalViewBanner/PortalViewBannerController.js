/**
 * Created by Jai Chaturvedi on 25/04/2017.
 */
({
    doInit: function(component) {
        var action = component.get("c.initPortalView");
        action.setCallback(this, function(a) {
            //console.log(a.getReturnValue());
            component.set("v.portalOptions", a.getReturnValue().portalViewOption);

            if(a.getReturnValue().portalview){
                component.set("v.currentOption",a.getReturnValue().portalview) ;
            }
            var optionObject = a.getReturnValue().portalViewOption;

            for (var key in optionObject) {
                if (optionObject.hasOwnProperty(key)) {
                    var tempObj = optionObject[key];
                    if (tempObj.optionLabel === component.get("v.currentOption")) {
                        component.set("v.optionBgColor", tempObj.bgOptionColor);
                        //component.set("v.currentOption", tempObj.optionLabel);
                        component.set("v.optionSize", tempObj.optionLabel.length);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
})