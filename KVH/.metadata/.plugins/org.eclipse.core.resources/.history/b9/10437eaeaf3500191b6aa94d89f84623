({
    doInit : function(component, event, helper) {
        helper.getSubscriptionRecords(component);
        helper.getSubscriptionStatus(component);
    },
    subsStatusChange : function(component, event, helper) {
        var index = event.getSource().getElement().value;
        var index2 = event.getSource().get("v.labelClass");  
        var subRec = component.get("v.listSubscription")[index2];
        var subList = component.get("v.listSubscription");
        var sendingUpdateList = [];
        
        var checkFlag = false;
        if(subList.length > 0 && checkFlag == false){
            checkFlag == true;
            var compEvent = component.getEvent("cmpEvnt");
            compEvent.setParams({"oldListSubscription" : subList });
            compEvent.fire();
        }
        
        var updatedList = component.get("v.sendinglistSubscription");
        if(updatedList.length == 0 ){
            var sendingListObject = {};
            sendingListObject = {"Status__c" : "","Id":"","Name":""}
            sendingListObject.Status__c = index;
            sendingListObject.Id = subRec.Id;
            sendingListObject.Name = subRec.Name;
            sendingUpdateList.push(sendingListObject);
        }
        var checkLoopFlag = false;
        if(updatedList.length != 0 ){
            for(var i in updatedList){
                if(updatedList[i].Id == subRec.Id){
                    checkLoopFlag = true;
                    if(index != 'None'){
                        var sendingListObject = {};
                        sendingListObject = {"Status__c" : "","Id":"","Name":""}
                        sendingListObject.Status__c = index;
                        sendingListObject.Id = updatedList[i].Id;
                        sendingListObject.Name = updatedList[i].Name;
                        sendingUpdateList.push(sendingListObject);
                    }
                }
                else{
                    var sendingListObject = {};
                    sendingListObject = {"Status__c" : "","Id":"","Name":""}
                    sendingListObject.Status__c = updatedList[i].Status__c;
                    sendingListObject.Id = updatedList[i].Id;
                    sendingListObject.Name = updatedList[i].Name;
                    sendingUpdateList.push(sendingListObject);
                }
            }
            if(!checkLoopFlag){
                var sendingListObject = {};
                sendingListObject = {"Status__c" : "","Id":"","Name":""}
                sendingListObject.Status__c = index;
                sendingListObject.Id = subRec.Id;
                sendingListObject.Name = subRec.Name;
                sendingUpdateList.push(sendingListObject);
            }
        }
        
        if(sendingUpdateList.length > 0){
            component.set("v.sendinglistSubscription",sendingUpdateList);
            var compEvent = component.getEvent("cmpEvnt");
            compEvent.setParams({"listSubscription" : component.get("v.sendinglistSubscription") });
            compEvent.fire();
        }
    },
    onAssetNameChange : function(component, event, helper) {
        var index = event.getSource().getElement().value;
        var index2 = event.getSource().get("v.labelClass");  
        var subRec = component.get("v.listSubscription")[index2];
        var subList = component.get("v.listSubscription");
        
        var sendingUpdateList = [];
        
        var checkFlag = false;
        if(subList.length > 0 && checkFlag == false){
            checkFlag == true;
            var compEvent = component.getEvent("cmpEvnt");
            compEvent.setParams({"oldListSubscription" : subList });
            compEvent.fire();
        }
        
        var updatedList = component.get("v.sendinglistSubscription");
        if(updatedList.length == 0 ){
            var sendingListObject = {};
            sendingListObject = {"Asset__c" : "","Id":"","Name":""}
            sendingListObject.Asset__c = index;
            sendingListObject.Id = subRec.Id;
            sendingListObject.Name = subRec.Name;
            sendingUpdateList.push(sendingListObject);
        }
        var checkLoopFlag = false;
        if(updatedList.length != 0 ){
            for(var i in updatedList){
                if(updatedList[i].Id == subRec.Id){
                    checkLoopFlag = true;
                    if(index != 'None'){
                        var sendingListObject = {};
                        sendingListObject = {"Asset__c" : "","Id":"","Name":""}
                        sendingListObject.Asset__c = index;
                        sendingListObject.Id = updatedList[i].Id;
                        sendingListObject.Name = updatedList[i].Name;
                        sendingUpdateList.push(sendingListObject);
                    }
                }
                else{
                    var sendingListObject = {};
                    sendingListObject = {"Asset__c" : "","Id":"","Name":""}
                    sendingListObject.Asset__c = updatedList[i].Asset__c;
                    sendingListObject.Id = updatedList[i].Id;
                    sendingListObject.Name = updatedList[i].Name;
                    sendingUpdateList.push(sendingListObject);
                }
            }
            if(!checkLoopFlag){
                var sendingListObject = {};
                sendingListObject = {"Asset__c" : "","Id":"","Name":""}
                sendingListObject.Asset__c = index;
                sendingListObject.Id = subRec.Id;
                sendingListObject.Name = subRec.Name;
                sendingUpdateList.push(sendingListObject);
            }
        }
        
        if(sendingUpdateList.length > 0){
            component.set("v.sendinglistSubscription",sendingUpdateList);
            var compEvent = component.getEvent("cmpEvnt");
            compEvent.setParams({"listSubscription" : component.get("v.sendinglistSubscription") });
            compEvent.fire();
        }
        //console.log(JSON.stringify(component.get("v.sendinglistSubscription"))+'==sendinglistSubscription');
        
        //component.set("v.listSubscription",subList);
    },
})