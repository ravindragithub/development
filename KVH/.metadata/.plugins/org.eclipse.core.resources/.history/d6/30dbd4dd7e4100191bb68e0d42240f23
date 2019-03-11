/**
 * Created by Jai Chaturvedi on 4/04/2017.
 */
({
    afterScriptsLoaded : function(component, event, helper) {
        console.log("FilterOptionsController.js-afterScriptsLoaded");
        component.set("v.ready", true);
        helper.createFilter(component);
       
    },

    handleClearEvent : function (component, event,helper){
        console.log("FilterOptionsController.js-handleClearEvent");
        var ratingElem = component.find("jstreeWhereToBuy").getElement();
        console.log(ratingElem);
        $(ratingElem).jstree(true).deselect_all();
    }
})