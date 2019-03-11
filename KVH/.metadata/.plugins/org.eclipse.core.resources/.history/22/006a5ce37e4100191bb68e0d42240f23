({
	showstatelisthelper : function(component, event, helper,selectedSate) {
        console.log('in showstatelisthelper');
        var country = component.find("countryOpt").get("v.value");
        console.log(country);
        var Map = component.get("v.stateOptions");
        var states = country != undefined ? Map[country] : [];
        console.log(states.length > 0);
        //alert(selectedSate);
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
})