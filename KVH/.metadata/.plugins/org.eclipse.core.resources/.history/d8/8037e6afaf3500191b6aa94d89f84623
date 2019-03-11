({
    doInit: function(component, event, helper) {
        component.set("v.availableCheck", true);
        var emptyArray = [];
        component.set("v.allnewslist",emptyArray);
        component.set("v.toptwonewslist",emptyArray);
        helper.getNewslist(component, event, helper);
    },
    
    openpopup: function(component, event, helper) {
        component.set("v.showpopup", 'slds-show');       
    },
    closepopup: function(component, event, helper) {
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
            window.open(downloadurl,"_blank");
        }else{
            var releaseid = event.currentTarget.dataset.releaseid;
            var pagelink = "/mykvhnewsdetails?releaseid="+releaseid;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                url: pagelink,
                isredirect: true
            });
            urlEvent.fire();           
        }
    }
})