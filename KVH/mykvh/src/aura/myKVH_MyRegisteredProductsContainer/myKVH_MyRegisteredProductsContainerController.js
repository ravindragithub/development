({
	initialize: function(component, event, helper) {  
		var width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);        
        var deviceHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);     
        var headerheight = 60;
        var footerheight = 90;
        if(width < 750){
             footerheight = 90;
        }
        var finalHeight = deviceHeight - headerheight - footerheight;
       // alert(finalHeight);
        component.set('v.finalHeight',finalHeight+'px');
        helper.initializeCompopnentHelper(component, event, helper);
    },
    handleLTEManager : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");	
        var hasKVHrole = component.get("v.hasKVHRole");
        if(hasKVHrole){
            urlEvent.setParams({
                "url": $A.get("$Label.c.LTE_manager_idp_URL") 
            });
        }  
        else{
            urlEvent.setParams({
                "url": '/ltemanagerpage'
            });
        }
        urlEvent.fire();
    },
    handleVSATManager : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");	
        var hasKVHrole = component.get("v.hasKVHRole");
        if(hasKVHrole){
            urlEvent.setParams({
                "url":  $A.get("$Label.c.mini_v_sat_idp_url") 
            });           
        }
        else{
            urlEvent.setParams({
                "url": '/mini-vsat-manager' 
            });
        }
        urlEvent.fire();
    },
    openhlepPopup : function(component, event, helper){
    	var modalBody;
        $A.createComponent("c:myKVH_MyRegisteredProductLetUsKnow", {  
            "UserObj" : component.get("v.UserObj"),
            "spinner" : component.getReference("v.spinner"),
            "caseRecordTypeName" : "SatTV",
            "toName" : "TVRO Support",
            "documentIds" : component.getReference("v.documentIds")            
        },
         function(content, status) {
             if (status === "SUCCESS") {
                 modalBody = content;                      
                 component.find('overlayLib').showCustomModal({
                     header: "My Product Information Request/Issue",
                     body: modalBody, 
                     showCloseButton: true,
                     cssClass: "mymodal",
                     closeCallback: function() {
                         var documentIds = component.get('v.documentIds');
                         if(documentIds.length > 0){
                             helper.deleteUnusedFiles(component, event, helper);
                         }
                        // alert('You closed the alert! '+documentIds.length);
                     }
                 })
             }                               
     	});
	},
    openAirtimeServicesCasePopup : function(component, event, helper){
    	var modalBody;
        $A.createComponent("c:myKVH_MyRegisteredProductLetUsKnow", { 
            "UserObj" : component.get("v.UserObj"),
            "spinner" : component.getReference("v.spinner"),
            "caseRecordTypeName" : "Airtime Service",
            "toName" : "Airtime Services",
            "documentIds" : component.getReference("v.documentIds")   
        },
         function(content, status) {
             if (status === "SUCCESS") {
                 modalBody = content;                      
                 component.find('overlayLib').showCustomModal({
                     header: "Airtime Services Support Case Request",
                     body: modalBody, 
                     showCloseButton: true,
                     cssClass: "mymodal",
                     closeCallback: function() {
                         //alert('You closed the alert! 2');
                         var documentIds = component.get('v.documentIds');
                         if(documentIds.length > 0){
                             helper.deleteUnusedFiles(component, event, helper);
                         }
                     }
                 })
             }                               
     	});
	},
    toggleAll : function(component, event, helper){
        var arrowIcon = component.get("v.arrowIcon");
        var cmpEvent = $A.get("e.c:mykvh_MyRegisteredProductCollapsAllEvent");	
		console.log(cmpEvent);
        if(arrowIcon == 'utility:chevrondown'){
            cmpEvent.setParams({"arrowicon" : "utility:chevronright" });
            component.set("v.arrowIcon","utility:chevronright");            
        }else{
            cmpEvent.setParams({"arrowicon" : "utility:chevrondown" });
            component.set("v.arrowIcon","utility:chevrondown");
        }
        cmpEvent.fire();        
    },
    arrowIconChange : function(component, event, helper){
        var arrowIcon = component.get("v.arrowIcon");
       
        if(arrowIcon == 'utility:chevrondown'){ 
            component.set("v.tooglebuttonlabel","Collapse All Sections");
        }else{  
            component.set("v.tooglebuttonlabel","Open All Sections");
        }
	},
    onBackHome : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    }
})