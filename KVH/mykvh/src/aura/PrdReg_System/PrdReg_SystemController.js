({
    onProductLineChange: function(component, event, helper){
        component.set("v.isTv",false);  
        component.set("v.isHd",false);
        component.set("v.isSerial",false);
        component.set("v.showFreeReceiver",false);
        
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Product__c = '';
        prodRegistration.Serial_No__c = '';
        prodRegistration.Antenna_Serial_No__c = '';
        prodRegistration.TV_Hub_Serial_No__c = '';
        prodRegistration.IPACU_Serial_No__c = '';
        prodRegistration.Other_System__c = '';
        prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c = '';
        component.set('v.prodRegistration',prodRegistration);
        helper.reSetInfo(component);
        
        var prodLine = prodRegistration.Product_Line__c;
        var prodLineMap = component.get('v.productLineMap');
        var prodList = prodLineMap[prodLine];
        var productOpts = [];
        if(prodList && prodList.length>0){
            for (var i=0; i<prodList.length; i++){
                productOpts.push({
                    label: prodList[i],
                    value: prodList[i]
                });
            }   
        }
        component.set("v.prodList", productOpts);
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
	},
	onProductChange: function(component, event, helper){
        component.set("v.isTv",false);  
        component.set("v.isHd",false);
        component.set("v.isSerial",false);
        component.set("v.showFreeReceiver",false);
        
		var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c = '';
        prodRegistration.Antenna_Serial_No__c = '';
        prodRegistration.Serial_No__c = '';
        prodRegistration.IPACU_Serial_No__c = '';
        prodRegistration.TV_Hub_Serial_No__c = '';
        prodRegistration.Other_System__c = '';
        if(prodRegistration.Product_Line__c == 'Satellite Television' && (prodRegistration.Product__c == 'TracVision TV8' || 
                                                                          prodRegistration.Product__c == 'TracVision TV6' || 
                                                                          prodRegistration.Product__c == 'TracVision TV5' || 
                                                                          prodRegistration.Product__c == 'TracVision TV3' || 
                                                                          prodRegistration.Product__c == 'TracVision TV1' ||
                                                                          prodRegistration.Product__c == 'TracVision RV1' ||
                                                                          prodRegistration.Product__c == 'TracVision A9')){
            component.set("v.isTv",true);
            component.set("v.showFreeReceiver",true);
        }else if(prodRegistration.Product_Line__c == 'Satellite Television' && (prodRegistration.Product__c == 'TracVision HD11' || 
                                                                                prodRegistration.Product__c == 'TracVision HD7')){
            component.set("v.isHd",true);
            component.set("v.showFreeReceiver",true);
        }else if(prodRegistration.Product_Line__c == 'Satellite Television' && prodRegistration.Product__c == 'Other'){
            component.set("v.isSerial",true);
            component.set("v.showFreeReceiver",true);
        }else{
            component.set("v.isSerial",true);
        }
        component.set('v.prodRegistration',prodRegistration);
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
	},
    onChangeFreeReceiver: function(component, event, helper){
        var receiverInfo = event.getSource().get("v.label");
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c = receiverInfo;
        component.set('v.prodRegistration',prodRegistration);
        helper.reSetInfo(component);
        
        if(receiverInfo=='Yes'){
            component.find('contrySelect').set('v.value','US');
            component.find('contrySelect2').set('v.value','US');
            var prodRegistration = component.get('v.prodRegistration');
            prodRegistration.Billing_Country__c = 'United States';
            prodRegistration.Shipping_Country__c = 'United States';
            component.set('v.prodRegistration',prodRegistration);
            helper.getStateOpts(component,'US', "v.stateOptions");
            helper.getStateOpts(component,'US', "v.stateOptions2");
            component.set('v.customerInfoChanged',false);
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    validateCCNo: function(component, event, helper){
        var inputPrimaryCC = component.find('PrimaryCC'); 
        var valuePrimary = inputPrimaryCC.get('v.value');
        var cmpTarget = component.find('ccSecure');
        if($A.util.isEmpty(valuePrimary)){
            inputPrimaryCC.set('v.errors', [{message:"Complete this field."}]);
            $A.util.addClass(cmpTarget, 'ccSecure2');
            $A.util.removeClass(cmpTarget, 'ccSecure1');
        }else if( !$A.util.isEmpty(valuePrimary) ){
            if(isNaN(valuePrimary) || valuePrimary.toString().length < 12 || valuePrimary.toString().length > 19){
                inputPrimaryCC.set('v.errors', [{message:"Invalid card information"}]);
                $A.util.addClass(cmpTarget, 'ccSecure2');
                $A.util.removeClass(cmpTarget, 'ccSecure1');
            }else if(helper.validateCC(valuePrimary)){
                inputPrimaryCC.set('v.errors', [{message:"Incorrect card information"}]);
                $A.util.addClass(cmpTarget, 'ccSecure2');
                $A.util.removeClass(cmpTarget, 'ccSecure1');
            }else{
                inputPrimaryCC.set("v.errors", null);
                $A.util.addClass(cmpTarget, 'ccSecure1');
                $A.util.removeClass(cmpTarget, 'ccSecure2');
            }
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    validateExpDate: function(component, event, helper){
        var ccExpDate = component.find('ccExpDate');
        var valueExpDate = ccExpDate.get('v.value');
        if($A.util.isEmpty(valueExpDate)){
            ccExpDate.set('v.errors', [{message:"Complete this field."}]);
        }else if(!$A.util.isEmpty(valueExpDate)){
            var isValid = helper.validateExp(valueExpDate)
            if(isValid != 'Valid'){
                ccExpDate.set("v.errors", [{message:isValid}]);
            }else{
                ccExpDate.set("v.errors", null);
            }
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    updateCCBillingAdd: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        var accountRequired = component.get('v.accountRequired');
        if(accountRequired){
            helper.showToast('error', 'Error', 'Please enter all required fields in the "Account" section above.');
            event.getSource().set("v.checked",false);
        }else{
            if(event.getSource().get("v.checked")){
                component.find('contrySelect').set('v.value','US');
                helper.getStateOpts(component,'US', "v.stateOptions");
                
                prodRegistration.Billing_Address__c = prodRegistration.Subscriber_Address__c;
                prodRegistration.Billing_City__c = prodRegistration.Subscriber_City__c;
                prodRegistration.Billing_Postal_Zip_Code__c = prodRegistration.Subscriber_Postal_Zip_Code__c;
                prodRegistration.Billing_Country__c = prodRegistration.Subscriber_Country__c;
                prodRegistration.Billing_State_Province_Territory__c = prodRegistration.Subscriber_State_Province_Territory__c;
                
                var billingAddFlds = component.find("billingAddFld");
                for(var i=0; i < billingAddFlds.length; i++){
                    billingAddFlds[i].set("v.disabled", true);
                    billingAddFlds[i].showHelpMessageIfInvalid();
                }
                component.find("contrySelect").set("v.disabled", true);
                component.set('v.disableBillingState',true);
                component.set('v.customerInfoChanged',false);
            }else{
                helper.resetBilingAddres(component);
            }
        }
        component.set('v.prodRegistration',prodRegistration);
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onCountrySelect: function(component, event, helper){
        var countryOptions = component.get("v.countryOptions");
        var contryCode = component.find('contrySelect').get('v.value');
        var index = countryOptions.findIndex(item => item.value == contryCode);
        var contryName = index>=0 ? countryOptions[index].label : null;
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Billing_Country__c = contryName;
        prodRegistration.Billing_State_Province_Territory__c = '';
        component.set('v.prodRegistration',prodRegistration);
        helper.getStateOpts(component,contryCode, "v.stateOptions");
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    updateCCShipingAdd: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        var accountRequired = component.get('v.accountRequired');
        var KVHAuthDealerAddres = component.get('v.KVHAuthDealerAddres');
        var sameAsValue = event.getSource().getLocalId();
        if(sameAsValue=='CustomerInfo'){
            if(accountRequired){
                event.getSource().set("v.checked",false);
                helper.showToast('error', 'Error', 'Please enter all required fields in the "Account" section above.');   
                return;
            }else{
                if(event.getSource().get("v.checked")){
                    component.find('contrySelect2').set('v.value','US');
                    helper.getStateOpts(component,'US', "v.stateOptions2");
                    
                    prodRegistration.Shipping_Addressee__c = prodRegistration.Subscriber_First_Name__c;
                    prodRegistration.Shipping_Address__c = prodRegistration.Subscriber_Address__c;
                    prodRegistration.Shipping_City__c = prodRegistration.Subscriber_City__c;
                    prodRegistration.Shipping_Postal_Zip_Code__c = prodRegistration.Subscriber_Postal_Zip_Code__c;
                    prodRegistration.Shipping_Country__c = prodRegistration.Subscriber_Country__c;
                    prodRegistration.Shipping_State_Province_Territory__c = prodRegistration.Subscriber_State_Province_Territory__c;
                    helper.disableShipingAddres(component);
                    component.set('v.customerInfoChanged',false);
                    component.find('KVHAuthDealer').set('v.checked',false);
                }else{
                    helper.resetShipingAddres(component);
                }
            }
        }else if(prodRegistration.Installer_Information__c=='KVH Authorized Dealer/Distributor' && 
                 sameAsValue=='KVHAuthDealer'){
            if(KVHAuthDealerAddres){
                event.getSource().set("v.checked",false);
                helper.showToast('error', 'Error', 'Please enter all required fields in the "KVH Authorized Dealer" section above.');
                return;
            }else{
                if(event.getSource().get("v.checked")){
                    prodRegistration.Shipping_Addressee__c = prodRegistration.Installer_Contact_Name__c;
                    prodRegistration.Shipping_Address__c = prodRegistration.Installer_Address__c;
                    prodRegistration.Shipping_City__c = prodRegistration.Installer_City__c;
                    prodRegistration.Shipping_Postal_Zip_Code__c = prodRegistration.Installer_Zip_Code__c;
                    prodRegistration.Shipping_Country__c = prodRegistration.Installer_Country__c;
                    prodRegistration.Shipping_State_Province_Territory__c = prodRegistration.Installer_State_Province_Territory__c;
                    
                    var contryCode = helper.getCountryCode(component, prodRegistration.Installer_Country__c);
                    component.find('contrySelect2').set('v.value',contryCode);
                    helper.getStateOpts(component,contryCode, "v.stateOptions2");
                    helper.disableShipingAddres(component);
                    component.find('CustomerInfo').set('v.checked',false);
                }else{
                    helper.resetShipingAddres(component);
                }
            }
        }else if(prodRegistration.Installer_Information__c!='KVH Authorized Dealer/Distributor' && 
                 sameAsValue=='KVHAuthDealer'){
            event.getSource().set("v.checked",false);
            helper.showToast('error', 'Error', 'Please select "KVH Authorized Dealer/Distributor" in Installation section above.');
            return;
        }
        component.set('v.prodRegistration',prodRegistration);
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onCountrySelect2: function(component, event, helper){
        var countryOptions = component.get("v.countryOptions");
        var contryCode = component.find('contrySelect2').get('v.value');
        var index = countryOptions.findIndex(item => item.value == contryCode);
        var contryName = index>=0 ? countryOptions[index].label : null;
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Shipping_Country__c = contryName;
        prodRegistration.Shipping_State_Province_Territory__c = '';
        component.set('v.prodRegistration',prodRegistration);
        helper.getStateOpts(component,contryCode, "v.stateOptions2");
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onSubsciberCountryChange: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        if(prodRegistration.Subscriber_Country__c!='United States'){
            helper.reSetInfo(component);
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onInstaInfoChange: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        if(prodRegistration.Installer_Information__c=='Prior Owner'){
            helper.reSetInfo(component);
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onCustomerInfoChange: function(component, event, helper){
        if(component.get('v.customerInfoChanged')){
            if(component.get('v.customerInfoFlg')){
                component.set('v.customerInfoFlg',false);
                helper.resetBilingAddres(component);    
            }
            if(component.find('CustomerInfo').get('v.checked')){
                helper.resetShipingAddres(component);
                component.find('CustomerInfo').set('v.checked',false)
            }
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    onKVHAuthDealerAddresChange: function(component, event, helper){
        if(component.get('v.KVHAuthDealerAddres')){
            if(component.find('KVHAuthDealer').get('v.checked')){
                helper.resetShipingAddres(component);
                component.find('KVHAuthDealer').set('v.checked',false)
            }
        }
        
        var validateFields = component.get('c.validateFields');
        $A.enqueueAction(validateFields);
    },
    validateFields: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        var validateProdInfo = helper.validateProdInfo(component);
        var validatePopInfo = helper.validatePopInfo(component);
        component.set("v.systemRequired",true);
        if(validateProdInfo && validatePopInfo && !component.get("v.showFreeReceiver")){
            component.set("v.systemRequired",false);
        }else if(validateProdInfo && validatePopInfo && component.get("v.showFreeReceiver")){
            if(prodRegistration.Installer_Information__c=='Prior Owner'){
                component.set("v.systemRequired",false);
            }else if(prodRegistration.Subscriber_Country__c!='United States'){
                component.set("v.systemRequired",false);
            }else if(prodRegistration.Subscriber_Country__c=='United States'){
                if(prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c=='No'){
                    component.set("v.systemRequired",false);
                }else if(prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c=='Yes'){
                    var validatePaymentInfo = helper.validatePaymentInfo(component);
                    if(validatePaymentInfo){
                        component.set("v.systemRequired",false);
                    }
                }
            }
        }
	}
})