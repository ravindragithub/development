({
    getAssetReplacement : function(component) {
        var action = component.get("c.getCaseAssetMove");
        action.setParams({
            assetId : component.get("v.assetId"),
            caseId : component.get("v.caseId")
        });
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS" ) 
            {
                if(results.length == 0)
                {
                    if(component.get("v.UpdateSubscription") == true){
                        alert('Assets not moved for this Case');
                        component.set("v.showChangeSubscription",true);
                    }
                }
                else if(results[0].Asset_Being_Removed__c == null || results[0].Asset_Being_Removed__c == '')
                {
                    if(component.get("v.UpdateSubscription") == true){
                        alert('Unable to Show the Subscriptions, Asset Being Removed Is Null');
                        component.set("v.showChangeSubscription",true);
                    }
                }
                    else if(typeof results[0].Asset_Being_Removed__c != 'undefined' )
                    {
                        var replacedAsset = { "Id" : results[0].Asset_Being_Removed__c,"Name" : results[0].Asset_Being_Removed__r.Name};
                        component.set("v.replacedAsset",replacedAsset);  
                    }
            }
            
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);  
    },
    changeToUpdateSubscriptionPage : function(component) {
        if( component.get("v.showSubscription") == false)
        {
            component.set("v.UpdateSubscription",true);
            component.set("v.replacementAssets",false);
        }
        else
        {
            var errorMessg = component.get("v.messageCaseAssetMove");
            alert(errorMessg);
        }
    },
    addMonthsNoOverflow : function(dateParam, intParam) {
        console.log(dateParam.getTime()+'===sum13');
        var sum = new Date(new Date(dateParam.getTime()).setMonth(dateParam.getMonth() + intParam));
        if (sum.getDate() < dateParam.getDate()) {  sum.setDate(0);  }
        return(sum);
    },
    formatDate : function(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();
        
        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;
        
        return [year, month, day].join('-');
    },
    changeToAssetHierarchy : function(component) {
        component.set("v.UpdateSubscription",false);
        component.set("v.replacementAssets",true);
    },
    returnToCaseHelper : function(component) {
        var caseId = component.get("v.caseId");
        window.location.assign('/'+caseId);
    },
    Service_I2CMFieldSwapHelper : function(component) {
        console.log('Inside Service_I2CMFieldSwapHelper');
        var replacedAsset = component.get("v.replacedAsset");
        var replacementAsset = component.get("v.replacementAsset");
        var action = component.get("c.Service_I2CMFieldSwapMethod");
        action.setParams({
            replacedAsset : replacedAsset,
            replacementAsset : replacementAsset
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state === "SUCCESS" ) {
                if (storeResponse == "false" ){
                    var cmpTarget = component.find('alertModalbox');
                    var cmpBack = component.find('alertModalbackdrop');
                    $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.addClass(cmpBack, 'slds-backdrop--open');
                    var strMessage= 'The Case Asset Move could not be completed due to an error. A case has been submitted to Salesforce Support for further followup.';
                    component.set("v.HTSMessage",strMessage); 
                }
                else
                    this.submitAssetMoveHelpercomponentFinal(component);
            }
            else if(state === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    submitAssetMoveHelpercomponent : function(component) {
        var replacedAsset = component.get("v.replacedAsset");
        var replacementAsset = component.get("v.replacementAsset");
        var ReplacementType = component.get("v.ReplacementType");
        //Call I2CM service class
        if(replacementAsset.Item__c.includes('02-2204-02') && 
           replacedAsset.Item__c.includes('02-2204-02') &&
           component.get("v.HTSReady") == 'ready'  )
            this.Service_I2CMFieldSwapHelper(component);
        else
            this.submitAssetMoveHelpercomponentFinal(component);
    },
    submitAssetMoveHelpercomponentFinal : function(component) {
        var replacedAsset = component.get("v.replacedAsset");
        var replacementAsset = component.get("v.replacementAsset");
        var ReplacementType = component.get("v.ReplacementType");
        var action = component.get("c.updateAssetReplacement");
        action.setParams({
            caseId : component.get("v.caseId"),
            replacedAsset : replacedAsset,
            replacementAsset : replacementAsset,
            ReplacementType : ReplacementType,
            ServicePartner : component.get("v.selectedServicePartner"),
            replacedby : component.get("v.replacedby"),
            HTSReady : component.get("v.HTSReady"),
            antennaAsset : component.get("v.antennaAsset")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cmpTarget = component.find('Modalbox');
            var cmpBack = component.find('Modalbackdrop');
            $A.util.removeClass(cmpBack,'slds-backdrop--open');
            $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
            if (state === "SUCCESS" ) {
                var storeResponse = response.getReturnValue();
                component.set("v.replacedAsset" , replacedAsset);
                component.set("v.UpdateSubscription",false);
                component.set("v.replacementAssets",true);
                component.set("v.replacedAssets",false);
                component.set("v.showSubscription",false);
                component.set("v.readonlySubscriptionList",false);
                component.set("v.HTSReady",'')
                component.set("v.antennaAsset",null)
            }
            else if(state === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');                
                this.reverseAssetMoveHelper(component);
            }
        });
        $A.enqueueAction(action);
        
    },
    IdentifierAssetHelper : function(component) {  
        var cmpTarget = component.find('alertModalbox');
        var cmpBack = component.find('alertModalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        var strMessage= 'Identifier Asset for an HTS System cannot be replaced as it affects other functionality.. Please contact KVH Salesforce Support if you have any questions.';
        component.set("v.HTSMessage",strMessage); 
    },
    reverseAssetMoveHelper : function(component) {        
        component.set("v.replacementAsset" , null);
        component.set("v.UpdateSubscription",false);
        component.set("v.replacedAsset" , null);
        component.set("v.replacementAssets",true);
        component.set("v.replacedAssets",false);
    },
    reverseAssetMoveHTSHelper : function(component) { 
        var cmpTarget = component.find('HTSModalbox');
        var cmpBack = component.find('HTSModalbackdrop'); 
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.replacementAsset" , null);
        component.set("v.UpdateSubscription",false);
        component.set("v.replacedAsset" , null);
        component.set("v.replacementAssets",true);
        component.set("v.replacedAssets",false);
    },
    cancelTransactionHelper : function(component) {
        var r = confirm("Are you sure want to return to the case with no further transcations ?");
        if (r){
            var caseId = component.get("v.caseId");
            window.location.assign('/'+caseId);
        }
    },
    validateAntennaHTSRequest : function(component) {
        console.log('Replace Antenna Asset');
        var cmpTarget = component.find('HTSModalbox');
        var cmpBack = component.find('HTSModalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        var strMessage= 'The HTS Antenna cannot be replaced with a NON-HTS Antenna';
        component.set("v.HTSReady",''); 
        component.set("v.HTSMessage",strMessage); 
        component.set("v.antennaAsset",null);
    },
    validateHTSRequest : function(component) {
        console.log('Replace Non Antenna Asset');
        var action = component.get("c.validateHTSAsset");  
        var replacementAsset = component.get("v.replacementAsset");
        var replacedAsset = component.get("v.replacedAsset");
        action.setParams({
            replaceAssetId : replacedAsset.Id
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var cmpTarget = component.find('HTSModalbox');
                var cmpBack = component.find('HTSModalbackdrop');
                var mymap = a.getReturnValue();
                for(var key in mymap){
                    console.log(key);
                    if(replacementAsset.Item__c.includes('02-2204-02') && 
                       replacedAsset.Item__c.includes('02-2204-02')){
                        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                        $A.util.addClass(cmpBack, 'slds-backdrop--open');
                        if(key == 'not ready'){
                            var strMessage= 'Have you confirmed that the Antenna has been upgraded with the Conversion Kit: '+mymap[key].HTS_Conversion_Kit__c +' ?';
                            component.set("v.HTSReady",key);  
                            component.set("v.HTSMessage",strMessage);  
                            component.set("v.antennaAsset",mymap[key]);
                        }
                        else if(key == 'ready'){
                            var strMessage= 'The Antenna has been Upgraded to be HTS Ready.';
                            component.set("v.HTSReady",key);  
                            component.set("v.HTSMessage",strMessage);  
                            component.set("v.antennaAsset",mymap[key]);   
                        }
                    }
                    else if(replacementAsset.Item__c.includes('02-2204-02') && 
                            replacedAsset.Item__c.includes('02-2204-02')){
                        console.log('2nd Condition==========');
                        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                        $A.util.addClass(cmpBack, 'slds-backdrop--open');
                        if(key == 'ready'){
                            var strMessage= 'The Antenna has been Upgraded to be HTS Ready.';
                            component.set("v.HTSReady",key);  
                            component.set("v.HTSMessage",strMessage); 
                            component.set("v.antennaAsset",mymap[key]);  
                            console.log('Swap Service Class');
                        }
                        else if(key == 'not ready'){
                            var strMessage= ' Have you confirmed that the Antenna has been Upgraded to be HTS Ready?';
                            component.set("v.HTSMessage",strMessage); 
                            component.set("v.HTSReady",'');  
                        }
                    }
                    if((replacementAsset.Item__c.includes('02-2204-02') && 
                        replacedAsset.Item__c.includes('02-2204-02') ) ||
                       (replacementAsset.Item__c.includes('02-2204-02') && 
                        replacedAsset.Item__c.includes('02-2204-02')) ){
                        if( key == 'not found'){
                            var strMessage= 'No HTS Antenna Found for this System.';
                            component.set("v.HTSReady",''); 
                            component.set("v.HTSMessage",strMessage); 
                            component.set("v.antennaAsset",null);
                        }
                        else if( key == 'more'){
                            var strMessage= 'More than one HTS Antenna Found for this System.';
                            component.set("v.HTSReady",''); 
                            component.set("v.HTSMessage",strMessage); 
                            component.set("v.antennaAsset",null);
                        }
                    }
                    
                }
            } 
            else if(a.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);
    },
    removeAssetReplacement : function(component)  {   
        var action = component.get("c.deleteAssetReplacement");
        action.setParams({	
            assetDelete : component.get("v.replacedAsset"),
            caseId : component.get("v.caseId")
        });
        action.setCallback(this, function(response) {
            var results;
            if(component.isValid() && response.getState() === "SUCCESS") {
                component.set("v.replacementAssets",false);
                component.set("v.replacementAssets",true);
                component.set("v.showSubscription",false);
                component.set("v.readonlySubscriptionList",false);
            } 
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
            
        });
        $A.enqueueAction(action);  
    },
    updateSubscriptionHelper : function(component) {
        var action = component.get("c.updateSubscriptionList");
        action.setParams({	
            listSubscription : component.get("v.listSubscription")
        });
        action.setCallback(this, function(response) {
            var results;
            if(component.isValid() && response.getState() === "SUCCESS") {
                component.set("v.UpdateSubscription",false);
                component.set("v.UpdateSubscription",true);
                component.set("v.subscriptionUpdated",true);
                component.set("v.noSubscriptionAlert",true);
            } 
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action); 
    },
    removeSubscriptionMoveHelper : function(component) {
        
        var oldListSubscription = component.get("v.oldListSubscription");
        var action = component.get("c.updateSubscriptionList");
        action.setParams({	
            listSubscription : oldListSubscription
        });
        action.setCallback(this, function(response) {
            var results;
            if(component.isValid() && response.getState() === "SUCCESS") {
                component.set("v.listSubscription","");
                component.set("v.UpdateSubscription",false);
                component.set("v.UpdateSubscription",true);
                component.set("v.subscriptionUpdated",false);
                component.set("v.readonlySubscriptionList",false);
                
            } 
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action); 
    },
    getObjectAccess : function(component) {
        var action = component.get("c.getObjectAccessMethod");
        action.setCallback(this, function(response) {
            if(component.isValid() && response.getState() === "SUCCESS") {
                var objectAccessFlag = response.getReturnValue();
                if(!objectAccessFlag){
                    component.set("v.readonlySubscriptionList",true);
                }
            } 
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action); 
    },
    getWarrantyTypeValues : function(component) {
        console.log('Inside getWarrantyTypeValues');
        var action = component.get("c.getWarrantypeValues");        
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var custs = [];
                var conts = a.getReturnValue();
                console.log(conts);
                for ( key in conts ) {
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.warrantyType", custs);
            } 
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);
    },
    toggleClass : function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
    },
    toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal,className+'hide');
        $A.util.removeClass(modal,className+'open');
    },
})