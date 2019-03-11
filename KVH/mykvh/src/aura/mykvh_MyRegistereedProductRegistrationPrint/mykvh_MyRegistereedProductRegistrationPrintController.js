({
	init : function(component, event, helper) {
        var productRegId;
        if(component.get("v.autoPrint")){
            component.set("v.smallDeviceSize","6");
            var params = window.location.href.split("?");                  
            if(params != undefined){
                if(params.length > 1){
                    for(var i = 1;i < params.length;i++){
                        var paramlist = params[i].split('&');                        
                        if(paramlist != undefined && paramlist.length > 0){
                            for(var j=0;j<paramlist.length;j++){
                                var param = paramlist[j].split("=");
                                console.log(param);
                                if(param.length == 2){
                                    if(param[0] == 'prodregId'){
                                        productRegId = param[1];                               
                                    }
                                }  
                            }                        
                        }                    
                    }
                }
            } 
        }else{
            productRegId = component.get("v.productRegId");
        }
		//alert(productRegId);
        var action = component.get("c.fetechProductRegistratoinDetails");  
        action.setParams({ prodRegId :  productRegId});
 
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 component.set("v.prodregistrationObj",response.getReturnValue());
                  window.setTimeout(
                    $A.getCallback(function() {
                        if(component.get("v.autoPrint")){
                             window.print();
                             window.close();
                         }
                    }), 200
                );
                
               //  component.set("v.spinner", false);                 
             }else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message in initialize: " +
                                     errors[0].message);
                         window.alert("Error message in initialize: " +
                                      errors[0].message);
                     }
                     window.alert("Unknown error try search again");
                 } else {
                     console.log("Unknown error");
                     window.alert("Unknown error try search again");
                 }
                 component.set("v.spinner", false);
             }
         });
         $A.enqueueAction(action);
	}    
})