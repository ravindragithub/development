({
	processDiagResults : function(component, returnObj) {
    console.log("Processing returned diagnostics results....");
    var obj = returnObj;
    var processedList = [];
    var arraySize = obj.validationResults.length;
    for(var i = 0; i < arraySize; i++){
      if(obj.validationResults[i].substring(0,3) == "OK:"){
        processedList.push({class : "GREEN",
                            item : obj.validationResults[i]});
      } else if(obj.validationResults[i].substring(0,5) == "WARN:"){
        processedList.push({class : "YELLOW",
                            item : obj.validationResults[i]});
      } else if(obj.validationResults[i].substring(0,6) == "ERROR:"){
        processedList.push({class : "RED",
                            item : obj.validationResults[i]});
      }
    }
    component.set("v.diagResults", processedList);
	}
})