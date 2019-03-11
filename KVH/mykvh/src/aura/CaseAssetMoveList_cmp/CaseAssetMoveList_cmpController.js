({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCaseAssetMove");
        action.setParams({
            assetId : component.get("v.assetId"),
            caseId : component.get("v.caseId")
        });
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS" ) {
                //console.log(results);
                //console.log(results.length);
                if(results.length == 0)
                {
                    var compEvent = component.getEvent("cmpEvnt");
                    compEvent.setParams({"showSubscription" : true,"messageCaseAssetMove" : "Assets not moved for this Case" });
                    compEvent.fire();
                }
                else if(results[0].Asset_Being_Removed__c == null || results[0].Asset_Being_Removed__c == '')
                {
                    var compEvent = component.getEvent("cmpEvnt");
                    compEvent.setParams({"showSubscription" : true,"messageCaseAssetMove" : "There are no Subscriptions related to the Asset Being Removed" });
                    compEvent.fire();
                }
                else
                {
                    var replacedAsset = { "Id" : results[0].Asset_Being_Removed__c,"Name" : results[0].Asset_Being_Removed__r.Name};
                    //alert(JSON.stringify(replacedAsset)+'In Case Asset Move');
                    var compEvent = component.getEvent("cmpEvnt");
                    compEvent.setParams({"ReplacedAsset" : replacedAsset});
                    compEvent.fire();
                    
                }
                component.set("v.AssetCaseMoveList",results);
            }
            else {
                console.log('Error'+response.getError());
            }
        });
        $A.enqueueAction(action);  
        
    }
})