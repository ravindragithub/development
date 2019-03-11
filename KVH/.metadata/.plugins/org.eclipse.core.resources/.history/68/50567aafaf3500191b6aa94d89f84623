({
    doInit : function(component, event, helper) {
        helper.helperMethod(component);
    },
    handleClick : function(component, event, helper){
        var platformId = event.getSource().get("v.name");
        var accountId = event.getSource().get("v.value");
        var baId = event.getSource().get("v.ariaLabel");    
        var corpbaId = event.getSource().get("v.ariaDescribedBy");    
        var r = confirm('You want proceed with selected Customer Account?');  
        if(r){            
            component.set("v.simpleLTEActivation.Platform_Account__c",platformId);
            component.set("v.simpleLTEActivation.Account__c",accountId);
            component.set("v.simpleLTEActivation.Billing_Account__c",baId);
            component.set("v.simpleLTEActivation.Corporate_Billing_Account__c",corpbaId);
            component.set("v.isOpen",false);
        }
    },
    getBillingAccountInfo : function(component, event, helper){
        var accountId = event.getSource().get("v.value");
        var baId = event.getSource().get("v.name");          
        var platformId = event.getSource().get("v.ariaLabel");
        var r = confirm('You want proceed with selected Customer Account?');  
        if(r){            
            component.set("v.simpleLTEActivation.Account__c",accountId);
            component.set("v.simpleLTEActivation.Billing_Account__c",baId);
            component.set("v.simpleLTEActivation.Platform_Account__c",platformId);
            component.set("v.isOpen",false);   
        }
    },
    onGroup : function(component, event, helper){
        var index = event.currentTarget.dataset.index;
        var corpbaId = component.get("v.accountHierarchyWrapper")[index].corporateAccount.Id;
        var accountId = component.get("v.accountHierarchyWrapper")[index].corporateAccount.Account__c;
        var r = confirm('You want proceed with selected Corporate Account?');  
        if(r){            
            component.set("v.simpleLTEActivation.Account__c",accountId);
            component.set("v.simpleLTEActivation.Corporate_Billing_Account__c",corpbaId);
            component.set("v.typeForm", "Multiple Corporate");  
            component.set("v.isOpen",false); 
        }
    },
    handleContinueModal : function(component, event, helper){ 
        //console.log('==Account__c==' + component.get("v.simpleLTEActivation.Account__c")); 
        //console.log('==Billing_Account__c==' + component.get("v.simpleLTEActivation.Billing_Account__c")); 
        //console.log('==Corporate_Billing_Account__c==' + component.get("v.simpleLTEActivation.Corporate_Billing_Account__c")); 
        //console.log('==Platform_Account__c==' + component.get("v.simpleLTEActivation.Platform_Account__c")); 
        //console.log('==typeForm==' + component.get("v.typeForm"));   
        
        if(component.get("v.typeForm") == 'Multiple Customer'){
            component.set("v.typeForm",'Multiple Corporate');
        }
        else if(component.get("v.typeForm") == 'Single Customer' || 
                component.get("v.typeForm") == 'Multiple Corporate'){
            //var intiMethod = component.get("v.accountHierarchyWrapper");
            //component.set("v.simpleLTEActivation.Account__c",intiMethod[0].customerSingleAccount.Account__c);
            component.set("v.isOpen",false);
        }
        //console.log('==Account__c==' + component.get("v.simpleLTEActivation.Account__c")); 	
    },
    handleBackModal : function(component, event, helper){
        component.set("v.typeForm",'Multiple Customer');
    },    
})