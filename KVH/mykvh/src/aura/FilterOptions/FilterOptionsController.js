({
    afterScriptsLoaded : function(component, event, helper) {
        component.set("v.ready", true);
        helper.createFilter(component);
        var ratingElem = component.find("jstree").getElement();
        $(ratingElem).jstree(true).deselect_all(true);
        document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.add('hideEl'); 
    },
    handleClearEvent : function (component, event, helper){
        console.log('handleClearEvent');
        var ratingElem = component.find("jstree").getElement();
        $(ratingElem).jstree("deselect_all", true);
        document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.add('hideEl');        
    },
    handleQuickAppEvent : function (component, event, helper){
        var ratingElem = component.find("jstree").getElement();
        var section = component.get("v.parentSection");
        if(section == "Content Types"){
            var selectedNodes = event.getParam("contenttypes");
            var arrayLength = selectedNodes.length;
            for (var i = 0; i < arrayLength; i++) {
                console.log('above binding ' + i);
                $(ratingElem).jstree('select_node', selectedNodes[i], true);
                //$(ratingElem).select_node(selectedNodes[i], true);
            }
            console.log('at end');
        }
    }
})