({
    
    showstatelisthelper : function(component, event, helper,selectedSate) {
        console.log('@@@ in showstatelisthelper');
        var country = component.find("countryOpt").get("v.value");
        console.log('@@@ this is the country' + country);
        var Map = component.get("v.stateOptions");
        console.log('@@@ map --> ' + Map);
        var states = country != undefined ? Map[country] : [];
        console.log('@@@ states --> ' + states);
        console.log('next line is states.length');
        
        //console.log(states.length > 0);
        console.log('line above messes it up');
        //alert(selectedSate);
        if(states != undefined){
            console.log('state is not undefined');
            
            if(states.length > 0){
                component.set("v.hasstateoptions",true);
                console.log("in if");
                var opt = '[ {"label" : "--None--", "value" : ""}';
                for(var i=0;i<states.length;i++){
                    var state = states[i];
                    //alert(state.Label.toUpperCase() == selectedSate.toUpperCase());
                    if(selectedSate != undefined && selectedSate != '' && ( selectedSate.toUpperCase() == state.IsoCode__c.toUpperCase() || state.Label.toUpperCase() == selectedSate.toUpperCase() )){
                        component.set("v.userdetail.con.MailingState",state.FullIsoCode__c);
                        opt += ',{ "label" : "' + state.Label + '", "value" : "' + state.FullIsoCode__c  + '", "selected" : "true"}';
                    }else{
                        opt += ',{ "label" : "' + state.Label + '", "value" : "' + state.FullIsoCode__c + '"}';    
                    }                
                }
                opt += "]";
                console.log(opt);
                component.find("stateselectlist").set("v.options",JSON.parse(opt));
            }else{
                component.set("v.hasstateoptions",false);
                component.find("stateselectlist").set("v.options",JSON.parse('[]'));
            }  
        }
        else{
            console.log('state is undefined');
        }   
    },
    
    saveTCAgree : function(component, event, helper) {
        var action = component.get("c.agreeTC");
        var userdetails = component.get("v.userdetail");
        console.log(userdetails);
        action.setParams({
            userdetailJson : JSON.stringify(userdetails)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                component.set("v.showpopup",false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message on profile load: " +errors[0].message);
                    }
                } else {
                    console.log("Unknown error profile view");
                }
            }
        });
        $A.enqueueAction(action);
    }
})