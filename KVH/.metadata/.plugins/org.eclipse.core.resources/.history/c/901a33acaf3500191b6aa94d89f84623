({
    reSetReceiverInfo: function(component){
        component.set("v.billingInfoFlag",false);
        component.set("v.customerInfoFlag",false);  
        component.set("v.kvhAUthInfoFlag",false);
        
        component.set("v.simpleLTEActivation.Credit_Card_No__c","");
        component.set("v.simpleLTEActivation.Exp_Date__c","");
        component.set("v.simpleLTEActivation.Name_on_Card__c","");        
        component.set("v.simpleLTEActivation.Billing_Address__c","");
        component.set("v.simpleLTEActivation.Billing_City__c","");                
        component.set("v.simpleLTEActivation.Billing_Postal_Zip_Code__c","");
        component.set("v.simpleLTEActivation.Billing_State_Province_Territory__c","");
        component.set("v.simpleLTEActivation.Billing_Country__c","United States");
        
        component.set("v.simpleLTEActivation.Shipping_Addressee__c","");
        component.set("v.simpleLTEActivation.Shipping_Address__c","");	
        component.set("v.simpleLTEActivation.Shipping_City__c","");                
        component.set("v.simpleLTEActivation.Shipping_Postal_Zip_Code__c","");
        component.set("v.simpleLTEActivation.Shipping_State_Province_Territory__c","");
        component.set("v.simpleLTEActivation.Shipping_Country__c","United States");
        
        component.set("v.simpleLTEActivation.Satellite_TV_Provider__c","");
        component.set("v.simpleLTEActivation.Dish_Network_Subscriber_Status__c","");
        component.set("v.simpleLTEActivation.DIRECTV_Subscriber_Status__c","");
    },
    getProductLineHelper : function(component, event, helper){
        var action = component.get("c.getProductLineMap");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.prodMap", response.getReturnValue());
            }                    
        });
        $A.enqueueAction(action);
    },
    validateField : function(component){
        component.set("v.serviceRequired",true);
        var selectedProd = component.get("v.selectedProd");
        var selectedProdLine = component.get("v.selectedProdLine");	
        if(selectedProd!='' && selectedProdLine!=''){
            if(component.get("v.tvSeries") && 
                     !$A.util.isEmpty(component.get("v.simpleLTEActivation.Antenna_Serial_No__c")) &&
                     !$A.util.isEmpty(component.get("v.simpleLTEActivation.TV_Hub_Serial_No__c"))){
                component.set("v.serviceRequired",false);
            }else if(component.get("v.hdSeries") && 
                     !$A.util.isEmpty(component.get("v.simpleLTEActivation.Antenna_Serial_No__c")) &&
                     !$A.util.isEmpty(component.get("v.simpleLTEActivation.IPACU_Serial_No__c"))){
                component.set("v.serviceRequired",false);
            }else if((selectedProdLine=='Compasses' || selectedProdLine=='Satellite Television') && selectedProd=='Other'){
                if(!$A.util.isEmpty(component.get("v.simpleLTEActivation.Serial_No__c")) && !$A.util.isEmpty(component.get("v.simpleLTEActivation.Other_System__c"))){
                    component.set("v.serviceRequired",false);
                }
            }else if((selectedProdLine=='Compasses' || selectedProdLine=='Satellite Television') && selectedProd!='Other'){
                if(!$A.util.isEmpty(component.get("v.simpleLTEActivation.Serial_No__c"))){
                    component.set("v.serviceRequired",false);
                }
            }
            
            /*if(component.get("v.tvSeries") && ($A.util.isEmpty(component.get("v.simpleLTEActivation.Antenna_Serial_No__c")) ||
                                               $A.util.isEmpty(component.get("v.simpleLTEActivation.TV_Hub_Serial_No__c")))){
                component.set("v.serviceRequired",true);
            }else if(component.get("v.hdSeries") && ($A.util.isEmpty(component.get("v.simpleLTEActivation.Antenna_Serial_No__c")) ||
                                                     $A.util.isEmpty(component.get("v.simpleLTEActivation.IPACU_Serial_No__c")))){
                component.set("v.serviceRequired",true);
            }else if(component.get("v.compassProduct") && $A.util.isEmpty(component.get("v.simpleLTEActivation.Serial_No__c"))){
                component.set("v.serviceRequired",true);
            }else if(component.get("v.otherSystem") && ($A.util.isEmpty(component.get("v.simpleLTEActivation.Other_System__c")) || 
                                                        $A.util.isEmpty(component.get("v.simpleLTEActivation.Serial_No__c")))){
                component.set("v.serviceRequired",true);
            }else if(component.get("v.otherSeries") && $A.util.isEmpty(component.get("v.simpleLTEActivation.Serial_No__c"))){
                component.set("v.serviceRequired",true);
            }else{
                component.set("v.serviceRequired",false);
            }*/
        }
    }
})