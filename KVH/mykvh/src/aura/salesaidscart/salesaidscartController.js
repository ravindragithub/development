({
	showSpinner : function (component, event, helper) {
       component.set("v.showspinner",true);
       //document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.remove('hideEl')
    },
    hideSpinner : function (component, event, helper) {
        component.set("v.showspinner",false);  
        //document.querySelector('.siteforceSpinnerManager.siteforcePanelsContainer').classList.add('hideEl')
    },
    removeclass : function (component, event, helper) {
        event.getSource().set("v.class","");        
    },
    addclass : function (component, event, helper) {
        console.log(event.getSource().get("v.value"));
        if(event.getSource().get("v.value") === undefined || event.getSource().get("v.value").trim() == ''){
            event.getSource().set("v.class","required"); 
        }   
    },
    placeOrder : function(component, event, helper) {
        var itemcount = component.get("v.cartObj.lineItems").length;
        if(itemcount > 0){
            //validate form
            var isError = false;
            console.log(component.find("companyname").get("v.value"),component.find("state").get("v.value"));
            if(component.find("companyname").get("v.value") === undefined || component.find("companyname").get("v.value").trim() == ''){
                isError = true;
                component.find("companyname").set("v.class","required");
            }
            
            if(component.find("contactname").get("v.value") === undefined || component.find("contactname").get("v.value").trim() == ''){
                isError = true;
                component.find("contactname").set("v.class","required");
            }
            
            if(component.find("email").get("v.value") === undefined || component.find("email").get("v.value").trim() == ''){
                isError = true;
                component.find("email").set("v.class","required");
            }
            
            if(component.find("address1").get("v.value") === undefined || component.find("address1").get("v.value").trim() == ''){
                isError = true;
                component.find("address1").set("v.class","required");
            }
            
            if(component.find("city").get("v.value") === undefined || component.find("city").get("v.value").trim() == ''){
                isError = true;
                component.find("city").set("v.class","required");
            }
            
            if(component.find("country").get("v.value") === undefined || component.find("country").get("v.value").trim() == ''){
                isError = true;
                component.find("country").set("v.class","required");
            }
            
            if(component.find("state").get("v.value") === undefined || component.find("state").get("v.value").trim() == ''){
                isError = true;
                component.find("state").set("v.class","required");
            }
            
            if(component.find("postalcode").get("v.value") === undefined || component.find("postalcode").get("v.value").trim() == ''){
                isError = true;
                component.find("postalcode").set("v.class","required");
            }
            
            if(component.find("phone").get("v.value") === undefined || component.find("phone").get("v.value").trim() == ''){
                isError = true;
                component.find("phone").set("v.class","required");
            }
           
            if(isError){
                component.set("v.validationMessage","<b>Error : </b><br/>Please fill required fields.");
            }else{
                component.set("v.validationMessage","");
                helper.submitOrder(component, event, helper);
            }	
        }
	},
    doInit  : function(component, event, helper) {
		helper.fetchCartInfo(component, event, helper);
        //store return url
        var params = window.location.href.split("?");
        var retURL;
        
        if(params.length > 1){
            for(var i = 1;i < params.length;i++){
                var paramlist = params[i].split('&');
                
                if(paramlist != undefined && paramlist.length > 0){
                    for(var j=0;j<paramlist.length;j++){
                        var param = paramlist[j].split("=");
                        console.log(param);
                        if(param.length == 2){
                            if(param[0] == 'returl' && param[1] != undefined && param[1].length > 2){
                                retURL = param[1];                               
                            }
                        }  
                    }
                    
                }
                
            }
        }
        
        if(retURL != undefined){            
            component.set("v.backbuttonurl",decodeURIComponent(retURL));            
        }else{
            //retURL = $A.get("$Label.c.OrgURL") + '/' + $A.get("$Label.c.Community_Prefix") + '/s/productresources?salesaids=true';
            retURL = './productresources?salesaids=true';
            component.set("v.backbuttonurl",decodeURIComponent(retURL));    
        }
        
        
	},
    removeItem : function(component, event, helper){
        var row = event.target.getAttribute('data-row');
        var cartObj = component.get("v.cartObj");
        var lineItems = cartObj.lineItems;
        var documentObj = lineItems[row];        
        
        helper.deleteLineItem(component, event, helper,documentObj.Id);
    },
    decreaseqty : function(component, event, helper) {        
		var row = event.target.getAttribute('data-row');
        var cartObj = component.get("v.cartObj");
        var lineItems = cartObj.lineItems;
        var documentObj = lineItems[row];
        console.log(documentObj);
        if(documentObj != undefined ){
            documentObj.Quantity__c = documentObj.Quantity__c - 1;  
            helper.updateLineItem(component, event, helper,documentObj);              
        }		
        //component.set("v.cartObj",cartObj);
	},
    
    updatequantity : function(component, event, helper) {       
        var newqty = event.target.value
        var row = event.target.getAttribute('data-row');
        var cartObj = component.get("v.cartObj");
        var lineItems = cartObj.lineItems;
        var documentObj = lineItems[row]; 
        if(newqty != undefined && newqty > 0){            
            documentObj.Quantity__c = newqty;
            helper.updateLineItem(component, event, helper,documentObj);    
        }else{
            event.target.value = documentObj.Quantity__c;
        }
       
        
    },
    increaseqty : function(component, event, helper) {
        var row = event.target.getAttribute('data-row');
        var cartObj = component.get("v.cartObj");
        var lineItems = cartObj.lineItems;
        var documentObj = lineItems[row];
        console.log(documentObj);
        if(documentObj != undefined){
            documentObj.Quantity__c = documentObj.Quantity__c + 1;          
        }		
        //component.set("v.cartObj",cartObj);
        helper.updateLineItem(component, event, helper,documentObj);
	},
    sameaspartnerchange : function(component, event, helper) {
        var cartObj = component.get("v.cartObj");
        var sameaspartner = component.get("v.sameaspartner");
        if(sameaspartner){
            cartObj.shippinginfo.companyName = cartObj.partnerInfo.companyName;
            cartObj.shippinginfo.contactName = cartObj.partnerInfo.contactName;
            cartObj.shippinginfo.email = cartObj.partnerInfo.email;
            cartObj.shippinginfo.address = cartObj.partnerInfo.address;
            cartObj.shippinginfo.city = cartObj.partnerInfo.city;
            cartObj.shippinginfo.country = cartObj.partnerInfo.country;
            cartObj.shippinginfo.state = cartObj.partnerInfo.state;
            cartObj.shippinginfo.zipcode = cartObj.partnerInfo.zipcode;
            cartObj.shippinginfo.phone = cartObj.partnerInfo.phone;
        }else{
            cartObj.shippinginfo.companyName = '';
            cartObj.shippinginfo.contactName = '';
            cartObj.shippinginfo.email = '';
            cartObj.shippinginfo.address = '';
            cartObj.shippinginfo.city = '';
            cartObj.shippinginfo.country = '';
            cartObj.shippinginfo.state = '';
            cartObj.shippinginfo.zipcode = '';
            cartObj.shippinginfo.phone = '';
        }
        component.set("v.cartObj",cartObj);            
    }
})