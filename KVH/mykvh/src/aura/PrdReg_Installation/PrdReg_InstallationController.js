({
	doInit: function(component, event, helper){
        var vesselTypeMap = component.get('v.vesselTypeMap');
        var platformTyps = [];
        for(var platfrmTyp in vesselTypeMap){
            platformTyps.push(platfrmTyp);
        }
        component.set("v.platformTyps", platformTyps);
        
        component.find('contrySelect').set('v.value','US');
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Installer_Country__c = 'United States';
        component.set('v.prodRegistration',prodRegistration);
        helper.getStateOpts(component,'US');
	},
    onChangePlatformType: function(component, event, helper){
        component.set("v.appOptions", []);
        component.set("v.appTypeOptions", []);
        var paltfrmTyp = event.getSource().get("v.label");
        var vesselTypeMap = component.get('v.vesselTypeMap');
        var appMap = vesselTypeMap[paltfrmTyp];
        var appOpts = [];
        for(var app in appMap){
            var appOpt = {};
            appOpt.label = app;
            appOpt.value = app;
            appOpts.push(appOpt);
        }
        component.set("v.appOptions", appOpts);
        
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Platform_Type__c = paltfrmTyp;
        prodRegistration.Application__c = '';
        prodRegistration.Application_Type__c = '';
        prodRegistration.RV_or_Vehicle_Make_Model__c = '';
        prodRegistration.Vessel_Name__c = '';
        prodRegistration.Other_Installation__c = '';
        component.set('v.prodRegistration',prodRegistration);
        
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
    onAppChange: function(component, event, helper){
        var app = event.getSource().get("v.value");
        var prodRegistration = component.get('v.prodRegistration');
        var paltfrmTyp = prodRegistration.Platform_Type__c;
        var vesselTypeMap = component.get('v.vesselTypeMap');
        var appMap = vesselTypeMap[paltfrmTyp];
        var appTyps = appMap[app];
        var apptypOpts = [];
        for(var i in appTyps){
            var appTypOpt = {};
            appTypOpt.label = appTyps[i];
            appTypOpt.value = appTyps[i];
            apptypOpts.push(appTypOpt);
        }
        component.set("v.appTypeOptions", apptypOpts);
        
        prodRegistration.Application_Type__c = '';
        prodRegistration.Other_Installation__c = '';
        component.set('v.prodRegistration',prodRegistration);
        
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
    onAppTypeChange: function(component, event, helper){
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Other_Installation__c = '';
        component.set('v.prodRegistration',prodRegistration);
        
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
    onIntalerInfoChange: function(component, event, helper){
        var instaInfo = event.getSource().get("v.label");
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Installer_Information__c = instaInfo;
        prodRegistration.Installer_Contact_Name__c = '';
        prodRegistration.Installer_City__c = '';
        prodRegistration.Installer_Zip_Code__c = '';
        prodRegistration.Installer_Address__c = '';
        component.find('contrySelect').set('v.value','US');
        prodRegistration.Installer_Country__c = 'United States';
        prodRegistration.Installer_State_Province_Territory__c = '';
        prodRegistration.Installer_Manufacture__c = '';
        if(instaInfo=='Prior Owner'){
            prodRegistration.Free_DirectTV_or_DISH_receiver_requested__c = '';
        }
        component.set('v.prodRegistration',prodRegistration);
        component.set('v.isInstaInfoPriorOwner',instaInfo);
        helper.getStateOpts(component,'US');
        
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
    onCountrySelect: function(component, event, helper){
        var countryOptions = component.get("v.countryOptions");
        var contryCode = component.find('contrySelect').get('v.value');
        var index = countryOptions.findIndex(item => item.value == contryCode);
        var contryName = index>=0 ? countryOptions[index].label : null;
        var prodRegistration = component.get('v.prodRegistration');
        prodRegistration.Installer_Country__c = contryName;
        prodRegistration.Installer_State_Province_Territory__c = '';
        component.set('v.prodRegistration',prodRegistration);
        helper.getStateOpts(component,contryCode);
        
        component.set('v.KVHAuthDealerAddres',true);
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
	onStateSelect: function(component, event, helper){
        component.set('v.KVHAuthDealerAddres',true);
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
	},
    onKVHAuthAddresChange: function(component, event, helper){
        component.set('v.KVHAuthDealerAddres',true);
        var validateField = component.get('c.validateField');
        $A.enqueueAction(validateField);
    },
    validateField: function(component, event, helper){
        component.set("v.installationRequired",true);
        var isError1 = false;
        var isError2 = false;
        var prodRegistration = component.get('v.prodRegistration');
        if(prodRegistration.Platform_Type__c!='' && prodRegistration.Application__c!='' && prodRegistration.Application_Type__c!=''){
            if((prodRegistration.Platform_Type__c=='Vehicle' && !$A.util.isEmpty(prodRegistration.RV_or_Vehicle_Make_Model__c)) || 
               (prodRegistration.Platform_Type__c=='Vessel' &&  !$A.util.isEmpty(prodRegistration.Vessel_Name__c))){
                isError1 = true;
            }
        }
        
        if(!$A.util.isEmpty(prodRegistration.Installer_Information__c)){
            if(prodRegistration.Installer_Information__c==='KVH Authorized Dealer/Distributor'){
                if(helper.validateAddress(component) && 
                   !$A.util.isEmpty(prodRegistration.Installer_Country__c)){
                    var stateOptions = component.get('v.stateOptions');
                    if((stateOptions.length>0 && !$A.util.isEmpty(prodRegistration.Installer_State_Province_Territory__c)) ||
                      (stateOptions.length==0 && $A.util.isEmpty(prodRegistration.Installer_State_Province_Territory__c))){
                        isError2 = true;
                        component.set('v.KVHAuthDealerAddres',false);
                    }
                }
            }else{
                isError2 = true;
            }    
        }
        if(isError1 && isError2){
            component.set("v.installationRequired",false);
        }
    }
})