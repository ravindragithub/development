({
    download : function (component,event,helper) {
        var TC = component.get("v.document.ct.Product_Document__r.Display_Terms_and_Conditions_Page__c");
        var embed = component.get("v.document.ct.Product_Document__r.Insertion_Code__c");
        var ht = component.get("v.document.ct.Product_Document__r.Display_HTML_Page__c");
        if(TC || ht || embed){
        window.open(
            $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/TCandHTML?id="+component.get("v.document.ct.Product_Document__c"),
            "", "width=700,height=500");
        } else{
            window.open( 
                $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/downloaddocument?id="+component.get("v.document.ct.Product_Document__c"),
            "", "width=700,height=500");
        }

    },
    showpopup : function (component,event,helper){
        var showpopupEvent = $A.get("e.c:showsalesAidspopup");  
        
        var docId = event.target.getAttribute('data-id');
        
        showpopupEvent.setParams({"docId" : docId});
        
        showpopupEvent.fire();
        console.log(showpopupEvent);
    }
    
})