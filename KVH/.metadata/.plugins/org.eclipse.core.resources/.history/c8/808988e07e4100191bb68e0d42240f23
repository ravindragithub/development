({
    handlePlaceAvailableServiceEvent: function(component, event, helper) {
        console.log('in handlePlaceAvailableServiceEvent');
        console.log(event);
        var serviceNameTemp = event.getParam("serviceName");
        var serviceAvailableTemp = event.getParam("serviceAvailable");
       // console.log(serviceNameTemp,serviceAvailableTemp);
        if (component.get("v.serviceName") === serviceNameTemp) {
            if (serviceAvailableTemp === true) {
                component.set("v.availableCheck", 'slds-show');
                var emptyArray = [];
                component.set("v.allnewslist",emptyArray);
                component.set("v.toptwonewslist",emptyArray);
                helper.getNewslist(component, event, helper);
            } else {
                component.set("v.availableCheck", 'slds-hide');
            }
        }
    },
    
    openpopup: function(component, event, helper) {
        console.log(component);
        component.set("v.showpopup", 'slds-show');       
    },
    closepopup: function(component, event, helper) {
        console.log(component);
        component.set("v.showpopup", 'slds-hide');       
    },
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
    openNews : function (component, event, helper) {
        var downloadurl = event.currentTarget.dataset.downloadurl;
        if(downloadurl != undefined && downloadurl != ''){
            //var flag  = confirm("Are you sure you want to download a document?");
            //if(flag == true){
            	window.open(downloadurl,"_blank");
        	//}
        }else{
           //console.log(event.currentTarget.dataset.releaseid); 
            var releaseid = event.currentTarget.dataset.releaseid;
            /*var compEvent = component.getEvent("ShowNewsDetailEvent");
            console.log(compEvent);
            compEvent.setParams({"releaseid" : releaseid });
			compEvent.fire();*/
            
            var pagelink = "./portalnewsdetail?releaseid="+releaseid;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                url: pagelink,
                isredirect: true
            });
            urlEvent.fire();           
        }
        
        
       
    }
})