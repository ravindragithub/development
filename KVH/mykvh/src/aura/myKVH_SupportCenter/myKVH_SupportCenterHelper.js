({
    getCaseshelper : function(component) {
        var action = component.get("c.doIntialize");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();           
                component.set("v.allCases",records.lstOfCases);
                component.set("v.recordTypes",records.CaseRecordTypeList);
                var selectedList;
                this.setFilterSearch(component,false,selectedList);   
                this.getWebProductServiceType(component, records.webProductServiceTypeList);            
                this.renderPage(component);
            }                
            else if (state === "ERROR") 
                this.errorHelper(component,response.getError());
                else if (status === "INCOMPLETE") 
                    alert('No response from server or client is offline.');
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    setFilterSearch : function(component, isFilterRemoved,selectedLst) { 
        var listRT = component.get("v.recordTypes");
        var filterSearch = [];
        var listOfkeys = ['Status','Type'];
        var selectedTypes = [];
        var selectedStatuses =[];
        if(selectedLst && isFilterRemoved){    
            for(var key in selectedLst){
                if(selectedLst[key].filter == 'Status')
                    selectedStatuses.push(selectedLst[key].value);
                else
                    selectedTypes.push(selectedLst[key].value);
                }
        }   
        for (var i = 0; i < listOfkeys.length; i++) {
            var directParentlist = [];
            var directChildlist = [];
            if(listOfkeys[i] == 'Status' ){
                var openCheck = (selectedStatuses && isFilterRemoved && selectedStatuses.includes("Open")) ? true : false;
                var closeCheck = (selectedStatuses && isFilterRemoved && selectedStatuses.includes("Closed")) ? true : false; 
                directChildlist.push({ label: "Closed", value: "Closed",selected : closeCheck});
                directChildlist.push({ label: "Open", value: "Open",selected : openCheck});
            }
            else if(listOfkeys[i] == 'Type' ){
                for(var key in listRT){  
                    var selectedCheck = (isFilterRemoved && selectedTypes && selectedTypes.includes(key)) ? true : false;                  
                    directChildlist.push({label: listRT[key], value: key,selected : selectedCheck});
                }
            }
            directParentlist = { label: listOfkeys[i],active: false,iconNameUp:"utility:chevronup",iconNameDown:"utility:chevrondown",valueLst : directChildlist};
            filterSearch.push(directParentlist);
        }        
        component.set("v.filterList",filterSearch);
    },
    checkFieldValidity : function(component, event, helper) { 
        var validForm = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return validForm;
    },
    getWebProductServiceType : function(component, lstWebProductServiceType) {        
        var opts=[];
        //opts.push({class: "optionClass",label: "--- None ---", value: "" });
        for(var i=0;i< lstWebProductServiceType.length;i++){
            opts.push({"class": "optionClass", label: lstWebProductServiceType[i], value: lstWebProductServiceType[i]});
        }
        component.set("v.productTypes", opts);  
    },        
    submitCaseCommentHelper : function(component, addCommentValue,reopen) { 
        component.set("v.spinner", true);	
        var action = component.get("c.CreateCaseComment");
        action.setParams({ addCommentVal : addCommentValue , aCase : component.get("v.caseRecord")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('state: '+ state);
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
                component.set("v.caseCommentList",result);  
                component.find('addComment').set('v.value','');
                component.set("v.hideCaseComment", false);
                component.set("v.spinner", false);
                //this.onCaseSortFilterHelper(component,component.get("v.selectedCaseStatus"),component.get("v.selectedCaseType"));
                this.handleShowInfo(component, "Success" ,"Your new case comment has successfully been created.");
                if(reopen){
                    component.set("v.caseRecord.Status", 'New Customer Comment');
                }
                
            }              
            else if (state === "ERROR") 
                this.errorHelper(component,response.getError());
                else if (status === "INCOMPLETE") 
                    alert('No response from server or client is offline.');
        });
        $A.enqueueAction(action);
    },    
    submitCaseHelper : function(component, event, helper) {
        console.log('==submitFinalCase==');
        component.set("v.spinner", true);
        var action = component.get("c.CreateCaseController");
        action.setParams({ aCase : component.get("v.caseRecord"),
                          valueSelected : component.get("v.productType"),
                          typeCase : component.get("v.mode")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('state: '+ state);
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                //console.log('response: '+ JSON.stringify(response.getReturnValue()) );
                component.set("v.mode", 'viewCase');
                component.set("v.caseCommentAccess", true);
                component.set("v.saveValid", false);
                component.set("v.saveAirtimeValid", false);
                component.set("v.caseRecord", response.getReturnValue());
                this.handleShowInfo(component, "Success" ,"Your new case has successfully been created.");
            }    
            else if (state === "ERROR") 
                this.errorHelper(component,response.getError());
                else if (status === "INCOMPLETE") 
                    alert('No response from server or client is offline.');  
        });
        $A.enqueueAction(action);
    },          
    getCaseCommentAccessHelper : function(component, selectItem, helper) {
        component.set("v.spinner", true);
        var action = component.get("c.caseCommentAccessMethod");
        action.setParams({ casesId : selectItem});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.caseRecord",result.caseData );
                component.set("v.caseCommentAccess",result.caseAccess);   
                component.set("v.caseCommentList",result.caseCommentList);    
            }            
            else if (state === "ERROR") 
                this.errorHelper(component,response.getError());
                else if (status === "INCOMPLETE") 
                    alert('No response from server or client is offline.');    
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },    
    onCaseSortFilterHelper : function (component,  newSelectedStatus,newSelectedType) {
        component.set("v.spinner", true); 
        var action = component.get("c.getCaseRecords");
        action.setParams({ selectedStatus  : newSelectedStatus,
                          selectedType  : newSelectedType,
                          sortField : component.get("v.sortField"),
                          sortDirection : component.get("v.sortAsc")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('state: '+ state);
            if (state === "SUCCESS") {  
                var records = response.getReturnValue();
                console.log(records.length);
                component.set("v.allCases",records);
                component.set("v.pageNumber", 1); 
                component.set("v.spinner", false);
                this.renderPage(component);
            }            
            else if (state === "ERROR") 
                this.errorHelper(component,response.getError());
                else if (status === "INCOMPLETE") 
                    alert('No response from server or client is offline.');
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },    
    handleShowError : function(component,text) {     
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : 'Error', 
            "type": "error",
            "mode": 'sticky',
            'message' : text
        }); 
        showToast.fire(); 
    },   
    handleShowInfo : function(component,title,text) {     
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            title : 'Success',
            duration:'5000',
            type: 'info',
            mode: 'dismissible',
            message: text
        }); 
        showToast.fire(); 
    },  
    errorHelper : function(component,errors) {
        var sMsg = 'System error: Please contact Airtime Services for assistance. \n';
        sMsg += 'KVH Airtime Services \n Hours: 6:00 PM Sunday to 5:00 PM Friday (ET) \n Phone: +1 401.851.3862 \n Email: airtimeservices@kvh.com';
        this.handleShowError(component,sMsg);  
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
            }
        } else {
            console.log("Unknown error");
        }
    },
    renderPage: function(component) {        
        var records = component.get("v.allCases"),
            pageCount = component.get("v.pageCount"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber-1)*pageCount, pageNumber*pageCount);
        component.set("v.currentList", pageRecords);
        component.set("v.maxPage", Math.ceil(records.length/pageCount));
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['CaseNumber','RecordType','Subject','Platform_Name__c','Product_Group__c','Asset_Name__c','CreatedDate','Status' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey]; 
                // add , [comma] after every String value,. [except first]
                if(counter > 0)
                    csvStringResult += columnDivider;
                if(objectRecords[i][skey] != undefined){
                    if(skey != 'RecordType')
                        csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                    else
                        csvStringResult += '"'+ objectRecords[i][skey].Name+'"'; 
                }
                else
                    csvStringResult += '"'+ ' ' +'"'; 
                counter++;                
            } 
            csvStringResult += lineDivider;
        }        
        console.log(csvStringResult);
        return csvStringResult;        
    },
})