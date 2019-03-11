({
    doInit: function(component, event, helper){
        helper.callAction(
            component,
            'c.getIntiData',
            function(result){
                console.log(result);
                component.set('v.prodRegistration',result['prodRegistration']);
                component.set('v.attachmentList',result['attList']);
            }
        );
    },
    onBackHome: function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'
        });
        urlEvent.fire();
    },
    onSectionToggle: function(component, event){
        var openSection = event.getParam('openSections');
        if(openSection=='Installation'){
            component.set('v.installationRequired', true);
            var instIcon = component.find('installationRequiredIcon');
            $A.util.removeClass(instIcon, 'notStarted');
        }else if(openSection=='System'){
            component.set('v.systemRequired', true);
            var sysIcon = component.find('systemRequiredIcon');
            $A.util.removeClass(sysIcon, 'notStarted');
        }else if(openSection=='ProviderAccount'){
            component.set('v.providerAccRequired', true);
            var proAccIcon = component.find('providerAccRequiredIcon');
            $A.util.removeClass(proAccIcon, 'notStarted');
        }
    },
	myAction : function(component, event, helper) {
        helper.showSpinner(component);
        var quickaction = event.getParam("quickaction");
        helper.callServer(
            component,
            'c.buildToolKit',
            function(result) {
                console.log(result);
                component.set("v.quickLink", false);
                component.set("v.products", result.products);
                component.set("v.documents", result.documents);
                component.set("v.selectedQuickLink", quickaction);
                component.set("v.refining", true);
            },
            {
                toolKitName: quickaction
            },
            false
        );
	}
})