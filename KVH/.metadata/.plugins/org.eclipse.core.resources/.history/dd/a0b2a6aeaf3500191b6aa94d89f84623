/**
 * Created by Jai Chaturvedi on 7/08/2017.
 */
({

    sendUpdatesToMap : function (component) {
        console.log("WhereToBuyPartnerController.js-sendUpdatesToMap");
        var event = $A.get("e.c:UpdateWhereToBuyMap");
        event.setParams({accountList : component.get("v.partners")});
        event.setParams({productId : component.get("v.productId")});
        event.setParams({searchOption : component.get("v.searchOption")});
        event.setParams({stateCountry : component.get("v.stateCountry")});
        event.fire();
    },
    
    showPartners : function (component,event) {
        console.log("WhereToBuyPartnerController.js-showPartners");
        var partners = event.getParam('partners');
        var productId = event.getParam('productId');
        component.set("v.productId",productId);
        var searchOption = event.getParam('searchOption');
        component.set("v.searchOption",searchOption);
        var stateCountry = event.getParam('stateCountry');
        component.set("v.stateCountry",stateCountry);
        var location = event.getParam('location');
        component.set("v.location",location);
        var partnerTypes = ['All Partners'];
        var partnerLength = 0;
        if (partners !== undefined){
            for (var i=0; i<partners.length; i++) {
                if (!(partnerTypes.indexOf(partners[i].accType) > -1)){
                    partnerTypes.push(partners[i].accType);
                }
                partnerLength = partnerLength + partners[i].distanceWrappers.length;
            }
        }
        component.set("v.partnerType",partnerTypes);
        if (partners !== undefined){
            component.set("v.partners",partners);
            component.set("v.originalPartners",partners);
            component.set("v.partnersNotEmpty",true);
            component.set("v.partnerTypeDistanceWrappersNotEmpty",true);
        }else{
            component.set("v.partnersNotEmpty",false);
            component.set("v.partnerTypeDistanceWrappersNotEmpty",false);
        }
        component.set("v.partnersLength",(partnerLength.toString()));
        component.set("v.initLoad", false);
    },

    filterPartners : function (component) {
        console.log("WhereToBuyPartnerController.js-filterPartners");
        var selectedType = component.get("v.selectedPartnerType");
        //console.log(selectedType);
        var partners = component.get("v.originalPartners");

        if(selectedType === 'All Partners'){
        	var partnerLength = 0;
            partners = component.get("v.originalPartners");
            if (partners !== undefined){
                for (var i=0; i<partners.length; i++) {
                    partnerLength = partnerLength + partners[i].distanceWrappers.length;
                }
            }
            component.set("v.partnersLength",(partnerLength.toString()));
            component.set("v.partners",component.get("v.originalPartners"));
        }else{
            var partnerLength = 0;
            for (var i=0; i<partners.length; i++) {
                if (partners[i].accType === selectedType){
                    partnerLength = partnerLength + partners[i].distanceWrappers.length;
                }
            }
            component.set("v.partnersLength",(partnerLength.toString()));
            var filtered = partners.filter(function(item) {
                //console.log(item.accType);
                return item.accType === selectedType;
            });
            component.set("v.partners",filtered);
        }
    }
})