({
    doInit : function(component, event, helper) {
        var filterResultRow = component.get("v.filterResult");
        filterResultRow.push({ label: 'Open', 
                              value: 'Open',filter: 'Status'});  
        component.set("v.filterResult",filterResultRow);  
    },
    toggelDown : function(component, event, helper) {
        var selectItem = event.getSource().get("v.ariaDescribedBy");
        var filterObj = component.get("v.filterList");
        for(var key in filterObj){
            if( filterObj[key].label ==  selectItem)
                filterObj[key].active = false;
        }
        component.set("v.filterList",filterObj);	
    },
    toggelUp : function(component, event, helper) {
        var selectItem = event.getSource().get("v.ariaDescribedBy");
        var filterObj = component.get("v.filterList");
        for(var key in filterObj){
            if( filterObj[key].label ==  selectItem)
                filterObj[key].active = true;
            else
                filterObj[key].active = false;
        }
        component.set("v.filterList",filterObj);
    },
    selectFilter : function(component, event, helper) {  
        var indexParent = event.getSource().get("v.ariaLabelledBy");
        var indexChild = event.getSource().get("v.ariaDescribedBy");
        var filterParentRow = component.get("v.filterList")[indexParent];
        var filterChildRow = filterParentRow.valueLst[indexChild];
        var filterResultRow = component.get("v.filterResult");
        var finalTypeList;
        var finalStatusList;
        var booleanCheck = false;
        var count = 0,index = 0;
        if(filterResultRow.length == 0){
            filterResultRow.push({ label: filterChildRow.label, 
                                  value: filterChildRow.value,filter: filterParentRow.label}); 
            if(filterParentRow.label == 'Status')
                finalStatuslist = filterChildRow.value;
            else
                finalTypeList = filterChildRow.value;
        }
        else{
            for(var key in filterResultRow){  
                if(filterResultRow[key].label == filterChildRow.label &&
                   filterResultRow[key].value  == filterChildRow.value){
                    booleanCheck = true;                    
                    index = count;
                }		
                count++;
            }    
        }        
		if(!booleanCheck && filterChildRow.selected)
		filterResultRow.push({ label: filterChildRow.label, 
                            value: filterChildRow.value,filter: filterParentRow.label}); 
        else if(booleanCheck && !filterChildRow.selected){
            filterResultRow.splice(index,1);
        }	
        component.set("v.filterResult",filterResultRow);
        var cmpEvent = component.getEvent("cmpEvent"); 
        cmpEvent.setParams({filterListEvt : filterResultRow,
                            isFilterRemoved : false}); 
        cmpEvent.fire(); 
    },
})