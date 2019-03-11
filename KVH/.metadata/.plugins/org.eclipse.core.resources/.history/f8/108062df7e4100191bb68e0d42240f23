({
    paymentValidHelper : function(component, event, helper) {
        if(
            !component.get("v.invalidPrimaryCC") &&
            !component.get("v.invalidSecondaryCC") &&            
            (component.get("v.simpleLTEActivation.Primary_Credit_Card_No__c") != null && component.get("v.simpleLTEActivation.Primary_Credit_Card_No__c") != '') &&
            (component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c") != null && component.get("v.simpleLTEActivation.Primary_CC_Exp_Date__c") != '') &&
            (component.get("v.simpleLTEActivation.Primary_Name_on_Card__c") != null && component.get("v.simpleLTEActivation.Primary_Name_on_Card__c") != '')&&
            (component.get("v.simpleLTEActivation.Primary_CVV__c") != null && component.get("v.simpleLTEActivation.Primary_CVV__c") != '')
        ){
            component.set("v.payInfoRequired",false);   
        }else{
            component.set("v.payInfoRequired",true);    
        }
    },
    paymentSecondaryValidHelper : function(component, event, helper) {
        if(
            !component.get("v.invalidSecondaryCC") &&
            (component.get("v.simpleLTEActivation.Secondary_Credit_Card_No__c") != null && component.get("v.simpleLTEActivation.Secondary_Credit_Card_No__c") != '') &&
            (component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c") != null && component.get("v.simpleLTEActivation.Secondary_CC_Exp_Date__c") != '') &&
            (component.get("v.simpleLTEActivation.Secondary_Name_on_Card__c") != null && component.get("v.simpleLTEActivation.Secondary_Name_on_Card__c") != '') &&
            (component.get("v.simpleLTEActivation.Secondary_CVV__c") != null && component.get("v.simpleLTEActivation.Secondary_CVV__c") != '')            
        ){
            component.set("v.payInfoRequired",false);   
        }else{
            component.set("v.payInfoRequired",true);    
        }
    },
    handleValidateCC : function(value) {
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
    normalizeYear : function(year) {
        var YEARS_AHEAD = 20;
        if (year<100){
            var nowYear = new Date().getFullYear();
            year += Math.floor(nowYear/100)*100;
            if (year > nowYear + YEARS_AHEAD){
                year -= 100;
            } else if (year <= nowYear - 100 + YEARS_AHEAD) {
                year += 100;
            }
        }
        return year;        
    },
    handleValidateCCExpDate : function(value) {
        var isValid = '';
        var match = value.match(/^\s*(0?[1-9]|1[0-2])\/(\d\d|\d{4})\s*$/);
        if (!match){
            isValid = 'Incorrect date format';
            return(isValid);
        }
        else{
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
})