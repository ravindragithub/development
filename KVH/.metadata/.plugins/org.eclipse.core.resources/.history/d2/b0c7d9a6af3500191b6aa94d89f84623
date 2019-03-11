({
    createFilter : function(component) {
        //Check if script is loaded and ready to use
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        //Getting the tree div element
        var ratingElem = component.find("jstree").getElement();
        var methodName = "c." + component.get("v.methodName") ;
		var parent = component.get("v.parentSection");
        var action = component.get(methodName);
        if(component.get("v.filterCollection").length >0){
            action.setParams({
                filterCollection: component.get("v.filterCollection")
            });
        } else if (parent != null){
            action.setParams({
                section: parent
            });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $(ratingElem).jstree({
                    'core': {
                        "worker": false,
                        "data": response.getReturnValue() ,
                        "themes" : {
                            "icons": false,
                            "dots" : false // no connecting dots between dots
                        },
                        "expand_selected_onload": false
                    },
                    "checkbox" : {
                        "keep_selected_style" : false,
                        "three_state" : true //to avoid that fact that checking a node also check others
                    },
                    "plugins" : [ "checkbox","sort"],

                }).on("changed.jstree", function(e, data) {
                    var i, j, r = [];
                    for (i = 0, j = data.selected.length; i < j; i++) {
                        r.push(data.instance.get_node(data.selected[i]).data.uniqueID);
                    }
                    var compEvent = component.getEvent("filterOptionEvent");
                    compEvent.setParams({
                        "sectionName" : component.get("v.parentSection"),
                        "selectedOption" : r
                    });
                    compEvent.fire();
                }).on("ready.jstree", function () {
                    $(this).jstree("close_all");
                    $(this).jstree("close_node", "ul > li:first");
                });
                

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on createFilter: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})