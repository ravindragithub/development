/**
 * Created by Jai Chaturvedi on 04/04/2017.
 */
({
    createFilter : function(component) {
        console.log("FilterOptionsHelper.js-createFilter");
        //Check if script is loaded and ready to use
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        var defaultproductId = component.get("v.defaultproductId");
        //Getting the tree div element
        var ratingElem = component.find("jstreeWhereToBuy").getElement();
        console.log(ratingElem);
        var methodName = "c." + component.get("v.methodName") ;
        var action = component.get(methodName);
        console.log(component.get("v.filterCollection"));
        if(component.get("v.filterCollection")){
            action.setParams({
                filterCollection: component.get("v.filterCollection"),
                defaultProductId: defaultproductId
                
            });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // component.set("v.defaultproductId",'');
                console.log('return data');
                console.log(response.getReturnValue());
                $(ratingElem).jstree({
                    'core': {
                        'worker':false,
                        'multiple' : false,
                        'data': response.getReturnValue() ,
                        'themes' : {
                            'icons':false,
                            'dots': false // no connecting dots between dots
                        },
                        'expand_selected_onload':false
                    },
                    'checkbox' : {
                        'keep_selected_style' : false,
                        'three_state' : true //to avoid that fact that checking a node also check others
                    },
                    'plugins' : [ 'checkbox','sort','unique'],
                    
                })
                .on('loaded.jstree', function (e, data) {
                     $(ratingElem).find('li.jstree-open > a.jstree-anchor > i.jstree-checkbox, li.jstree-closed > a.jstree-anchor > i.jstree-checkbox').hide();
                })
                .on('open_node.jstree close_node.jstree', function (e, data) {
                    $(ratingElem).find('li.jstree-open > a.jstree-anchor > i.jstree-checkbox, li.jstree-closed > a.jstree-anchor > i.jstree-checkbox').hide();
                }).on('changed.jstree', function(e, data) {
                    console.log('changed.jstree');
                    var i, j, r = [];
                    if (data.instance.is_leaf(data.node)){
                        for (i = 0, j = data.selected.length; i < j; i++) {
                            r.push(data.instance.get_node(data.selected[i]).data.uniqueID);
                        }
                        var compEvent = component.getEvent('filterOptionEvent');
                        compEvent.setParams({
                            'sectionName': component.get('v.parentSection'),
                            'selectedOption' : r
                        });
                        compEvent.fire();
                    }
                    //alert(data.node.id + ' ' + data.node.text +
                    // (data.node.state.checked ? ' CHECKED': ' NOT CHECKED'))
                }).on('activate_node.jstree', function(e, data) {
                    if(!data.instance.is_leaf(data.node)) {
                        data.instance.deselect_node(data.node, true);
                    }
                }).on('ready.jstree', function () { 
                    //alert(defaultproductId);
                    if(defaultproductId == undefined)
                    	$(this).jstree('close_all');
                    //$(this).jstree("open_node", "ul > li:first");
                    if(defaultproductId != undefined){
                   		$(ratingElem).find('li.jstree-open > a.jstree-anchor > i.jstree-checkbox, li.jstree-closed > a.jstree-anchor > i.jstree-checkbox, li.jstree-node > a.jstree-anchor > i.jstree-undetermined').hide();
                	}
                    
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