({
    changeOnboard : function (component, event, helper) {
        var isValid = false;
        var changeValue = event.getSource().get("v.label");
        var checkedValue = event.getSource().get("v.checked");
        var inputCmp1 = component.find("LTEField");
        if(changeValue == 'Same as Subscriber'){
            if(
                ( component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") == '' || component.get("v.simpleLTEActivation.Subscriber_Email__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") == '' || component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Subscriber_Phone__c") == '' || component.get("v.simpleLTEActivation.Subscriber_Phone__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Subscriber_Country__c") == '' || component.get("v.simpleLTEActivation.Subscriber_Country__c") == null ) 
            )
                helper.showToastHelper(component, 'All fields are not filled in Subscriber Contact');
            else{
                isValid = true;
                component.set("v.setCheck",changeValue);
            }
            if(component.get("v.setCheck") == changeValue){
                component.set("v.contact1InfoFlag",false);  
                component.set("v.contact2InfoFlag",false);
            }
        }else if(changeValue == 'Same as Additional Contact 1'){      
            if(
                ( component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont1__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont1__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont1__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont1__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_1_Email__c") == '' || component.get("v.simpleLTEActivation.Contact_1_Email__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_1_State_Province__c") == '' || component.get("v.simpleLTEActivation.Contact_1_State_Province__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_1_Phone__c") == '' || component.get("v.simpleLTEActivation.Contact_1_Phone__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_1_Country__c") == '' || component.get("v.simpleLTEActivation.Contact_1_Country__c") == null ) 
            )
                helper.showToastHelper(component, 'All fields are not filled in Additional Contact 1');
            else{ 
                isValid = true;
                component.set("v.setCheck",changeValue);
            }            
            if(component.get("v.setCheck") == changeValue){
            component.set("v.subscriberInfoFlag",false);  
            component.set("v.contact2InfoFlag",false);
            }
        }else if(changeValue == 'Same as Additional Contact 2'){
            if(
                ( component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont2__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont2__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont2__c") == '' || component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont2__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_2_Email__c") == '' || component.get("v.simpleLTEActivation.Contact_2_Email__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_2_State_Province_Territory__c") == '' || component.get("v.simpleLTEActivation.Contact_2_State_Province_Territory__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_2_Phone__c") == '' || component.get("v.simpleLTEActivation.Contact_2_Phone__c") == null ) ||
                ( component.get("v.simpleLTEActivation.Contact_2_Country__c") == '' || component.get("v.simpleLTEActivation.Contact_2_Country__c") == null ) 
            )
                helper.showToastHelper(component, 'All fields are not filled in Additional Contact 2');
            else{   
                isValid = true;
                component.set("v.setCheck",changeValue);
            }
            if(component.get("v.setCheck") == changeValue){
            component.set("v.contact1InfoFlag",false);  
            component.set("v.subscriberInfoFlag",false);
            }
        }  
        console.log('==isValid=='+isValid);
        if(isValid){
            if(checkedValue){
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", true);
                    inputCmp1[i].showHelpMessageIfInvalid();
                }  
                if(changeValue == 'Same as Subscriber'){
                    component.set("v.simpleLTEActivation.Onboard_Contact_First_Name__c",component.get("v.simpleLTEActivation.Main_Contact_FirstName_Subscriber__c"));
                    component.set("v.simpleLTEActivation.Onboard_Contact_Last_Name__c",component.get("v.simpleLTEActivation.Main_Contact_LastName_Subscriber__c"));
                    component.set("v.simpleLTEActivation.Onboard_Email__c",component.get("v.simpleLTEActivation.Subscriber_Email__c"));
                    component.set("v.simpleLTEActivation.Onboard_State_Province_Territory__c",component.get("v.simpleLTEActivation.Subscriber_State_Province_Territory__c"));
                    component.set("v.simpleLTEActivation.Onboard_Company_Name__c",component.get("v.simpleLTEActivation.Subscriber_Company_Name__c"));
                    component.set("v.simpleLTEActivation.Onboard_Phone__c",component.get("v.simpleLTEActivation.Subscriber_Phone__c"));
                    component.set("v.simpleLTEActivation.Onboard_Country__c",component.get("v.simpleLTEActivation.Subscriber_Country__c"));
                }
                else if(changeValue == 'Same as Additional Contact 1'){
                    component.set("v.simpleLTEActivation.Onboard_Contact_First_Name__c",component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont1__c"));
                    component.set("v.simpleLTEActivation.Onboard_Contact_Last_Name__c",component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont1__c"));
                    component.set("v.simpleLTEActivation.Onboard_Email__c",component.get("v.simpleLTEActivation.Contact_1_Email__c"));
                    component.set("v.simpleLTEActivation.Onboard_State_Province_Territory__c",component.get("v.simpleLTEActivation.Contact_1_State_Province__c"));
                    component.set("v.simpleLTEActivation.Onboard_Company_Name__c",component.get("v.simpleLTEActivation.Contact_1_Company_Name__c"));
                    component.set("v.simpleLTEActivation.Onboard_Phone__c",component.get("v.simpleLTEActivation.Contact_1_Phone__c"));
                    component.set("v.simpleLTEActivation.Onboard_Country__c",component.get("v.simpleLTEActivation.Contact_1_Country__c"));
                }
                    else if(changeValue == 'Same as Additional Contact 2'){
                        component.set("v.simpleLTEActivation.Onboard_Contact_First_Name__c",component.get("v.simpleLTEActivation.Main_Contact_First_Name_Cont2__c"));
                        component.set("v.simpleLTEActivation.Onboard_Contact_Last_Name__c",component.get("v.simpleLTEActivation.Main_Contact_Last_Name_Cont2__c"));
                        component.set("v.simpleLTEActivation.Onboard_Email__c",component.get("v.simpleLTEActivation.Contact_2_Email__c"));
                        component.set("v.simpleLTEActivation.Onboard_State_Province_Territory__c",component.get("v.simpleLTEActivation.Contact_2_State_Province_Territory__c"));
                        component.set("v.simpleLTEActivation.Onboard_Company_Name__c",component.get("v.simpleLTEActivation.Contact_2_Company_Name__c"));
                        component.set("v.simpleLTEActivation.Onboard_Phone__c",component.get("v.simpleLTEActivation.Contact_2_Phone__c"));
                        component.set("v.simpleLTEActivation.Onboard_Country__c",component.get("v.simpleLTEActivation.Contact_2_Country__c"));              
                    }
            }
            else{
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", false);                    
                    inputCmp1[i].showHelpMessageIfInvalid();
                    inputCmp1[i].set("v.value", "");
                }  
            }            
        } 
        else         
            event.getSource().set("v.checked",false);
        var a = component.get('c.onboardValidation');
        $A.enqueueAction(a);
    },
    changeOnboardContact : function (component, event, helper) {
        var message = event.getParam("setOnboardFalse"); 
        if(message == false){            
            var inputCmp1 = component.find("LTEField");
            if(component.get("v.subscriberInfoFlag") || component.get("v.contact1InfoFlag") || component.get("v.contact2InfoFlag")){
                component.set("v.subscriberInfoFlag",false);
                component.set("v.contact1InfoFlag",false);
                component.set("v.contact2InfoFlag",false);
                for(var i=0; i < inputCmp1.length; i++) {
                    inputCmp1[i].set("v.disabled", false);                    
                    inputCmp1[i].showHelpMessageIfInvalid();
                    inputCmp1[i].set("v.value", "");
                }  
            }
        }
    },
    handleCountryValue : function (component, event, helper) {
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Onboard_Country__c",currentvalue);
        var a = component.get('c.onboardValidation');
        $A.enqueueAction(a);
    },
    handleStateValue : function (component, event, helper) {        
        var currentvalue = event.getParam("value");
        component.set("v.simpleLTEActivation.Onboard_State_Province_Territory__c",currentvalue);
        var a = component.get('c.onboardValidation');
        $A.enqueueAction(a);
    },
    onboardValidation : function(component, event, helper) {
        //console.log(helper.handleUploadAction(component));
        if(helper.handleUploadAction(component) &&
           (component.get("v.simpleLTEActivation.Onboard_State_Province_Territory__c") != null && component.get("v.simpleLTEActivation.Onboard_State_Province_Territory__c") != '')
          ){
            component.set("v.onboardRequired",false);   
        }else{
            component.set("v.onboardRequired",true);    
        }
    },
});