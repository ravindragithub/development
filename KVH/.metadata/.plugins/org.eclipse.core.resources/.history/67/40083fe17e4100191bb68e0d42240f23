/**
 * Created by Jai Chaturvedi on 31/03/2017.
 */
({
    createFilter : function(component) {
        // check in case coming from afterRender,
        // before scripts are loaded
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }

        var mainresult ;
        var ratingElem = component.find("jstree").getElement();

        var action = component.get("c.productSelection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                //mainresult = response.getReturnValue() ;

                        $(ratingElem).jstree({
                            'core': {
                                'data': response.getReturnValue() ,
                                "themes" : {
                                    "dots" : false // no connecting dots between dots
                                },
                                "expand_selected_onload":false
                            },
                            "checkbox" : {
                                "keep_selected_style" : false,
                                "three_state" : true //to avoid that fact that checking a node also check others
                            },
                            "plugins" : [ "checkbox","sort"],

                        }).on("changed.jstree", function(e, data) {
                            console.log("The selected nodes are:");
                             //console.log(data);
                            //console.log(data.node.data.uniqueID);
                            //console.log(data.selected);

                            var i, j, r = [];
                                    for (i = 0, j = data.selected.length; i < j; i++) {
                                        //console.log(data.instance.get_node(data.selected[i]).data.uniqueID);
                                        r.push(data.instance.get_node(data.selected[i]).data.uniqueID);
                                    }
                                console.log(r);
                            //alert(data.node.id + ' ' + data.node.text +
                            // (data.node.state.checked ? ' CHECKED': ' NOT CHECKED'))
                        }).on("ready.jstree", function () {
                            //$(this).jstree("open_all");
                            //$(this).jstree("open_node", "ul > li:first");
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