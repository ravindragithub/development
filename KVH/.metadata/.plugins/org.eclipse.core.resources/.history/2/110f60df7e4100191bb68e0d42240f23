({
    validatePrimaryPayInfo : function(component, event, helper) {
        //component.set("v.payInfoRequired",true);
        var inputPrimaryCC = component.find('PrimaryCC');        
        var inputSecondaryCC = component.find('SecondaryCC');
        var valuePrimary = inputPrimaryCC.get('v.value');
        var valueSecondary = inputSecondaryCC.get('v.value');
        var inputPrimaryCCDate = component.find('PrimaryCCDate');
        var inputPrimaryCCName = component.find('PrimaryCCName');
        var inputPrimaryCVV = component.find('PrimaryCVV');
        console.log(valuePrimary.toString().length);
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputPrimaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19)
            inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);
            else if(helper.handleValidateCC(valuePrimary))
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else
                    inputPrimaryCC.set("v.errors", null);  
        
        helper.paymentValidHelper(component, event, helper);   
        inputSecondaryCC.set("v.errors", null);  
        inputPrimaryCCDate.set("v.errors", null);          
        inputPrimaryCCName.set("v.errors", null);
        inputPrimaryCVV.set("v.errors", null);
    },
    validatePrimaryDateInfo : function(component, event, helper) {
        component.set("v.payInfoRequired",true);
        var inputPrimaryCC = component.find('PrimaryCC');        
        var inputSecondaryCC = component.find('SecondaryCC');
        var inputPrimaryCCDate = component.find('PrimaryCCDate');
        var inputPrimaryCCName = component.find('PrimaryCCName');
        var valuePrimary = inputPrimaryCC.get('v.value');
        var valueSecondary = inputSecondaryCC.get('v.value');
        //console.log('valuePrimary=='+valuePrimary);
        var validExpirationDate = new RegExp('(0[1-9]|10|11|12)/(2[0-9][1-9][8-9])|(2[0-9][2-9][0-9])$');
        
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputPrimaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19)
            inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);   
            else if(helper.handleValidateCC(valuePrimary))
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else if(valuePrimary != null && valuePrimary != '') {
                    inputPrimaryCC.set("v.errors", null);                  
                    if(
                        (component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c")  == null || 
                         component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c") == '' )  
                    ){
                        //console.log('3rd 1st if');
                        inputPrimaryCCDate.set("v.errors", [{message:"Complete this field"}]);
                    }
                    else if(component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c")  != null && 
                            component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c") != '' && 
                            ( 
                                helper.handleValidateCCExpDate(component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c")) != 'Valid'
                            )
                           ){
                        //console.log('3rd 2nd if');
                        component.set("v.invalidPrimaryCC",true);
                        inputPrimaryCCDate.set("v.errors", [{message:helper.handleValidateCCExpDate(component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c"))}]);
                    }                
                        else{
                            component.set("v.invalidPrimaryCC",false);
                            inputPrimaryCCDate.set("v.errors", null);    
                            helper.paymentValidHelper(component, event, helper);     
                        }
                }        
    },
    validatePrimaryNameInfo : function(component, event, helper) {
        component.set("v.payInfoRequired",true);
        var inputPrimaryCC = component.find('PrimaryCC');        
        var inputSecondaryCC = component.find('SecondaryCC');
        //var inputPrimaryCCDate = component.find('PrimaryCCDate');
        var inputPrimaryCCName = component.find('PrimaryCCName');
        var valuePrimary = inputPrimaryCC.get('v.value');
        var valueSecondary = inputSecondaryCC.get('v.value');
        
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputPrimaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19)
            inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);     
            else if(helper.handleValidateCC(valuePrimary))
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else if(valuePrimary != null && valuePrimary != '') {
                    inputPrimaryCC.set("v.errors", null);  
                    if(
                        (component.get("v.simpleLTEActivation.Primary_Name_on_Card__c")  == null || 
                         component.get("v.simpleLTEActivation.Primary_Name_on_Card__c") == '' )
                    ){
                        inputPrimaryCCName.set("v.errors", [{message:"Complete this field"}]);
                    }
                    else{
                        inputPrimaryCCName.set("v.errors", null);    
                        helper.paymentValidHelper(component, event, helper);  
                    }
                }        
    },
    validatePrimaryCVVInfo : function(component, event, helper) {        
        component.set("v.payInfoRequired",true);
        var inputPrimaryCC = component.find('PrimaryCC');        
        var inputSecondaryCC = component.find('SecondaryCC');
        var inputPrimaryCCName = component.find('PrimaryCCName');
        var valuePrimary = inputPrimaryCC.get('v.value');
        var valueSecondary = inputSecondaryCC.get('v.value');
        var inputPrimaryCVV = component.find('PrimaryCVV');
        var inputPrimaryCVVvalue = component.find('PrimaryCVV').get('v.value');
        
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputPrimaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19)
            inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);     
            else if(helper.handleValidateCC(valuePrimary))
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else if(valuePrimary != null && valuePrimary != '') {
                    inputPrimaryCC.set("v.errors", null);  
                    if(
                        (component.get("v.simpleLTEActivation.Primary_CVV__c")  == null || 
                         component.get("v.simpleLTEActivation.Primary_CVV__c") == '' )
                    ){
                        component.set("v.invalidPrimaryCC",true);
                        inputPrimaryCVV.set("v.errors", [{message:"Complete this field"}]);
                    }
                    else if(inputPrimaryCVVvalue.toString().length > 4 || inputPrimaryCVVvalue.toString().length < 3){
                        component.set("v.invalidPrimaryCC",true);
                        inputPrimaryCVV.set("v.errors", [{message:"Should be Four digit text."}]);
                    }
                        else{
                        component.set("v.invalidPrimaryCC",false);
                        inputPrimaryCVV.set("v.errors", null);    
                        helper.paymentValidHelper(component, event, helper);  
                    }
                }        
    },
    validateSecondaryPayInfo : function(component, event, helper) {
        //component.set("v.payInfoRequired",false);
        component.set("v.invalidSecondaryCC",false);         
        var inputPrimaryCC = component.find('PrimaryCC');        
        var inputSecondaryCC = component.find('SecondaryCC');
        var valuePrimary = inputPrimaryCC.get('v.value');
        var valueSecondary = inputSecondaryCC.get('v.value');
        var inputSecondaryCCDate = component.find('SecondaryCCDate');
        var inputSecondaryCCName = component.find('SecondaryCCName');
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')
          ) {
            inputSecondaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
            component.set("v.payInfoRequired",true);            
        }
        else if(valueSecondary != null && valueSecondary != ''){
            component.set("v.payInfoRequired",true); 
            if(isNaN(valueSecondary) || valueSecondary.toString().length < 12 || valueSecondary.toString().length > 19){
                inputSecondaryCC.set('v.errors', [{message:"Invalid card information"}]);
                component.set("v.invalidSecondaryCC",true);
            }      
            else if(helper.handleValidateCC(valueSecondary)){
                inputSecondaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                component.set("v.invalidSecondaryCC",true);
            }
                else{
                    component.set("v.invalidSecondaryCC",false);
                    inputSecondaryCC.set("v.errors", null);               
                    helper.paymentSecondaryValidHelper(component, event, helper); 
                }
        }     
            else{
                inputSecondaryCC.set("v.errors", null);                   
            }
        helper.paymentValidHelper(component, event, helper);  
        inputSecondaryCCDate.set("v.errors", null);          
        inputSecondaryCCName.set("v.errors", null);
    },
    validateSecondaryDateInfo : function(component, event, helper) {
        var inputPrimaryCC = component.find('PrimaryCC');
        var valuePrimary = component.find('PrimaryCC').get('v.value');
        var inputSecondaryCC = component.find('SecondaryCC');
        var inputSecondaryCCDate = component.find('SecondaryCCDate');
        var inputSecondaryCCName = component.find('SecondaryCCName');
        var valueSecondary = inputSecondaryCC.get('v.value');	
        var validExpirationDate = new RegExp('(0[1-9]|10|11|12)/(2[0-9][1-9][8-9])|(2[0-9][2-9][0-9])$');
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputSecondaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(valueSecondary != null && valueSecondary != ''){ 
            inputSecondaryCC.set("v.errors", null);   
            component.set("v.payInfoRequired",true);  
            if(isNaN(valueSecondary) || valueSecondary.toString().length < 12 || valueSecondary.toString().length > 19)
                inputSecondaryCC.set('v.errors', [{message:"Invalid card information"}]);            
            else if(helper.handleValidateCC(valueSecondary))
                inputSecondaryCC.set('v.errors', [{message:"Incorrect card information"}]);
            if(component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c")  == null || 
               component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c") == '' 
              ){
                inputSecondaryCCDate.set("v.errors", [{message:"Complete this field"}]);
            }
            else if(component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c")  != null && 
                    component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c") != '' && 
                    ( 
                        helper.handleValidateCCExpDate(component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c")) != 'Valid'
                    )
                   ){
                component.set("v.invalidSecondaryCC",true);
                inputSecondaryCCDate.set("v.errors", [{message:helper.handleValidateCCExpDate(component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c"))}]);
            }        
                else{
                    component.set("v.invalidSecondaryCC",false);
                    inputSecondaryCCDate.set("v.errors", null);                        
                    helper.paymentSecondaryValidHelper(component, event, helper); 
                }
        }
    },
    validateSecondaryNameInfo : function(component, event, helper) {
        var inputPrimaryCC = component.find('PrimaryCC');
        var valuePrimary = component.find('PrimaryCC').get('v.value');
        var inputSecondaryCC = component.find('SecondaryCC');
        var inputSecondaryCCDate = component.find('SecondaryCCDate');
        var inputSecondaryCCName = component.find('SecondaryCCName');
        var valueSecondary = inputSecondaryCC.get('v.value');	
        var validExpirationDate = new RegExp('(0[1-9]|10|11|12)/(2[0-9][1-9][8-9])|(2[0-9][2-9][0-9])$');
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputSecondaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(valueSecondary != null && valueSecondary != ''){ 
            inputSecondaryCC.set("v.errors", null);   
            component.set("v.payInfoRequired",true);  
            if(isNaN(valueSecondary) || valueSecondary.toString().length < 12 || valueSecondary.toString().length > 19)
                inputSecondaryCC.set('v.errors', [{message:"Invalid card information"}]);   
            else if(helper.handleValidateCC(valueSecondary))
                inputSecondaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else if(component.get("v.simpleLTEActivation.Secondary_Name_on_Card__c")  == null || 
                        component.get("v.simpleLTEActivation.Secondary_Name_on_Card__c") == '' ){
                    inputSecondaryCCName.set("v.errors", [{message:"Complete this field"}]);
                }else{
                    inputSecondaryCCName.set("v.errors", null);                        
                    helper.paymentSecondaryValidHelper(component, event, helper); 
                }
        }
    },
    validateSecondaryCVVInfo : function(component, event, helper) {
        var inputPrimaryCC = component.find('PrimaryCC');
        var valuePrimary = component.find('PrimaryCC').get('v.value');
        var inputSecondaryCC = component.find('SecondaryCC');
        var inputSecondaryCCDate = component.find('SecondaryCCDate');
        var inputSecondaryCCName = component.find('SecondaryCCName');
        var valueSecondary = inputSecondaryCC.get('v.value');	
        var validExpirationDate = new RegExp('(0[1-9]|10|11|12)/(2[0-9][1-9][8-9])|(2[0-9][2-9][0-9])$');
        var inputSecondaryCVV = component.find('SecondaryCVVName');
        var inputSecondaryCVVvalue = component.find('SecondaryCVVName').get('v.value');
        if((valuePrimary == null || valuePrimary == '') &&
           (valueSecondary == null || valueSecondary == '')           
          ) 
            inputSecondaryCC.set('v.errors', [{message:"You must provide at least 1 credit card information"}]);
        else if(valueSecondary != null && valueSecondary != ''){ 
            inputSecondaryCC.set("v.errors", null);   
            component.set("v.payInfoRequired",true);  
            if(isNaN(valueSecondary) || valueSecondary.toString().length < 12 || valueSecondary.toString().length > 19)
                inputSecondaryCC.set('v.errors', [{message:"Invalid card information"}]);   
            else if(helper.handleValidateCC(valueSecondary))
                inputSecondaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                else if(component.get("v.simpleLTEActivation.Secondary_CVV__c")  == null || 
                        component.get("v.simpleLTEActivation.Secondary_CVV__c") == '' ){
                    inputSecondaryCVV.set("v.errors", [{message:"Complete this field"}]);
                }else if(inputSecondaryCVVvalue.toString().length > 4 || inputSecondaryCVVvalue.toString().length < 3 ){
                    inputSecondaryCVV.set("v.errors", [{message:"Should be Four digit text."}]);
                }else{
                    inputSecondaryCVV.set("v.errors", null);                        
                    helper.paymentSecondaryValidHelper(component, event, helper); 
                }
        }
    },
})