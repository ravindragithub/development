({
    showstatelisthelper : function(component, event, helper,selectedSate) {        
        var country = component.find("countryOpt").get("v.value");
        var action = component.get("c.getstateOptions");
        action.setParams({ "countryCode" : country });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue(); 
            if (state === "SUCCESS") {
                if(!$A.util.isEmpty(result)){
                    var Map = result;
                    var states = country != undefined ? Map[country] : [];
                    if(states.length > 0){
                        component.set("v.hasstateoptions",true);
                        var opt = '[ {"label" : "--None--", "value" : ""}';
                        for(var i=0;i<states.length;i++){
                            var state = states[i];
                            if(selectedSate != undefined && selectedSate != '' && ( selectedSate.toUpperCase() == state.IsoCode__c.toUpperCase() || state.Label.toUpperCase() == selectedSate.toUpperCase() )){
                                component.set("v.userdetail.con.MailingState",state.FullIsoCode__c);
                                opt += ',{ "label" : "' + state.Label + '", "value" : "' + state.FullIsoCode__c  + '", "selected" : "true"}';
                            }else{
                                opt += ',{ "label" : "' + state.Label + '", "value" : "' + state.FullIsoCode__c + '"}';    
                            }                
                        }
                        opt += "]";
                        component.find("stateselectlist").set("v.options",JSON.parse(opt));
                    }
                }
                else{
                    component.set("v.hasstateoptions",false);
                    component.set("v.userdetail.con.MailingState",'');
                }           
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);   
    },
})