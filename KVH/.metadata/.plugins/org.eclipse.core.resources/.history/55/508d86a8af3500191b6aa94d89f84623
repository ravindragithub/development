({
	helpUpdatePicklists : function(component, plansList) {
    console.log("I am helper...");
    var priPlans = [];
    var secPlans = [];
    var arrayLength = plansList.length;
    for (var i = 0; i < arrayLength; i++) {
      if(plansList[i].Airtime_Rate_Plan_Type__c == "HTS High Speed"){
        priPlans.push(plansList[i]);
      } else if(plansList[i].Airtime_Rate_Plan_Type__c == "HTS Unlimited"){
        secPlans.push(plansList[i]);
      }
    }
    secPlans.sort(function(a,b) {return (a.Name > b.Name) ? 1 : ((b.Name > a.Name) ? -1 : 0);} );
    priPlans.sort(function(a,b) {return (a.Name > b.Name) ? 1 : ((b.Name > a.Name) ? -1 : 0);} );
    
    component.set("v.primaryPlans", priPlans);
    component.set("v.secondaryPlans", secPlans);
    console.log(component.get("v.primaryPlans"));
    console.log(component.get("v.secondaryPlans"));
  }
})