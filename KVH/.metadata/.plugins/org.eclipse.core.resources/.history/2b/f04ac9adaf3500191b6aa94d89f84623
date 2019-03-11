({
    keyPressController : function(component, event, helper) 
    {
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if( getInputkeyWord.length > 3 )
        {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else
        {  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    clear :function(component,event,heplper)
    {   
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        component.set("v.AssetRec" , null); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.listofRecordsCount", "0" );
    },
    selectAsset : function(component, event, helper)
    {   
        var index = event.getSource().get("v.title");  
        var assetRec = component.get("v.listOfSearchRecords")[index];
        component.set("v.AssetRec" , assetRec); 
        var compEvent = component.getEvent("cmpEvnt");
        compEvent.setParams({"checkDuplicateAsset" : assetRec});
        compEvent.fire();
    },
    getDuplicateAssetCheck : function(component, event, helper) 
    {
        var duplicateAssetSelected = event.getParam("duplicateAssetSelected");
        if(typeof duplicateAssetSelected != 'undefined' && duplicateAssetSelected == true)
        {
            alert('Asset already selected');
            component.set("v.AssetRec" , ""); 
        }
        else
        {            
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
        }
    },
    submitAssetSearchSelect : function(component, event, helper) 
    {
        var AssetSelected = component.get("v.AssetRec"); 
        if(AssetSelected == null || AssetSelected == '')
        {
            alert('Please enter 3 charater of Asset Name.');
        }
        else
        {
            var compEvent = component.getEvent("cmpEvnt");
            compEvent.setParams({"SelectedAsset" : AssetSelected , "ReplacementType" : component.get("v.ReplacementType")});
            compEvent.fire();
        }
    },
    getAssetListInHierarchy : function(component, event, helper) 
    {
        var listAssetIdInHierarchy = event.getParam("listAssetIdInHierarchy");
        if(typeof listAssetIdInHierarchy != 'undefined')
        {
            component.set("v.listAssetIdInHierarchy",listAssetIdInHierarchy);
        }
    },
})