({
    doInit: function(component, event, helper) {       
        component.set("v.spinner", true);
        helper.getCaseshelper(component); 
        helper.getWebProductServiceType(component, helper);         
    }, 
    onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    parentComponentEvent : function(component, event, helper) {         
        var filterListEvt = event.getParam("filterListEvt");
        //console.log(JSON.stringify(filterListEvt));
        var newCaseStatus = [],newCaseType = [];
        var caseStatus = '' ,caseType = '';
        for(var key in filterListEvt){
            if(filterListEvt[key].filter == 'Type'){                
                newCaseType.push(filterListEvt[key].value);	
                caseType+= filterListEvt[key].value + ';';
            }
            else if(filterListEvt[key].filter == 'Status'){
                newCaseStatus.push(filterListEvt[key].value);
                caseStatus+= filterListEvt[key].value + ';';
            }
        }
        if(event.getParam("isFilterRemoved")){
            helper.setFilterSearch(component,true,filterListEvt);
       }

        caseType = caseType.substring(0, caseType.length-1);
        caseStatus = caseStatus.substring(0, caseStatus.length-1);
        component.set("v.exportCaseStatus",caseStatus);
        component.set("v.exportCaseType",caseType);
        component.set("v.selectedCaseStatus",JSON.stringify(newCaseStatus));
        component.set("v.selectedCaseType",JSON.stringify(newCaseType));
        helper.onCaseSortFilterHelper(component,component.get("v.selectedCaseStatus"),component.get("v.selectedCaseType"));
    }, 
    
    
    firstPage: function(component, event, helper) {
        component.set("v.pageNumber", 1);
    },
    prevPage: function(component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", parseInt(pageNumber)-1);
    },	
    nextPage: function(component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", parseInt(pageNumber)+1);
    },
    lastPage: function(component, event, helper) {
        component.set("v.pageNumber", component.get("v.maxPage"));
    },
    openCustomerCase : function (component, event, helper) {  
        component.set("v.mode", 'landingPage');
        component.set("v.productTypeCheckFlag",true);   
        component.set("v.productType","");         
        var caseRec = new Object();
        component.set("v.caseRecord",caseRec);
        component.set("v.caseCommentList",caseRec);
        helper.onCaseSortFilterHelper(component,component.get("v.selectedCaseStatus"),component.get("v.selectedCaseType"));
    },     
    openAirtimeCase : function (component, event, helper) {        
        component.set("v.mode", 'airtimeCase');
        component.set("v.productTypeCheckFlag",true);   
        component.set("v.productType","");         
        var caseRec = new Object();
        component.set("v.caseRecord",caseRec);
    },     
    openTechSupport : function (component, event, helper) {
        component.set("v.mode", 'techSupportCase');
        component.set("v.productTypeCheckFlag",true);   
        component.set("v.productType","");         
        var caseRec = new Object();
        component.set("v.caseRecord",caseRec);
    },    
    sortByField: function(component, event, helper) {      
        component.set("v.spinner", true);
        var itemName = event.target.id;
        var filter = component.get("v.filter");
        var sortDirection = component.get("v.sortAsc");
        if(sortDirection)
            component.set("v.sortAsc",false);
        else
            component.set("v.sortAsc",true);
        component.set("v.sortField",itemName);  
        helper.onCaseSortFilterHelper(component,component.get("v.selectedCaseStatus"),component.get("v.selectedCaseType"));
    },
    handleUploadFinished : function (component, event) {
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    },
    submitCaseComment : function (component, event, helper) {  
        var addCommentValue = component.find('addComment').get('v.value'); 
        if(!$A.util.isEmpty(addCommentValue) ){
            if(component.get("v.caseRecord.Status") == 'Closed' || component.get("v.caseRecord.Status") == 'Closed As Duplicate'){
                var r = confirm("Are you sure you would like to add a new comment to this 'Closed' case? By clicking 'Submit' your case will be re-opened with KVH Support.");
                if (r){
                    helper.submitCaseCommentHelper(component, addCommentValue,true); 
                }
            }
            else
                helper.submitCaseCommentHelper(component, addCommentValue,false); 
        }
        else{
            alert('Enter value in Comment');
        }
    },
    toggleCaseComment : function (component, event, helper) {
        if(component.get("v.hideCaseComment")){
            component.set("v.hideCaseComment", false);
            component.find('addComment').set('v.value','');
        }
        else
            component.set("v.hideCaseComment", true);
    },
    onCaseView : function (component, event, helper) { 
        var selectItem = event.target.id;  
        component.set("v.mode", 'viewCase');
        helper.getCaseCommentAccessHelper(component,selectItem, helper);
    },
    submitTechnicalCase : function (component, event, helper) {
        if(event.getParam("value"))
            helper.submitCaseHelper(component, event, helper);
    },   
    submitAirtimeCase : function (component, event, helper) {
        if(event.getParam("value"))
            helper.submitCaseHelper(component, event, helper);      
    },   
    onChangePageSize: function (component, event, helper) {
        var selectItem = component.find('pageSize').get('v.value');
        if(selectItem != ''){
            component.set("v.pageCount",selectItem); 
            component.set("v.pageNumber", "1");
            helper.renderPage(component);
        }
    },
    Exporttoexcel : function(component,event,helper){
        var exportCaseStatus = component.get("v.exportCaseStatus");
        var exportCaseType = component.get("v.exportCaseType");
        var urlstring = $A.get("$Label.c.myKVH_Community_Prefix")  + '/apex/myKVH_SupportCenterExportExcelVF?casestatus='+exportCaseStatus+'&caseType='+exportCaseType  ;
        window.open(urlstring,'_blank');
    },
    // ## function call on Click on the "Download As CSV" Button. 
    downloadCSV : function(component,event,helper){
        var stockData = component.get("v.allCases"); 
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        
    },
   
})