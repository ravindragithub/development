({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();    
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();
        component.set('v.isUsernamePasswordEnabled', helper.getIsUsernamePasswordEnabled(component, event, helper));
        component.set("v.isSelfRegistrationEnabled", helper.getIsSelfRegistrationEnabled(component, event, helper));
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        component.set("v.communitySelfRegisterUrl", helper.getCommunitySelfRegisterUrl(component, event, helper));
       /* var deviceHeight = window.screen.availHeight;  
        var width = window.screen.availWidth;
        var headerheight = 60;
        var footerheight = 104;
        if(width > 1400 ){
            footerheight = 104;       
            var finalHeight = deviceHeight - headerheight - footerheight;
            component.set("v.maxheight",finalHeight); 
        }*/
        var width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);        
        var deviceHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);     
        var headerheight = 60;
        var footerheight = 90;
        if(width < 750){
             footerheight = 90;
        }
        var finalHeight = deviceHeight - headerheight - footerheight;
        component.set("v.maxheight",finalHeight);
        helper.getUrlParameter(component, event, helper);
    },    
    handleLogin: function (component, event, helpler) {
        component.set("v.spinner", true);
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        if(username != '' && password != '')             
            helpler.validProfileHelper(component, event, helpler);
        else{
            component.set("v.errorMessage",'Email/Password is required');
            component.set("v.showError",true);
            component.set("v.spinner", false);
        }
    },
    
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
    
    onKeyUp: function(component, event, helper){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {           
           // helpler.handleLogin(component, event, helpler);
           helper.validProfileHelper(component, event,helper);
        }
    },
    
    navigateToForgotPassword: function(cmp, event, helper) {
        var forgotPwdUrl = cmp.get("v.communityForgotPasswordUrl");
        if ($A.util.isUndefinedOrNull(forgotPwdUrl)) {
            forgotPwdUrl = cmp.get("v.forgotPasswordUrl");
        }
        var attributes = { url: forgotPwdUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },
    
    navigateToSelfRegister: function(cmp, event, helper) {
        var selrRegUrl = cmp.get("v.communitySelfRegisterUrl");
        if (selrRegUrl == null) {
            selrRegUrl = cmp.get("v.selfRegisterUrl");
        }
        
        var attributes = { url: selrRegUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    } 
})