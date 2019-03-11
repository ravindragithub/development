({
    showhidesection : function(component, event, helper) {
        var iconname = component.get("v.iconname");
        if(iconname == "chevron-right"){
            component.set("v.iconname","chevron-down pad-1");
            component.set("v.hidesection","slds-is-expanded");
        }else{
            component.set("v.iconname","chevron-right");
            component.set("v.hidesection","slds-is-collapsed");
            
        }
    },
    doInit : function(component, event, helper) {
        var docnum = component.get("v.docNumber");
        console.log('docnum: ' + docnum);
        if(docnum == 1){
			component.set("v.iconname","chevron-down pad-1");
            component.set("v.hidesection","slds-is-expanded");            
        }
    }
})