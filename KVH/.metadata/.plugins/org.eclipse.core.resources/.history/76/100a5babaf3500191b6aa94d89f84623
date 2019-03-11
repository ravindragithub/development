({
  helpGenerateURL : function(component){
    console.log("helpGenerateURL Invoked!");
    var assets = component.get("v.lteDevices.lteAssets");
    var arrayLength = assets.length;
    //Need a map (Object) like {Part Number : Serial Number,...}
    var assetMap = {};
    for (var i=0; i < arrayLength; i++){
      if(assets[i].Asset_ID__c != null){
        var productCodePosition = assets[i].Asset_ID__c.search("_US_");
        //console.log(productCodePosition);
        assetMap[assets[i].Asset_ID__c.slice(0,productCodePosition)] = assets[i].Name
      }
    }
    //default SSID = "LTE1-" + {middle four of device ns}
    console.log(assetMap);
    var deviceSN = assetMap["19-1027"];
    var domeSN = assetMap["02-2280"];
    console.log("device: " + deviceSN + " dome: " + domeSN);
    if(domeSN === undefined || deviceSN === undefined){
      console.log("Inhibiting Link!");
      component.set("v.enableLink", false);
    }
    var qParams = "?qr_ver=1.0&url=https://www.kvh.com/LTEactivate&sn=" + domeSN +"&device=" + deviceSN;
    var buildURL = component.get("v.qrLabel") + qParams;
    component.set("v.qrLabel", buildURL);
    console.log(buildURL);
  }
})