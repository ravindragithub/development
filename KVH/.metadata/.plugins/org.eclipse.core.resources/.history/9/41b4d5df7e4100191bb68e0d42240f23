({
	helpDoInit : function(component, event, helper) {
    console.log("helpDoInit Invoked!");

    component.set("v.state", "INIT");
    component.set("v.lteDevices", null);
    component.set("v.results", "Initializing complete");
    component.set("v.qrLabel", "/apex/QRLabel_LTE");

    var postComponent = component.find("post_cmp");
    postComponent.set("v.disablePOST", false);

    var spinnerDiv = component.find("spinner_div");
    var hierarchyDiv = component.find("hierarchy_div");
    var postDiv = component.find("post_div");
    var successDiv = component.find("success_div");
    var exceptionDiv = component.find("exception_div");

    $A.util.addClass(spinnerDiv, "hide");
    $A.util.addClass(postDiv, "hide");
    $A.util.addClass(successDiv, "hide");
    $A.util.addClass(exceptionDiv, "hide");
  },
  helpGenerateURL : function(component){
    console.log("helpGenerateURL Invoked!");
    var assets = component.get("v.lteDevices.lteAssets");
    var arrayLength = assets.length;
    //Need a map (Object) like {Part Number : Serial Number,...}
    var assetMap = {};
    for (var i=0; i < arrayLength; i++){
      var productCodePosition = assets[i].Asset_ID__c.search("_US_");
      //console.log(productCodePosition);
      assetMap[assets[i].Asset_ID__c.slice(0,productCodePosition)] = assets[i].Name
    }
    //default SSID = "LTE1-" + {middle four of device ns}
    console.log(assetMap);
    var deviceSN = assetMap["19-1027"];
    var domeSN = assetMap["02-2280"]
    var qParams = "?qr_ver=1.0&url=https://www.kvh.com/LTEactivate&sn=" + domeSN +"&device=" + deviceSN;
    var buildURL = component.get("v.qrLabel") + qParams;
    component.set("v.qrLabel", buildURL);
    console.log(buildURL);
  }
})