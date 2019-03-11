({
    showListSearchProductHelper : function(component) {
        var action = component.get("c.getProductReqList");
        action.setParams({
            workOrderId : component.get("v.workOrderId")
        });
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            var state = response.getState();
            var newRecItemList =[];
            if (state === "SUCCESS" ) {
                if(results != '' && results.length > 0){
                    for(var i in results){
                        var detailtemp = {};
                        detailtemp = { 'partNumber': results[i].Product2.Name,'ProductCode': results[i].Product2.ProductCode,'prodDescription': results[i].Product2.Description,'quantity': results[i].QuantityRequired,'recordId': results[i].Id,'prodId': results[i].Product2Id};
                        newRecItemList.push(detailtemp);
                    }
                }
                for(var i = 0; i <3 ; i++){
                    var detailtemp = {};
                    detailtemp = { 'partNumber': '','ProductCode': '','prodDescription': '','quantity': '','recordId': '','prodId': ''};
                    newRecItemList.push(detailtemp);
                }
                component.set("v.wrapperList",newRecItemList);
                
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);  
        
    },
    addNewRowHelper : function(component) {        
        var recItemList = component.get("v.wrapperList");
        if(recItemList.length != 0){
            var detailtemp = {};
            detailtemp = { 'partNumber': '','ProductCode': '','prodDescription': '','quantity': '','recordId': '','prodId': ''};
            recItemList.push(detailtemp);
        }
        component.set("v.wrapperList",recItemList);
    },
    removeRowHelper : function(component, event, helper) {
        var index = event.getSource().get("v.labelClass");  
        var recItemList = component.get("v.wrapperList");
        var recName = component.get("v.wrapperList")[index];
        if(typeof recName != 'undefined'){
            if(recName.recordId == ''){
                recItemList.splice(index,1);
                component.set("v.wrapperList",recItemList);
            }
            else{
                var strMesg = 'Are you sure you want to delete '+recName.partNumber+' from the Work Order ?'
                var r = confirm(strMesg);
                if (r){
                    var newRecItemList = [];
                    var detailtemp = {};
                    detailtemp = { 'partNumber': recName.partNumber,'ProductCode': recName.ProductCode,'prodDescription': recName.prodDescription,'quantity': recName.quantity,'recordId': recName.recordId,'prodId': recName.prodId};
                    newRecItemList.push(detailtemp);
                    this.submitHelper(component,'delete',JSON.stringify(newRecItemList),index);
                }
            }
        }
    },
    submitHelper : function(component,typeDML,recName,index) {
        var action = component.get("c.saveProductRequired");
        action.setParams({
            wrapperLst : recName,
            workOrderId : component.get("v.workOrderId"),
            typeDML : typeDML
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                
                if(typeDML == 'insert'){
                    alert('Added product Successfully');
                    component.set("v.wrapperList",component.get("v.wrapperList"));
                    this.movetoWorkOrderHelper(component);
                }
                else{
                    alert('Removed product Successfully');
                    var recItemList = component.get("v.wrapperList");
                    recItemList.splice(index,1);
                    component.set("v.wrapperList",recItemList);
                }
            }
            else if(response.getState() === "ERROR"){
                var errors = action.getError();
                console.log(action.getError());
                alert('There was a system error. Please contact Salesforce Support (SF_Support@kvh.com) to alert the support team of your problem.');
            }
        });
        $A.enqueueAction(action);  
    },
    getSearchRecordValueHelper : function(component, event, helper) {
        var selectRec = event.getParam("productByEvent");
        var recItemList = component.get("v.wrapperList");
        var newRecItemList =[];
        if(recItemList.length != 0){
            var k = 0;
            for(var i in recItemList){
                if(recItemList[i].prodId == '' && k == 0 ){
                    recItemList[i].prodId = selectRec.Id;
                    recItemList[i].recordId = '';
                    recItemList[i].partNumber = selectRec.Name;
                    recItemList[i].prodDescription = selectRec.Description;
                    recItemList[i].ProductCode = selectRec.ProductCode;
                    recItemList[i].quantity = '';
                    newRecItemList.push(recItemList[i]);
                    k++;
                }
                else if(recItemList[i].prodId != ''){
                    var detailtemp = {};
                    detailtemp = { 'partNumber': recItemList[i].partNumber,'ProductCode': recItemList[i].ProductCode,'prodDescription': recItemList[i].prodDescription,'quantity': recItemList[i].quantity,'recordId': recItemList[i].recordId,'prodId': recItemList[i].prodId};
                    newRecItemList.push(detailtemp);
                }
                    else{
                        var detailtemp = {};
                        detailtemp = { 'partNumber': '','prodDescription': '','quantity': '','recordId': '','prodId': ''};
                        newRecItemList.push(detailtemp);
                    }
            }
        }
        //console.log(JSON.stringify(newRecItemList));
        component.set("v.wrapperList",newRecItemList);
    },
    movetoWorkOrderHelper : function(component) {
        var workOrderId = component.get("v.workOrderId");
        window.location.assign('/'+workOrderId);
    },
})