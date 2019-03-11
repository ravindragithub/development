({
    getBeamList : function(component) {
        var action = component.get("c.getBeamListMethod");
        action.setParams({
            caseId : component.get("v.caseId"),
            beamregiontype : component.get("v.beamregiontype")
        });
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            var state = response.getState();
            console.log(JSON.stringify(results)+'==results==');
            if (state === "SUCCESS" ) {
                if(results != '' && results.length > 0)
                    component.set("v.wrapperList",results);
                else{
                    var recItemList = [];
                    var detailtemp = {};
                    detailtemp = { 'recordId': '','recordName': '','recordFullName': '','recordURL': ''};
                    recItemList.push(detailtemp);
                    component.set("v.wrapperList",recItemList);
                }
                
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);  
    },
    saveBeamRegion : function(component) {
        var action = component.get("c.saveMultipleBeams");
        var caseId = component.get("v.caseId");
        action.setParams({
            wrapperLst : JSON.stringify(component.get("v.UpdatedWrapperList")),
            caseId : component.get("v.caseId"),
            beamregiontype : component.get("v.beamregiontype")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                component.set("v.wrapperList",component.get("v.UpdatedWrapperList"));
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);  
    }
})