({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        if(component.get("v.serviceDetail") != 'Mobile Data Carrier, KVH Mini-VSAT FLEX KU Band Service')
            component.set("v.beamregiontype", 'beam');
        else
            component.set("v.beamregiontype", 'flex');
        helper.getBeamList(component);
    },
    hideSpinner : function (component, event, helper){
        component.set("v.Spinner", false);
    },
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true);    
    },
    AddNewRow : function (component, event, helper) {
        var recItemList = component.get("v.wrapperList");
        if(recItemList.length != 0){
            var detailtemp = {};
            detailtemp = { 'recordId': '','recordName': '','recordFullName': '','recordURL': ''};
            recItemList.push(detailtemp);
        }
        component.set("v.wrapperList",recItemList);
    },
    removeRow : function (component, event, helper) {
        var index = event.getSource().get("v.buttonTitle");  
        var recItemList = component.get("v.wrapperList");
        var recName = component.get("v.wrapperList")[index];
        if(typeof recName != 'undefined'){
            if(recName.recordId == '')
                recItemList.splice(index,1);
            else{
                var strMesg = 'Are you sure you want to delete '+recName.recordName+' from the list ?'
                var r = confirm(strMesg);
                if (r)
                    recItemList.splice(index,1);
            }
        }
        component.set("v.wrapperList",recItemList);
        console.log(JSON.stringify(component.get("v.wrapperList")));
    },
    getSearchRecordValue : function(component, event, helper) {
        var selectRec = event.getParam("productByEvent");
        console.log('====selectRec==='+selectRec);
        var recItemList = component.get("v.wrapperList");
        var newRecItemList =[];
        if(recItemList.length != 0){
            var k = 0;
            if(component.get("v.beamregiontype") == 'beam'){
                for(var i in recItemList){
                    if(recItemList[i].recordId == '' && k == 0 ){
                        recItemList[i].recordId = selectRec.Id;
                        recItemList[i].recordName = selectRec.Name;
                        recItemList[i].recordFullName = selectRec.Beam_Full_Name__c;
                        recItemList[i].recordURL = selectRec.KVH_Website_URL__c;
                        k++;
                    }
                }
            }
            else{
                for(var i in recItemList){
                    if(recItemList[i].recordId == '' && k == 0 ){
                        recItemList[i].recordId = selectRec.Id;
                        recItemList[i].recordName = selectRec.Name;
                        recItemList[i].recordFullName = selectRec.Name;
                        recItemList[i].recordURL = selectRec.Region_URL__c;
                        k++;
                    }
                }
                
            }
        }
        component.set("v.UpdatedWrapperList",recItemList);
        //console.log(JSON.stringify(component.get("v.wrapperList")));
        console.log(JSON.stringify(component.get("v.UpdatedWrapperList")));
    },
    addBeamRegion : function(component, event, helper) {
        console.log(JSON.stringify(component.get("v.wrapperList")));
        var r = confirm("Are you sure want to submit the transcation ?");
        if (r){
            var recItemList = component.get("v.wrapperList");
            var newRecItemList =[];
            if(recItemList.length != 0){
                for(var i in recItemList){
                    if(recItemList[i].recordId != ''){
                        var detailtemp = {};
                        detailtemp = { 'recordId': recItemList[i].recordId,'recordName': recItemList[i].recordName,'recordFullName': recItemList[i].recordFullName,'recordURL': recItemList[i].recordURL};
                        newRecItemList.push(detailtemp);
                    }
                }
            }
            component.set("v.UpdatedWrapperList",newRecItemList);
            
            console.log('====================');
            console.log(JSON.stringify(component.get("v.UpdatedWrapperList")));
            helper.saveBeamRegion(component);
        }
        
    }
})