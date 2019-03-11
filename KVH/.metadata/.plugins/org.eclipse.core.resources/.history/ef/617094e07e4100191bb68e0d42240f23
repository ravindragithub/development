/**
 * Created by Jai Chaturvedi on 8/03/2017.
 */
({
    doInit: function(component,event,helper) {
        
        console.log('1');
		//helper.showsalesAidsCart(component,event,helper);
        var myaction = component.get("c.initPortalView");
        myaction.setCallback(this, function(a) {
            //console.log(a.getReturnValue());
            if(a.getReturnValue() != undefined){
                component.set("v.portalOptions", a.getReturnValue().portalViewOption);
                var portalviewoption = a.getReturnValue().portalViewOption;
               // console.log("@@ portalviewoption");
               // console.log(portalviewoption);
               
               var cartinfo = a.getReturnValue().cartinfo;
               helper.showsalesAidsCart(component,event,helper,cartinfo);
               
                
                if(a.getReturnValue().portalview){
                    component.set("v.currentOption",a.getReturnValue().portalview) ;
                }else if(portalviewoption[0] != undefined){
                    component.set("v.currentOption",portalviewoption[0].optionLabel) ;
                }
    
                helper.manageOptionValues(component);
                /*firing event for top level services.
                 *this will be handle by PartnerMainServicesComponent
                 */
               
                //calling helper method to prepare the available services for selected view
                //This is call apex method which gives the available services
                //helper.handleAvailableServiceEventHelper(component,event,helper,component.get("v.currentOption"));
                
                var serviceArray = a.getReturnValue().availableSvc;
                console.log('@@ serviceArray==>');
                console.log(serviceArray);
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.fireserviceEvent(component, event, helper,serviceArray);
                    }), 2000
                );
                
                window.setTimeout(
                    $A.getCallback(function() {
                         helper.onSelectChangeHelper(component, event, helper, component.get("v.currentOption"));
                          window.setTimeout(
                            $A.getCallback(function() {
                                helper.toggleSpinner(component,event,helper);
                            }), 1000
                         );
                        
                    }), 3000
                );
                
               

                
            }
            
        });
        $A.enqueueAction(myaction);
    },

    onSelectChange: function(component, event, helper) {
        var src = event.getSource();
        var selected = src.get("v.value");
        console.log(selected) ;
       // alert(selected);
        component.set("v.currentOption", selected) ;
        helper.manageOptionValues(component);
        helper.updateUserPortalView(component, event, helper, selected);
        helper.onSelectChangeHelper(component, event, helper, selected) ;
        helper.handleAvailableServiceEventHelper(component, event, helper, selected) ;
        helper.onSelectChangeHelper2(component, event, helper, selected) ;
    },

    showSpinner : function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },

    hideSpinner : function(component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    updateCartHandeler : function(component, event, helper) {
		component.set("v.showcart",true);        
        helper.fetchCartInfo(component,event,helper);
    }
})