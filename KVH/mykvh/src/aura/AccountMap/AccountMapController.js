/**
 * Created by Jai Chaturvedi on 7/08/2017.
 */
({
    jsLoaded: function(component) {
       
        console.log("AccountMapController.js-jsLoaded");
        var map = L.map( 'map', {
            center: [20.0, 5.0],
            minZoom: 2,
            zoom: 2,
            zoomAnimation:false,
            zoomControl: true,
            fadeAnimation:true,
            markerZoomAnimation:true
        });
        map.zoomControl.setPosition('topright');
        L.tileLayer(
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'WhereToBuy @ KVH Industries'
            }).addTo(map);
        component.set("v.map", map);
    },

    accountsLoaded: function(component, event, helper) {
        console.log("AccountMapController.js-accountsLoaded");
        var partners = event.getParam("accountList");
        var productId = event.getParam("productId");
        var searchOption = event.getParam("searchOption");
        var stateCountry = event.getParam("stateCountry");
        component.set("v.partners", partners);
        component.set("v.productId", productId);
        component.set("v.searchOption", searchOption);
        component.set("v.stateCountry", stateCountry);
        helper.createMap(component,event,helper);
        //console.log(accounts);
        // Add markers

    },

    accountSelected: function(component, event, helper) {
        console.log("AccountMapController.js-accountSelected");
        // Center the map on the account selected in the list

        helper.createMap(component,event,helper);
        var distanceWrapper = event.getParam("account");
        var accountRec = distanceWrapper.account;

        var map = component.get('v.map');
        map.panTo([accountRec.Latitude__c, accountRec.Longitude__c]);
	
        var container = $('<div />');
        container.on('hover', '.smallPolygonLink', function() {
            helper.getDirection(component,accountRec.Latitude__c, accountRec.Longitude__c);
        });

        container.html(helper.createPopBody(component,accountRec, distanceWrapper.accountId, distanceWrapper.CSN));
        var popup = L.popup()
            .setLatLng([accountRec.Latitude__c, accountRec.Longitude__c])
            .setContent(container[0]).addTo(map);;
        component.set("v.map", map);
    }

})