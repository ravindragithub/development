({
    paymentValidHelper : function(component) {
        var allValid = false;
        if(     
            component.find('PrimaryCC').get("v.errors") == null &&
            component.find('PrimaryCCDate').get("v.errors") == null &&
            component.find('PrimaryCCName').get("v.errors") == null &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Credit_Card_No__c")) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Exp_Date__c")) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Name_on_Card__c"))
        )
            return(true);  
        else
            return allValid;
    },
    finalValidHelper : function(component, event, helper) {
        if(
            helper.handleUploadAction(component) &&
            helper.paymentValidHelper(component) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Billing_Country__c")) &&
            !$A.util.isEmpty(component.get("v.simpleLTEActivation.Billing_State_Province_Territory__c"))
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
    handleUploadAction : function(component,text) {
        var allValid = component.find('LTEBillingField').reduce(function (validSoFar, inputCmp) {
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },        
    showToastHelper : function(component,text) {  
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Error', 
            "type": "error",
            'message' : text 
        }); 
        showToast.fire(); 
    },
})