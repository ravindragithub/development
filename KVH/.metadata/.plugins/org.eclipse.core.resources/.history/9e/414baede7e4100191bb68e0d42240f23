({
	showModal: function(component, event, helper) {
    console.log("Handling Application Event!");
    //Dynamically create component embedded in modal so we can re-use Modal!
    //Event shape carries component name as "request" attribute
    var bodyComponent = event.getParam("request");
    var identifier = event.getParam("identifier");
    console.log("Requesting ==> " + bodyComponent);
    $A.createComponent(
      bodyComponent,
      {"identifier": identifier},
      function(newStatusCmp){
        if(component.isValid()){
          var body = component.get("v.body");
          body.push(newStatusCmp);
          component.set("v.body", body);
        }
      }
    );
		 //Toggle CSS styles for opening Modal
		helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
	},

	hideModal : function(component, event, helper) {
    //Clear out the existing values in the body component
    component.set("v.body", []);
    //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
	}
})