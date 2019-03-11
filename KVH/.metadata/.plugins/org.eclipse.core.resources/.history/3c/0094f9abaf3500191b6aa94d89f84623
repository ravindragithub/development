({	
    handleUploadAction : function(component) {
        var allValid = component.find('LTEFieldInstaller').reduce(function (validSoFar, inputCmp) {
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },    
    resetFields : function(component) {
        var prdReg = component.get("v.simplePRDregistration");
        prdReg.Installer_Contact_Name__c = '';
        prdReg.Installer_City__c = '';
        prdReg.Installer_Zip_Code__c = '';
        prdReg.Installer_Address__c = '';
        prdReg.Installer_Country__c = 'United States';
        prdReg.Installer_State_Province_Territory__c = '';
        component.set("v.selectedCountry","United States")
        component.set("v.selectedState","");
        component.set("v.simplePRDregistration",prdReg);
    }
})