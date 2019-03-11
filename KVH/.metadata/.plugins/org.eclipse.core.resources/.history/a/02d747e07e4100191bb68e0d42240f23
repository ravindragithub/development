/**
 * Created by Jai Chaturvedi on 8/08/2017.
 */
({
    focusAccountOnMap : function (component) {
        var appEvent = $A.get("e.c:FocusAccountOnMap");
        appEvent.setParams({account : component.get("v.partner")});
        appEvent.fire();
    },
    
    doInit : function (component,event,helper) {
        helper.buildQuotePageurl(component);
        console.log('PartnerAccountController - doInit');
        var partner = component.get("v.partner");
        var street = '';
        if (partner !== undefined){
            if (partner.account !== undefined){
                if (partner.account.ShippingAddress !== undefined && partner.account.ShippingAddress.street){
                    street = partner.account.ShippingAddress.street;
                    component.set("v.shippingStreet", street);
                    component.set("v.shippingStreetSet", true);
                }else if (partner.account.ShippingStreet){
                    street = partner.account.ShippingStreet;
                    component.set("v.shippingStreet", street);
                    component.set("v.shippingStreetSet", true);
                    var contact = ''
                    if (partner.account.Partner_Portal_Main_Contact__r !== undefined && partner.account.Partner_Portal_Main_Contact__r.Name){
                        contact = partner.account.Partner_Portal_Main_Contact__r.Name;
                        component.set("v.contact", contact);
                        component.set("v.contactSet", true);
                    }else{
                        component.set("v.contact", '');
                        component.set("v.contactSet", false);
                    }
                }else{
                    console.log('street');
                    console.log(partner.account.ShippingStreet);
                    console.log(partner.account.ShippingAddress.street);
                    component.set("v.shippingStreet", '');
                    component.set("v.shippingStreetSet", false);
                }
                var city = '';
                if (partner.account.ShippingAddress !== undefined && partner.account.ShippingAddress.city){
                    city = partner.account.ShippingAddress.city;
                }else if (partner.account.ShippingCity){
                    city = partner.account.ShippingCity;
                }else{
                    console.log('city');
                    console.log(partner.account.ShippingCity);
                    console.log(partner.account.ShippingAddress.city);
                }
                var state = '';
                if (partner.account.ShippingAddress !== undefined && partner.account.ShippingAddress.state){
                    state = partner.account.ShippingAddress.state;
                }else if (partner.account.ShippingState){
                    state = partner.account.ShippingState;
                }else{
                    console.log('state');
                    console.log(partner.account.ShippingState);
                    console.log(partner.account.ShippingAddress.state);
                }
                var zip = '';
                if (partner.account.ShippingAddress !== undefined && partner.account.ShippingAddress.postalCode){
                    zip = partner.account.ShippingAddress.postalCode;
                }else if (partner.account.ShippingPostalCode){
                    zip = partner.account.ShippingPostalCode;
                }else{
                    console.log('postalcode');
                    console.log(partner.account.ShippingPostalCode);
                    console.log(partner.account.ShippingAddress.postalCode);
                }
                if (city && state && zip){
                    component.set("v.shippingCityStateZip", city + ", " + state + " " + zip);
                    component.set("v.shippingCityStateZipSet", true);
                }else if (city && state){
                    component.set("v.shippingCityStateZip", city + ", " + state);
                    component.set("v.shippingCityStateZipSet", true);
                }else if (city && zip){
                    component.set("v.shippingCityStateZip", city + ", " + zip);
                    component.set("v.shippingCityStateZipSet", true);
                }else if (state && zip){
                    component.set("v.shippingCityStateZip", state + " " + zip);
                    component.set("v.shippingCityStateZipSet", true);
                }else if (city){
                    component.set("v.shippingCityStateZip", city );
                    component.set("v.shippingCityStateZipSet", true);
                }else if (zip){
                    component.set("v.shippingCityStateZip", zip);
                    component.set("v.shippingCityStateZipSet", true);
                }else if (state){
                    component.set("v.shippingCityStateZip", state);
                    component.set("v.shippingCityStateZipSet", true);
                }else{
                    component.set("v.shippingCityStateZip", '');
                    component.set("v.shippingCityStateZipSet", false);
                }
                var country = '';
                if (partner.account.ShippingAddress !== undefined && partner.account.ShippingAddress.country){
                    country = partner.account.ShippingAddress.country;
                    component.set("v.shippingCountry", country);
                    component.set("v.shippingCountrySet", true);
                }else if (partner.account.ShippingCountry){
                    country = partner.account.ShippingCountry;
                    component.set("v.shippingCountry", country);
                    component.set("v.shippingCountrySet", true);
                }else{
                    console.log('postalcode');
                    console.log(partner.account.ShippingAddress.country);
                    console.log(partner.account.shippingCountry);
                    component.set("v.shippingCountry", '');
                    component.set("v.shippingCountrySet", false);
                }
            }
        }
    },
    
})