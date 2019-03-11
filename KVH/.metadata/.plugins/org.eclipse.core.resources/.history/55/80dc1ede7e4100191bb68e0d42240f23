({
	initializeSampleTreeData : function(component) {
		console.log("Creating Hierarchy Nodes...");
        component.set("v.hierarchy",
            [{
                Name: "Demo 1",
                children: [
                    {
                        Name: "Child 1",
                        children: [
                            {
                                Name: "Grandchild 1",
                                children: [
                                    
                                ]
                            },
                            {
                                Name: "Grandchild 2",
                                children:[
                                    
                                ]
                            }
                        ]
                    },
                    {
                        Name: "Child 2",
                        children: []
                    }
                ]
            },
			{
				Name: "Demo 2",
				children: [
					{
						Name: "Child 1 of Demo2",
						children: []
					},
					{
						Name: "Child 2 of Demo2",
						children: []
					}
				]
			}]
        );
	},

    initHelp: function(component, event, helper) {
        //helper.initializeSampleTreeData(component);
        console.log("initializing...");
        var toggleDiv = component.find("insert_div");
        $A.util.addClass(toggleDiv, "toggle");

        toggleDiv = component.find("exception_div");
        $A.util.addClass(toggleDiv, "toggle");

        toggleDiv = component.find("success_div");
        $A.util.addClass(toggleDiv, "toggle");

        toggleDiv = component.find("spinner_div");
        $A.util.addClass(toggleDiv, "toggle");

    },

    hideThreeDivs : function(component){  
        console.log("Hiding 3 divs...");
        var toggleDiv = component.find("insert_div");
        $A.util.addClass(toggleDiv, "toggle");

        toggleDiv = component.find("exception_div");
        $A.util.addClass(toggleDiv, "toggle");

        toggleDiv = component.find("success_div");
        $A.util.addClass(toggleDiv, "toggle");
    }
})