({
    doInit: function(component, event, helper) {
        helper.getProductLineHelper(component, event, helper);
    },
    onPLFieldChange : function(component, event, helper){
        
        component.set("v.prodFieldDisabled",true);
        component.set("v.compassProduct",false);
        component.set("v.hdSeries",false);  
        component.set("v.tvSeries",false);
        component.set("v.otherSeries",false);
        component.set("v.otherSystem",false);
        component.set("v.recieverInfoRequired",false);
        helper.reSetReceiverInfo(component);
        
        var prodLine = event.getParam("value");
        var myMap = component.get("v.prodMap");
        component.set("v.selectedProd","");    
        if(prodLine!=''){
            component.set("v.prodFieldDisabled",false);
            component.set("v.simpleLTEActivation.Product_Line__c",prodLine);
            var productMap = myMap[prodLine]; 
            var productOpts = [];
            for (var i = 0; i < productMap.length; i++) {
                productOpts.push({
                    class: "optionClass",
                    label: productMap[i],
                    value: productMap[i]
                });
            }
            component.set("v.prodList", productOpts);
        }
        helper.validateField(component);
        
        /*if(!$A.util.isUndefined(component.get("v.recieverInfoRequired"))){
            helper.resetTVSeriesFields(component);
            helper.resetCreditBillingInforFields(component);    
            helper.resetreceiverInformationFields(component); 
            helper.resetPerAcccFields(component);             
        }*/
    },
    onProdFieldChange : function(component, event, helper){
        var selectedProd = component.get("v.selectedProd");
        var selectedProdLine = component.get("v.selectedProdLine");
        component.set("v.simpleLTEActivation.Product__c",selectedProd);
        if(selectedProdLine == 'Satellite Television' && (selectedProd == 'TracVision TV8' || selectedProd == 'TracVision TV6' || 
                                                          selectedProd == 'TracVision TV5' || selectedProd == 'TracVision TV3' || 
                                                          selectedProd == 'TracVision TV1')){
            component.set("v.hdSeries",false);
            component.set("v.tvSeries",true);
            component.set("v.compassProduct",false);
            component.set("v.simpleLTEActivation.IPACU_Serial_No__c","");
            component.set("v.simpleLTEActivation.Serial_No__c","");
            component.set("v.simpleLTEActivation.Other_System__c","");
            component.set("v.otherSystem",false);
            component.set("v.otherSeries",false);
        }else if(selectedProdLine == 'Satellite Television' && (selectedProd == 'TracVision HD11' || selectedProd == 'TracVision HD7')){
            component.set("v.hdSeries",true);
            component.set("v.tvSeries",false);
            component.set("v.compassProduct",false);
            component.set("v.recieverInfoRequired",false);
            component.set("v.simpleLTEActivation.TV_Hub_Serial_No__c","");
            component.set("v.simpleLTEActivation.Serial_No__c",""); 
            component.set("v.simpleLTEActivation.Other_System__c","");
            component.set("v.otherSystem",false);
            component.set("v.otherSeries",false);
        }else if(selectedProdLine == 'Compasses' && selectedProd!='Other'){
            component.set("v.hdSeries",false);
            component.set("v.tvSeries",false);
            component.set("v.compassProduct",true);
            component.set("v.recieverInfoRequired",false);
            component.set("v.simpleLTEActivation.TV_Hub_Serial_No__c","");
            component.set("v.simpleLTEActivation.IPACU_Serial_No__c","");
            component.set("v.simpleLTEActivation.Antenna_Serial_No__c","");  
            component.set("v.simpleLTEActivation.Other_System__c",""); 
            component.set("v.otherSystem",false);
            component.set("v.otherSeries",false);
        }else{
            component.set("v.hdSeries",false);
            component.set("v.tvSeries",false);
            component.set("v.compassProduct",false);
            component.set("v.recieverInfoRequired",false);
            component.set("v.simpleLTEActivation.TV_Hub_Serial_No__c","");
            component.set("v.simpleLTEActivation.IPACU_Serial_No__c","");
            component.set("v.simpleLTEActivation.Antenna_Serial_No__c",""); 
            component.set("v.otherSeries",true);
            if(selectedProd == 'Other')
                component.set("v.otherSystem",true);
            else
                component.set("v.otherSystem",false);
        }
        helper.validateField(component);        
        /*if(!$A.util.isUndefined(component.get("v.recieverInfoRequired"))){
            helper.resetTVSeriesFields(component);
            helper.resetCreditBillingInforFields(component);    
            helper.resetreceiverInformationFields(component); 
            helper.resetPerAcccFields(component);             
        }*/
    },
    systemValidate : function(component, event, helper){
        helper.validateField(component);
    },
    handleRecieverInfoRequired : function(component, event, helper){
        if(event.getParam("value")){
            helper.reSetReceiverInfo(component);
        }            
        helper.validateField(component);  
    }
    /*handlePAccChange: function(component, event, helper) {
        if(event.getParam("value") != 'United States' || !component.get("v.tvSeries"))     
            component.set("v.checkPersonalAcc",false);
        else
            component.set("v.checkPersonalAcc",true);
    },*/
})