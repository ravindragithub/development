({
    validateProdInfo: function(component){
        var isError = false;
        var prodRegistration = component.get('v.prodRegistration');
        if(!$A.util.isEmpty(prodRegistration.Product_Line__c) && 
           !$A.util.isEmpty(prodRegistration.Product__c)){
            if(component.get("v.isTv") && 
               !$A.util.isEmpty(prodRegistration.Antenna_Serial_No__c) &&
               !$A.util.isEmpty(prodRegistration.TV_Hub_Serial_No__c) &&
               prodRegistration.Antenna_Serial_No__c.length==9 &&
               prodRegistration.TV_Hub_Serial_No__c.length==9){
                isError = true;
            }else if(component.get("v.isHd") && 
                     !$A.util.isEmpty(prodRegistration.Antenna_Serial_No__c) &&
                     !$A.util.isEmpty(prodRegistration.IPACU_Serial_No__c) &&
                     prodRegistration.Antenna_Serial_No__c.length==9 &&
                     prodRegistration.IPACU_Serial_No__c.length==9){
                isError = true;
            }else if(prodRegistration.Product_Line__c=='Satellite Television' && prodRegistration.Product__c=='Other'){
                if(!$A.util.isEmpty(prodRegistration.Antenna_Serial_No__c) && 
                   prodRegistration.Antenna_Serial_No__c.length==9 && 
                   !$A.util.isEmpty(prodRegistration.Other_System__c)){
                    isError = true;
                }
            }else if(prodRegistration.Product_Line__c=='Compasses' && prodRegistration.Product__c=='Other'){
                if(!$A.util.isEmpty(prodRegistration.Serial_No__c) && 
                   prodRegistration.Serial_No__c.length==9 && 
                   !$A.util.isEmpty(prodRegistration.Other_System__c)){
                    isError = true;
                }
            }else if(prodRegistration.Product_Line__c=='Compasses' && prodRegistration.Product__c!='Other'){
                if(!$A.util.isEmpty(prodRegistration.Serial_No__c) && prodRegistration.Serial_No__c.length==9){
                    isError = true;
                }
            }
        }
        return isError;
    },
    validatePopInfo: function(component){
        var isError = false;
        var prodRegistration = component.get('v.prodRegistration');
        if(!$A.util.isEmpty(prodRegistration.Purchase_Date__c) && 
           !$A.util.isEmpty(prodRegistration.Purchased_From__c) &&
           component.get('v.attRequired')){
            isError = true;
        }
        return isError;
    },
    validatePaymentInfo: function(component){
        var isError = false;
        var prodRegistration = component.get('v.prodRegistration');
        if(component.find('PrimaryCC').get("v.errors") == null &&
           component.find('ccExpDate').get("v.errors") == null &&
           !$A.util.isEmpty(prodRegistration.Credit_Card_No__c) &&
           !$A.util.isEmpty(prodRegistration.Exp_Date__c) &&
           !$A.util.isEmpty(prodRegistration.Name_on_Card__c) && 
           !$A.util.isEmpty(prodRegistration.Billing_Address__c) &&
           !$A.util.isEmpty(prodRegistration.Billing_City__c) &&
           !$A.util.isEmpty(prodRegistration.Billing_Postal_Zip_Code__c) &&
           !$A.util.isEmpty(prodRegistration.Billing_Country__c) &&
           !$A.util.isEmpty(prodRegistration.Shipping_Addressee__c) && 
           !$A.util.isEmpty(prodRegistration.Shipping_Address__c) &&
           !$A.util.isEmpty(prodRegistration.Shipping_City__c) &&
           !$A.util.isEmpty(prodRegistration.Shipping_Postal_Zip_Code__c) &&
           !$A.util.isEmpty(prodRegistration.Shipping_Country__c)){
            var stateOptions = component.get('v.stateOptions');
            var stateOptions2 = component.get('v.stateOptions2');
            if(((stateOptions.length>0 && !$A.util.isEmpty(prodRegistration.Billing_State_Province_Territory__c)) ||
                (stateOptions.length==0 && $A.util.isEmpty(prodRegistration.Billing_State_Province_Territory__c))) && 
               ((stateOptions2.length>0 && !$A.util.isEmpty(prodRegistration.Shipping_State_Province_Territory__c)) ||
                (stateOptions2.length==0 && $A.util.isEmpty(prodRegistration.Shipping_State_Province_Territory__c)))){
                isError = true;
            }
        }
        return isError;
    },
    validateShipingAdd: function(component){
        var isError = false;
        
        return isError;
    },
    reSetInfo: function(component){
        component.set('v.customerInfoFlg',false);
        component.set('v.disableBillingState',false);
        component.set('v.disableShipingState',false);
        
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Credit_Card_No__c = '';
        prodRegistration.Exp_Date__c = '';
        prodRegistration.Name_on_Card__c = '';      
        prodRegistration.Billing_Address__c = '';
        prodRegistration.Billing_City__c = '';              
        prodRegistration.Billing_Postal_Zip_Code__c = '';
        prodRegistration.Billing_State_Province_Territory__c = '';
        prodRegistration.Billing_Country__c = '';
        
        prodRegistration.Shipping_Addressee__c = '';
        prodRegistration.Shipping_Address__c = '';	
        prodRegistration.Shipping_City__c = '';                
        prodRegistration.Shipping_Postal_Zip_Code__c = '';
        prodRegistration.Shipping_State_Province_Territory__c = '';
        prodRegistration.Shipping_Country__c = '';
        
        prodRegistration.Satellite_TV_Provider__c = '';
        prodRegistration.Dish_Network_Subscriber_Status__c = '';
        prodRegistration.DIRECTV_Subscriber_Status__c = '';
        component.set('v.prodRegistration',prodRegistration);
    },
    validateCC: function(value){
        if (/[^0-9-\s]+/.test(value)) return false;
        var nCheck = 0, nDigit = 0, bEven = false;
        value = value.replace(/\D/g, "");        
        for (var n = value.length - 1; n >= 0; n--) {
            var cDigit = value.charAt(n),
                nDigit = parseInt(cDigit, 10);            
            if (bEven) 
                if ((nDigit *= 2) > 9) nDigit -= 9;
            nCheck += nDigit;
            bEven = !bEven;
        }   
        
        var isInValid = (nCheck % 10) == 0;
        return !isInValid;
    },
    validateExp: function(value){
        var isValid = '';
        var match = value.match(/^\s*(0?[1-9]|1[0-2])\/(\d\d|\d{4})\s*$/);
        if (!match){
            isValid = 'Incorrect date format';
            return(isValid);
        }else{
            var exp = new Date(this.normalizeYear(1*match[2]),1*match[1]-1,1).valueOf();
            var now=new Date();
            var currMonth = new Date(now.getFullYear(),now.getMonth(),1).valueOf();
            if (exp<=currMonth){
                isValid = 'Date Expired ';
            } else {
                isValid = 'Valid';
            }
            return(isValid);
        }
    },
    normalizeYear : function(year){
        var YEARS_AHEAD = 20;
        if(year<100){
            var nowYear = new Date().getFullYear();
            year += Math.floor(nowYear/100)*100;
            if (year > nowYear + YEARS_AHEAD){
                year -= 100;
            }else if(year <= nowYear - 100 + YEARS_AHEAD){
                year += 100;
            }
        }
        return year;        
    },
    getStateOpts: function(component,contryCode, optName){
        var countryStateMap = component.get('v.countryStateMap');
        var stateList = countryStateMap[contryCode];
        var opts = [];
        if(stateList.length>0){
            for(var i in stateList){
                var stateOpt = {};
                stateOpt.label = stateList[i];
                stateOpt.value = stateList[i];
                opts.push(stateOpt);
            }
        }
        component.set(optName, []);
        component.set(optName, opts);
    },
    getCountryCode: function(component, contryName){
        var countryOptions = component.get("v.countryOptions");
        var index = countryOptions.findIndex(item => item.label == contryName);
        var contryCode = index>=0 ? countryOptions[index].value : null;
        return contryCode;
    },
    resetBilingAddres: function(component){
        var billingAddFlds = component.find("billingAddFld");
        for(var i=0; i < billingAddFlds.length; i++){
            billingAddFlds[i].set("v.disabled", false);
            billingAddFlds[i].showHelpMessageIfInvalid();
            billingAddFlds[i].set("v.value", "");
        }
        component.find("contrySelect").set("v.disabled", false);
        component.set('v.disableBillingState',false);
        component.find('contrySelect').set('v.value','US');
        this.getStateOpts(component,'US', "v.stateOptions");
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Billing_State_Province_Territory__c = '';
        component.set('v.prodRegistration',prodRegistration);
    },
    disableShipingAddres: function(component){
        var shipingAddFlds = component.find("shipingAddFld");
        for(var i=0; i < shipingAddFlds.length; i++){
            shipingAddFlds[i].set("v.disabled", true);
            shipingAddFlds[i].showHelpMessageIfInvalid();
        }
        component.find("contrySelect2").set("v.disabled", true);
        component.set('v.disableShipingState',true);
    },
    resetShipingAddres: function(component){
        var shipingAddFlds = component.find("shipingAddFld");
        for(var i=0; i < shipingAddFlds.length; i++){
            shipingAddFlds[i].set("v.disabled", false);
            shipingAddFlds[i].showHelpMessageIfInvalid();
            shipingAddFlds[i].set("v.value", "");
        }
        component.find("contrySelect2").set("v.disabled", false);
        component.set('v.disableShipingState',false);
        component.find('contrySelect2').set('v.value','US');
        this.getStateOpts(component,'US', "v.stateOptions2");
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Shipping_State_Province_Territory__c = '';
        component.set('v.prodRegistration',prodRegistration);
    },
    showToast: function(typ, titl, msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": typ,
            "title": titl,
            "message": msg
        });
        toastEvent.fire();
    }
})