({
    doInit : function(component, event, helper) {
        helper.showListSearchProductHelper(component);
    },  
    hideSpinner : function (component, event, helper){
        component.set("v.Spinner", false);
    },
    showSpinner : function (component, event, helper) {
        component.set("v.Spinner", true);    
    },
    addNewRow : function (component, event, helper) {
        helper.addNewRowHelper(component);
    },
    removeRow : function (component, event, helper) {
        helper.removeRowHelper(component, event, helper);
    },
    movetoWorkOrder : function(component, event, helper) {
        helper.movetoWorkOrderHelper(component);
    },
    submit : function(component, event, helper) {
        var recItemList = component.get("v.wrapperList");
        var isEmpLst = true;
        if(recItemList.length != 0){
            for(var i in recItemList){
                if(recItemList[i].prodId != ''){
                    isEmpLst = false;
                }
            }
            if(isEmpLst){
                alert('Enter atleast one Product to the work order');
            }
            else{
                var strMesg = 'Are you sure you want to submit the list of Product?'
                var r = confirm(strMesg);
                if (r)
                    helper.submitHelper(component,'insert',JSON.stringify(component.get("v.wrapperList")),null);
            }
        }
        
    },
    getSearchRecordValue : function(component, event, helper) {
        helper.getSearchRecordValueHelper(component, event, helper);
    },
})