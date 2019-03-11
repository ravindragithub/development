({
	
    showstatelist : function(component, event, helper) {
		helper.showstatelisthelper(component, event, helper,'');
	},
    doInit : function(component, event, helper) {
        
		var action = component.get("c.getUserDetails");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('popup');
                console.log(response.getReturnValue());
                if(response.getReturnValue().con != undefined){
                    var agreeTC = response.getReturnValue().Terms_of_Use;
               
                    if(agreeTC === undefined || agreeTC == '' || agreeTC == 'Deny'){
                        component.set("v.showpopup",true);
                        component.set("v.userdetail",response.getReturnValue());
                       
                        var salutationOpt = JSON.parse(response.getReturnValue().salutationOptions);                
                        component.find("salutationOpt").set("v.options",salutationOpt);
                        
                        var countryOpt = JSON.parse(response.getReturnValue().countryOtions);
                        
                        component.find("countryOpt").set("v.options",countryOpt);
                        
                        var stateOptions = response.getReturnValue().stateoptions;
                        component.set("v.stateOptions",stateOptions);
                        
                        
                        helper.showstatelisthelper(component, event, helper,response.getReturnValue().con.MailingState);
                        
                    }
                }
                
               	
               
               
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
        
	},
    showemailchangealert :function(component, event, helper) {        
        component.set("v.emaileditshowpopup","slds-show");
    },
    closepopup :function(component, event, helper) {        
        component.set("v.emaileditshowpopup","slds-hide");
    },
    setfocustoemail:function(component, event, helper) {    
        var emailfield = component.find("emailfield");
        console.log(emailfield);
        component.set("v.emaileditshowpopup","slds-hide");
        setTimeout(function(){ emailfield.focus(); component.set("v.emaileditshowpopup","slds-hide"); }, 200);
    },
    clickonagree : function(component, event, helper) {  
        var isError = false;
        var con = component.get("v.userdetail.con");
        component.find("FirstName").set("v.class","requiredinput");
        component.find("LastName").set("v.class","requiredinput");
        component.find("emailfield").set("v.class","requiredinput");
        component.find("MailingCity").set("v.class","requiredinput");
        component.find("countryOpt").set("v.class","requiredinput");
        
        if(con.FirstName === undefined || con.FirstName.trim() == ''){
            isError = true;
            component.find("FirstName").set("v.class","required");
        }
        
        if(con.LastName === undefined || con.LastName.trim() == ''){
            isError = true;
            component.find("LastName").set("v.class","required");
        }
        
        if(con.Email === undefined || con.Email.trim() == ''){
            isError = true;
            component.find("emailfield").set("v.class","required");
        }
        
        if(con.MailingCity === undefined || con.MailingCity.trim() == ''){
            isError = true;
            component.find("MailingCity").set("v.class","required");
        }
        
        if(con.MailingCountry === undefined || con.MailingCountry.trim() == ''){
            isError = true;
            component.find("countryOpt").set("v.class","required");
        }
        //alert(isError);
        if(!isError){
            helper.saveTCAgree(component, event, helper);
        }
        	
	}
})