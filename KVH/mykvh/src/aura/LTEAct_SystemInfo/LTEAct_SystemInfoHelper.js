({
	handleUploadAction : function(component) {
        var allValid = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            //inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    }
})