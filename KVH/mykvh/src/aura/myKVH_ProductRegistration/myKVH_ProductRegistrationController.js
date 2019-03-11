({
    doInit: function(component, event, helper){
        helper.callAction(
            component,
            'c.getIntiData',
            function(result){
                //console.log(result);
                component.set('v.prodRegistration',result['prodRegistration']);
                component.set('v.attachmentList',result['attList']);
                var device = $A.get("$Browser.formFactor");
                component.set("v.prodRegistration.Device__c", device);
                helper.getCountryOpts(component,result['countries']);
                component.set('v.countryStateMap',result['countryStateMap']);
                component.set('v.vesselTypeMap',result['vesselTypeMap']);
                component.set('v.productLineMap',result['productLineMap']);
                component.set('v.loadChild',true);
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
            var instIcon = component.find('installationRequiredIcon');
            if($A.util.hasClass(instIcon, "notStarted")){
                component.set('v.installationRequired', true);
                $A.util.removeClass(instIcon, 'notStarted');
            }
        }else if(openSection=='System'){
            var sysIcon = component.find('systemRequiredIcon');
            if($A.util.hasClass(sysIcon, "notStarted")){
                component.set('v.systemRequired', true);
                $A.util.removeClass(sysIcon, 'notStarted');
            }
        }else if(openSection=='ProviderAccount'){
            var proAccIcon = component.find('providerAccRequiredIcon');
            if($A.util.hasClass(proAccIcon, "notStarted")){
                component.set('v.providerAccRequired', true);
                $A.util.removeClass(proAccIcon, 'notStarted');
            }
        }
    },
    goToAccount: function(component, event, helper){
        component.find("accordion").set('v.activeSectionName', 'Account');
    },
    goToInstallation: function(component, event, helper){
        component.find("accordion").set('v.activeSectionName', 'Installation');
        //var xdiv = document.getElementById('scrollInstallation');
        //helper.setScroller(component,xdiv);
    },
    goToSystem: function(component, event, helper){
        component.find("accordion").set('v.activeSectionName', 'System');
    },
    goToProviderAccount: function(component, event, helper){
        component.find("accordion").set('v.activeSectionName', 'ProviderAccount');
    },
    goToAgreement: function(component, event, helper){
        component.find("accordion").set('v.activeSectionName', 'Agreement');
    },
    checkExistingProdReg: function(component, event, helper){
        if(helper.validateForm(component)){
            helper.callAction(
                component,
                'c.checkExistingProdRegistrations',
                function(result){
                    if(result=='yes'){
                        var modalBody;
                        $A.createComponent(
                            "c:PrdReg_DuplicateSerialNoMsg", 
                            {
                                onSubmit: component.getReference("c.onSubmit")
                            },
                            function(content, status) {
                                if (status === "SUCCESS") {
                                    modalBody = content;
                                    component.find('overlayLib').showCustomModal({
                                        header: "",
                                        body: modalBody, 
                                        showCloseButton: true,
                                        cssClass: "DuplicateSerialNoModal"
                                    })
                                }                               
                            });
                    }else{
                        var prodRegistration = component.get('v.prodRegistration');
                        prodRegistration.Status__c = 'Submitted';
                        component.set('v.prodRegistration',prodRegistration);
                        helper.saveProductRegistration(component, helper);
                    }
                },
                {
                    prdReg: component.get('v.prodRegistration')
                }
            );
        }else{
            component.set("v.submitFormOnce", false);
        }
    },
    onSubmit: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Status__c = 'Submitted';
        component.set('v.prodRegistration',prodRegistration);
        helper.saveProductRegistration(component, helper);
    }
})