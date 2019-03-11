({    
    handleUploadAction : function(component) {
        var allValid = true;
        allValid = component.find('LTEField').reduce(function (validSoFar, inputCmp) {
            //inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return(allValid);        
    },
    handleMMSIIValidation : function(component,inputField,fieldValue) {	
        var allValid = true;
        if(isNaN(fieldValue)){
            inputField.set("v.errors", [{message:"MMSI needs to be numeric characters."}]);           
            allValid = false;
        }        
        else if(fieldValue == '' || fieldValue.toString().length < 0 || fieldValue.toString().length > 9){
            inputField.set("v.errors", [{message:"MMSI needs to be nine characters long."}]);          
            allValid = false;
        }
        else
            inputField.set("v.errors", null); 
        return(allValid);
    },
    handleIMOValidation : function(component,inputField,fieldValue) {
        var allValid = true;
        if(isNaN(fieldValue) || fieldValue == '' || fieldValue.toString().length < 0 || fieldValue.toString().length > 7)
            allValid = false;
        else if(!this.IMOValidation(component,fieldValue.toString()))
            allValid = false;
        if(!allValid)
            inputField.set("v.errors", [{message:"Invalid IMO Registration Number."}]);   
        else
            inputField.set("v.errors", null); 
        return(allValid);
    },
    IMOValidation : function(component,imo){
        var result = false;
        var sum = 0;
        var checksum = "Unknown";
        var dispSums = "";
        var chars = imo.split("");
        if (imo.length == 7) {
            for (var i = 0; i < 6; i++) {
                var n = new Number(chars[i]);
                sum += n * (7 - i);
                dispSums += " + (" + chars[i] + "x" + (7 - i) + ")";
            }
            checksum = imo.charAt(6);
        }
        
        //console.log("Sum is " + dispSums.substr(3) + " = " + sum);
        //console.log("Checksum is " + checksum);
        if (checksum == (sum % 10)) 
            result = true;
        return(result);
    },
})