({
    doInit : function(component, event, helper) {
        if(component.get("v.UpdateSubscription") == false)
        {
            component.set("v.replacementAssets", true);
            helper.getAssetReplacement(component);
            helper.getObjectAccess(component);
        }
        if(component.get("v.UpdateSubscription") == true)
        {
            component.set("v.replacementAssets", false);
            helper.getAssetReplacement(component);
            helper.getObjectAccess(component);
        }
    },
    toggleUpdateSubscription : function(component, event, helper) {
        helper.changeToUpdateSubscriptionPage(component);
    },
    toggleAssetHierarchy : function(component, event, helper) {
        helper.changeToAssetHierarchy(component);
    },
    returnToCase : function(component, event, helper) {
        helper.returnToCaseHelper(component);
    },
    hideSpinner : function (component, event, helper){
        component.set("v.Spinner", false);
    },
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true);    
    },
    handleComponentEvent : function (component, event, helper) {
        var selectedReplacementAsset = event.getParam("SelectedAsset");
        var replacedAsset = event.getParam("ReplacedAsset");
        var RemovedAsset = event.getParam("RemovedAsset");
        var ReplacementType = event.getParam("ReplacementType");
        var newUpdateSubscription = event.getParam("listSubscription");
        var showSubscription = event.getParam("showSubscription");
        var messageCaseAssetMove = event.getParam("messageCaseAssetMove");
        var checkDuplicateAsset = event.getParam("checkDuplicateAsset");
        var oldListSubscription = event.getParam("oldListSubscription");
        var noAssetSubscription = event.getParam("noAssetSubscription");
        if(typeof noAssetSubscription != 'undefined' && noAssetSubscription && component.get("v.replacedAssets") == false){
            component.set("v.noAssetSubscription",true);
            component.set("v.UpdateSubscription",true);
            component.set("v.replacementAssets",false);
            component.set("v.readonlySubscriptionList",true);
            if(!component.get("v.noSubscriptionAlert")){
                alert('There are No Subscriptions related to these Assets');
                component.set("v.noSubscriptionAlert",false);
            }
        }
        if(typeof oldListSubscription != 'undefined' ){
            component.set("v.oldListSubscription",oldListSubscription);
        }
        
        if(typeof checkDuplicateAsset != 'undefined'){
            var assetNameList = component.get("v.listAssetIdInHierarchy");
            var settrue = false;
            for(var i in assetNameList)
            {
                if(assetNameList[i].Id == checkDuplicateAsset.Id)
                {
                    settrue = true;
                    var appEvent = $A.get("e.c:AssetMovementModal_evt");
                    appEvent.setParams({duplicateAssetSelected : true});
                    appEvent.fire();
                }
            }
            if(!settrue)
            {
                var appEvent = $A.get("e.c:AssetMovementModal_evt");
                appEvent.setParams({duplicateAssetSelected : false});
                appEvent.fire();
            }
        }
        if(typeof showSubscription != 'undefined' || typeof messageCaseAssetMove != 'undefined'){
            component.set("v.showSubscription",showSubscription);
            component.set("v.messageCaseAssetMove",messageCaseAssetMove);
        }
        if(typeof newUpdateSubscription != 'undefined'){
            var listSubscription = [];
            component.set("v.listSubscription","");
            
            for(var i in newUpdateSubscription){
                listSubscription.push(newUpdateSubscription[i]);
            }
            component.set("v.listSubscription",listSubscription);
        }
        if(typeof ReplacementType != 'undefined'){
            component.set("v.ReplacementType",ReplacementType);
        }
        if(typeof selectedReplacementAsset != 'undefined'){
            component.set("v.UpdateSubscription",false);
            component.set("v.replacementAssets",false);
            component.set("v.replacementAsset",selectedReplacementAsset);
            component.set("v.replacedAssets",true);
            
            var replacementAsset = component.get("v.replacementAsset");
            var replacedAsset = component.get("v.replacedAsset");
            var ReplacementType = component.get("v.ReplacementType");
            console.log(replacedAsset.RecordTypeName == 'Identifier');
            console.log(replacedAsset.Root_Asset.HTS_REady__c);
            console.log(replacedAsset.Root_Asset.Product2.Name.includes('HTS'));
            console.log(JSON.stringify(replacedAsset.Root_Asset)+'=====');
            if(replacedAsset.RecordTypeName == 'Identifier' && 
               (replacedAsset.Root_Asset.HTS_REady__c ||
                replacedAsset.Root_Asset.Product2.Name.includes("HTS"))){
                helper.IdentifierAssetHelper(component);
            }
            else{
                if(ReplacementType == 'Replace'){
                    if( replacedAsset.HTS_REady__c == true && 
                       replacementAsset.HTS_REady__c == false )
                        helper.validateAntennaHTSRequest(component);
                    else
                        helper.validateHTSRequest(component);
                }
            }
        }
        else if(typeof replacedAsset != 'undefined'){
            //alert('replacedAsset:::'+JSON.stringify(replacedAsset));
            component.set("v.replacedAsset",replacedAsset);
        }
            else if(typeof RemovedAsset != 'undefined'){
                component.set("v.replacedAsset",RemovedAsset);
                helper.removeAssetReplacement(component);
            }
    },
    closeModal : function(component, event, helper) {
        var className1 = event.getParam("className1");
        var className2 = event.getParam("className2");
        var listAssetIdInHierarchy = event.getParam("listAssetIdInHierarchy");
        var noProduct = event.getParam("noProduct");
        if(typeof className1 != 'undefined' && typeof className2 != 'undefined'){
            helper.toggleClassInverse(component,'backdrop',className1);
            helper.toggleClassInverse(component,'modaldialog',className2);
        }
        if(typeof listAssetIdInHierarchy != 'undefined'){
            component.set("v.listAssetIdInHierarchy",listAssetIdInHierarchy);
        }
        if(typeof noProduct != 'undefined'){
            alert('There are asset(s) within the system that does not have a related product. Review and update assets as required.');
            helper.returnToCaseHelper(component);
        }
    },
    closeAlert:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    SubmitAssetMove : function(component, event, helper) {
        if(component.get("v.replacedby") == 'Service Partner' && typeof component.get("v.selectedServicePartner") == 'undefined'){
            alert('Please select Service Partner.');
        }
        else{
            if(component.get("v.ReplacementType") == 'Add')
                component.set("v.alertMessage",'Are sure you want to add the Asset with these updated Warranty replacement values ?') 
                else
                    component.set("v.alertMessage",'Are sure you want to replace the Asset with these updated Warranty replacement values ?') 
                    
                    var r = confirm(component.get("v.alertMessage"));
            if (r){
                helper.submitAssetMoveHelpercomponent(component);
            }
            /*
            component.set("v.warrStartDate",component.get("v.replacedAsset.Warranty_Start_Date__c"));
            component.set("v.warrType",component.get("v.replacedAsset.Warranty_Type__c"));
            component.set("v.warrEndDate",component.get("v.replacedAsset.Warranty_End_Date__c"));
            if(typeof component.get("v.replacedAsset.Warranty_Period_Months__c") != 'undefined')
            component.set("v.warrMonth",component.get("v.replacedAsset.Warranty_Period_Months__c"));
            else
                component.set("v.warrMonth","");
            var cmpTarget = component.find('Modalbox');
            var cmpBack = component.find('Modalbackdrop');
            $A.util.addClass(cmpTarget, 'slds-fade-in-open');
            $A.util.addClass(cmpBack, 'slds-backdrop--open');
            helper.getWarrantyTypeValues(component);
            */
            //helper.submitAssetMoveHelpercomponent(component);
        }
    },
    FinalSubmitAssetMove : function(component, event, helper) {
        component.set("v.replacementAsset.Warranty_Start_Date__c",component.get("v.warrStartDate"));
        component.set("v.replacementAsset.Warranty_Type__c",component.get("v.warrType"));
        component.set("v.replacementAsset.Warranty_Period_Months__c",component.get("v.warrMonth"));
        helper.submitAssetMoveHelpercomponent(component);
    },
    onChangeWarrantType : function(component, event, helper) {
        var selected = component.find("warrantyType").get("v.value");
        var sdateField =document.getElementById("dateField").value; 
        var sdateFieldNew = new Date(sdateField);
        var eDateField = new Date();
        var warrantype = [];
        warrantype  = component.get("v.warrantyType");
        for(var i in warrantype){            
            if(warrantype[i].key == selected){
                if(warrantype[i].value != ''){
                    eDateField = helper.addMonthsNoOverflow(sdateFieldNew,parseInt(warrantype[i].value));
                    eDateField = helper.formatDate(eDateField);
                    component.set("v.warrMonth",warrantype[i].value);
                }
                else{
                    component.set("v.warrEndDate","");
                    component.set("v.warrMonth","");
                }
            }
        }
        component.set("v.warrEndDate",eDateField);
        component.set("v.warrStartDate",sdateField);
        
    },
    
    getServicePartner : function(component, event, helper) {
        var selectedAccountGetFromEvent = event.getParam("productByEvent");
        component.set("v.selectedServicePartner" , selectedAccountGetFromEvent.Id);
    },
    onSelectChange : function(component, event, helper) {
        var replacedby = component.find("InputSelectDynamic").get("v.value");
        component.set("v.replacedby" , replacedby);
        var disableServicePartner = component.find("disableServicePartner");
        var enableServicePartner = component.find("enableServicePartner");
        if(replacedby == 'Service Partner' ){
            $A.util.addClass(disableServicePartner,'hideSP');
            $A.util.removeClass(enableServicePartner,'hideSP');
        }
        else{
            $A.util.removeClass(disableServicePartner,'hideSP');
            $A.util.addClass(enableServicePartner,'hideSP');
        }
    },
    reversealertAssetMoveHelper : function(component) { 
        var cmpTarget = component.find('alertModalbox');
        var cmpBack = component.find('alertModalbackdrop'); 
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.replacementAsset" , null);
        component.set("v.UpdateSubscription",false);
        component.set("v.replacedAsset" , null);
        component.set("v.replacementAssets",true);
        component.set("v.replacedAssets",false);
    },
    continueAssetMoveHTS : function(component, event, helper) {
        var cmpTarget = component.find('HTSModalbox');
        var cmpBack = component.find('HTSModalbackdrop'); 
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    ReverseAssetMove : function(component, event, helper) {
        helper.reverseAssetMoveHelper(component);
    },
    ReverseAssetMoveHTS : function(component, event, helper) {
        helper.reverseAssetMoveHTSHelper(component);
    },
    cancelTransaction : function(component, event, helper) {
        helper.cancelTransactionHelper(component);
    },
    updateSubscription : function(component, event, helper) {
        var r = confirm("Are you sure you want to update the subscription(s)?");
        if (r )
        {
            helper.updateSubscriptionHelper(component);
        }
    },
    removeSubscriptionMove : function(component, event, helper) {
        helper.removeSubscriptionMoveHelper(component);
    },    
})