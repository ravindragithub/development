({
    handleCheckFlag: function(component, event, helper) {
        //console.log('==handleCheckFlag==' + event.getParam("value"));
        if(
            !component.get("v.serviceRequired") &&
            !component.get("v.purchaseRequired") &&
            !component.get("v.tvSeries")
        ){
            component.set("v.systemRequired",false); 
        }
        else if(
            !component.get("v.serviceRequired") &&
            !component.get("v.purchaseRequired") &&
            component.get("v.tvSeries")
        ){
            if(component.get("v.recieverInfoRequired")){
                component.set("v.systemRequired",false);                
            } 
            else if(!component.get("v.recieverInfoRequired")){   
                if(
                    !component.get("v.payInfoRequired") &&
                    !component.get("v.cont1Required")
                ){
                    component.set("v.systemRequired",false);  
                }
                else{
                    component.set("v.systemRequired",true);
                }
            } 
            else{
                component.set("v.systemRequired",true); 
            }
        }
            else{
                component.set("v.systemRequired",true); 
            }
        
    },
})