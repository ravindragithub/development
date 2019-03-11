({
	handleInsert : function(component, event, helper) {
		console.log("Preparing to create I2CM Assets...");
    //Validate all inputs...

    //validate systemSerialNumber TODO: 9 digits?
    var systemSnValid = true;
    var systemSerialNumber_cmp = component.find("systemSerialNumber");
    var inputString = systemSerialNumber_cmp.get("v.value");
    if ($A.util.isEmpty(inputString)){
      systemSnValid = false;
      systemSerialNumber_cmp.set("v.errors", [{message:"I2CM Serial Number can't be blank"}]);
    } else {
      systemSerialNumber_cmp.set("v.errors", null);
    }
    //validate satRouter
    var satRouterValid = true;
    var satRouterCmp = component.find("satRouter");
    var satRouterValue = satRouterCmp.get("v.value");
    if ($A.util.isEmpty(satRouterValue)){
      satRouterValid = false;
      satRouterCmp.set("v.errors", [{message:"iDirect PCB Serial Number can't be blank"}]);
    } else {
      satRouterCmp.set("v.errors", null);
    }
    //validate adminIP  TODO: regex IP?
    var adminIpValid = true;
    var adminIpCmp = component.find("adminIP");
    var adminIpValue = adminIpCmp.get("v.value");
    if ($A.util.isEmpty(adminIpValue)){
      adminIpValid = false;
      adminIpCmp.set("v.errors", [{message:"Admin IP can't be blank"}]);
    } else {
      adminIpCmp.set("v.errors", null);
    }
    //validate swSerialNumber TODO: check for internal "U" with regex
    var swSerialValid = true;
    var swSerialCmp = component.find("swSerialNumber");
    var swSerialValue = swSerialCmp.get("v.value");
    if ($A.util.isEmpty(swSerialValue)){
      swSerialValid = false;
      swSerialCmp.set("v.errors", [{message:"CommBox License Number can't be blank"}]);
    } else {
      swSerialCmp.set("v.errors", null);
    }
    //validate MTA MAC TODO: regex characters, length and hex?
    var mtaMacValid = true;
    var mtaMacCmp = component.find("MTAMAC");
    var mtaMacValue = mtaMacCmp.get("v.value");
    if ($A.util.isEmpty(mtaMacValue)){
      mtaMacValid = false;
      mtaMacCmp.set("v.errors", [{message:"MTA MAC can't be blank"}]);
    } else {
      mtaMacCmp.set("v.errors", null);
    }
    //verify all inputs valid...
    if (mtaMacValid && swSerialValid && adminIpValid && satRouterValid && systemSnValid){
      //all inputs valid! invoke helper function
      console.log("All Inputs Valid!!");
      helper.createAssets(component, event, helper);
    }
	}, 
  handleAppEvent : function(component, event, helper){
    console.log("Create Assets Component Handling Application Event: " +event.getParam("appState"));
    component.set("v.systemSerialNumber", event.getParam("searchString"));  //systemSerialNumber is kind of "hands off".... it defaults to the Search string
    component.set("v.adminIP", event.getParam("adminIP"));
    component.set("v.swSerialNumber", event.getParam("swSerialNumber"));
    component.set("v.MTAMAC", event.getParam("MTAMAC"));
    component.set("v.satRouter", event.getParam("satRouter"));
  },
  stripLeadingZero : function(component, event, helper){
    var serNum = component.get("v.satRouter").replace(/^[0]+/g,"");
    console.log(serNum);
    component.set("v.satRouter", serNum);
  }
})