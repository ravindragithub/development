({
    initialize: function(component, event, helper) {    
        component.set("v.spinner", true);
        var width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        if(width<1021){
            component.set('v.showPopoverMob',true);
        }else{
            component.set('v.showPopover',true);
        }
        var profUrl = $A.get('$Resource.BGmyKVHCustomerPortalHeader');
        component.set("v.profUrl",profUrl);
        helper.getCurrentUser(component, event, helper);
    },
    handleVSATManager : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");	
        var hasKVHrole = component.get("v.hasMyKVHrole");
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
    navProductsVideos : function(component, event, helper) {
        var urlLink = $A.get("$Label.c.ProductVideo_Link");
        window.open(urlLink,"_self");
    },
    handleLTEManager : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");	
        var hasKVHrole = component.get("v.hasMyKVHrole");
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
    navigateSpecialOffer : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");	
        urlEvent.setParams({
            "url": 'https://www.kvh.com/Pages/Promotions.aspx'
        });
        urlEvent.fire();
    },
    navSCAction : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/mykvh-support-landing"
        });
        urlEvent.fire();
    },
    navminiVSATBroadband : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://www.kvh.com/Pages/miniVSAT-Broadband/miniVSAT-Broadband-Airtime-Service/mini-VSAT-Activation-Process.aspx'
        });
        urlEvent.fire();
    },
    navInmarsat : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://www.kvh.com/Pages/Inmarsat-Airtime/Inmarsat-Airtime-Activations.aspx'
        });
        urlEvent.fire();
    },
    navLTEActivation : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/lte-activate-form'
        });
        urlEvent.fire();
    },    
    navProductReg : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/product-registration'
        });
        urlEvent.fire();
    },
    navigateConverageMap : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://www.kvh.com/footprints"
        });
        urlEvent.fire();
    },
    handleProductResource : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://www.kvh.com/Support/Product-Support-Library.aspx"
        });
        urlEvent.fire();
    },
    handleProductHelpSystem : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://www.kvh.com/Support/Product-Support-Library/Product-Help.aspx"
        });
        urlEvent.fire();
    },
    handleShowPopover: function(component, event, helper) {
        
    },
    closePopover: function(component, event, helper) {
        component.set('v.showPopover',false);
        component.set('v.showPopoverMob',false);
    },
    goMyProducts : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/my-registered-products'
        });
        urlEvent.fire();
    }
})