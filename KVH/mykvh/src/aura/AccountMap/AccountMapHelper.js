({
    getDirection : function (component, lat,lang) {
        console.log("AccountMapHelper.js-getDirection");
        var geo_options = {
            enableHighAccuracy: true,
            maximumAge:0
        };
        //component.set("v.spinner",true);
        if ("geolocation" in navigator){
            //navigator.geolocation.getAccurateCurrentPosition(onSuccess, onError, { desiredAccuracy: 50, maxWait: 20000 });

            navigator.geolocation.getAccurateCurrentPosition($A.getCallback(function(position) {
                var map = component.get('v.map');
                if(map){
                    map.remove();
                    map = null;
                    map = L.map('map');
                    L.tileLayer(
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        {
                            attribution: 'WhereToBuy @ KVH Industries'
                        }).addTo(map);
                }
                L.Routing.control({
                    waypoints: [
                        L.latLng(position.coords.latitude, position.coords.longitude),
                        //L.latLng(33.5304299, -117.1790608),
                        L.latLng(lat, lang)
                    ],
                    routeWhileDragging: true,
                    showAlternatives:true,
                    altLineOptions: {
                        styles: [
                            {color: 'black', opacity: 0.15, weight: 9},
                            {color: 'white', opacity: 0.8, weight: 6},
                            {color: 'blue', opacity: 0.5, weight: 2}
                        ]
                    },
                    formatter: new L.Routing.Formatter({
                        units: 'imperial',
                        unitNames:{meters: 'mt',kilometers: 'km',yards: 'yd',miles: 'miles',hours: 'h',minutes: 'min',seconds: 's'}
                    }),
                    router: L.Routing.mapbox('pk.eyJ1IjoiamFpY2hhdHVydmVkaSIsImEiOiJjajZ4ODc2eXcyNTNkMzNsYXVlbWVhZ2dpIn0.vMinwv-cNd8xm1rMUdVTlQ'),
                }).addTo(map);
                component.set("v.map", map);
            }),function error(err) {
            },{ desiredAccuracy: 1, maxWait: 0 });
        }
        component.set("v.spinner",false);
    },

    createMap : function (component,event,helper) {
         document.getElementById('weathermap').innerHTML = '<div id="map" style="width:50%;" ></div>';
        component.set("v.mapwidth","width:50%");
        console.log("AccountMapHelper.js-createMap");
        var accounts =  component.get("v.partners");
        var map = component.get("v.map");
        if(map){
            map.remove();
            map = null;
        }
        if(accounts !== undefined && accounts.length>0){
            map = L.map('map', {
                zoomControl: true,
                zoomAnimation:false,
                fadeAnimation:true,
                markerZoomAnimation:true
            });
            map.zoomControl.setPosition('topright');

            L.tileLayer(
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                {
                    attribution: 'WhereToBuy @ KVH Industries'
                }).addTo(map);

            var account_length = accounts.length;
            var setViewLatLong;

            for (var i=0; i<account_length; i+=1) {
                var partners = accounts[i].distanceWrappers;
               console.log(partners);
                 for (var j=partners.length-1; j>=0; j-=1) {
                     var item = partners[j];
                      console.log(item);
              //  partners.forEach(function (item) {
                    var accountRec = item.account;
                    if(accountRec.Latitude__c && accountRec.Longitude__c){
                        if(account_length>1 && accountRec.Name.toLowerCase () != 'kvh industries' && setViewLatLong === undefined){
                            setViewLatLong = [accountRec.Latitude__c, accountRec.Longitude__c];
                        }else if(account_length>=1 && setViewLatLong === undefined){
                            setViewLatLong = [accountRec.Latitude__c, accountRec.Longitude__c];
                        }
                        
                        var latLng = [accountRec.Latitude__c, accountRec.Longitude__c];
                        var numberIcon = L.divIcon({
                            className: "number-icon",
                            iconSize: [40, 40],
                            html: '<strong>'+item.srnumber+'</strong>'
                        });
                        
                        var container = $('<div />');
                        container.on('click', '.smallPolygonLink', function() {
                            helper.getDirection(component,accountRec.Latitude__c, accountRec.Longitude__c);
                        });

                        container.html(helper.createPopBody(component,accountRec, item.accountId, item.CSN));
                        L.marker(latLng,{icon: numberIcon}).bindPopup(container[0]).addTo(map);
                        //L.marker(latLng,{icon: numberIcon}).bindPopup(strVar).addTo(map);
                    }
                 }
               // });
            }
            if (setViewLatLong === undefined){
                for (var i=0; i<account_length; i+=1) {
                    var partners = accounts[i].distanceWrappers;
                    partners.forEach(function (item) {
                        var accountRec = item.account;
                        if (accountRec.Name.toLowerCase () == 'kvh industries'){
                            setViewLatLong = [accountRec.Latitude__c, accountRec.Longitude__c];
                        }
                    });
                }
            }
            if (setViewLatLong !== undefined){
            	map.setView(setViewLatLong, 13);
            	map.panTo(setViewLatLong);
            }
            component.set("v.map", map);
        }else{
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
        }
        //component.set("v.map", map);
        
       
        
    },

    createPopBody : function (component, accountRec, accountId, CSN) {
        console.log("AccountMapHelper.js-createPopBody");
        var contact = "Not Available",phone = "Not Available",email = "Not Available",website="Not Available";
        if(accountRec.Partner_Portal_Phone__c){
            phone = "<a href=\"tel:" + accountRec.Partner_Portal_Phone__c +"\">" + accountRec.Partner_Portal_Phone__c + "<\/a>";
        }
        if(accountRec.Partner_Portal_Email__c){
            email = "<a href=\"mailto:"+ accountRec.Partner_Portal_Email__c + "\">" + accountRec.Partner_Portal_Email__c + "<\/a>";
        }
        if(accountRec.Website && (typeof accountRec.Website.valueOf() == "string")){
            if (accountRec.Website.includes("http://") || accountRec.Website.includes("https://")){
                website = "<a href="+accountRec.Website+" target=\"_blank\">"+accountRec.Website+"<\/a>";
            }else{
                website = "<a href=http://"+accountRec.Website+" target=\"_blank\">"+accountRec.Website+"<\/a>";
            }
        }
        if(accountRec.Partner_Portal_Main_Contact__r && accountRec.Partner_Portal_Main_Contact__r.Name != undefined){
            contact = accountRec.Partner_Portal_Main_Contact__r.Name;
        }
        if(accountRec.ShippingAddress){
            var street = accountRec.ShippingAddress.street;
            var city = accountRec.ShippingAddress.city;
            var postalCode = accountRec.ShippingAddress.postalCode;
            var country = accountRec.ShippingAddress.country;
            var state = accountRec.ShippingAddress.state;
            
        }else{
            var street = accountRec.ShippingStreet;
            var city = accountRec.ShippingCity;
            var postalCode = accountRec.ShippingPostalCode;
            var country = accountRec.ShippingCountry;
            var state = accountRec.ShippingState;
            //var gmap = "https://maps.google.com?daddr="+accountRec.Latitude__c+","+ accountRec.Longitude__c;
    
        }

        var productId =  component.get("v.productId");
        var searchOption =  component.get("v.searchOption");
        var stateCountry =  component.get("v.stateCountry");
        var address = street.replace(new RegExp(" ", "g"),"+")+"+"+city.replace(" ","+")+"+"+state.replace(" ","+") +"+"+postalCode.replace(" ","+")+"+"+country.replace(" ","+");
        var gmap = "https://maps.google.com?daddr="+address;
        var strVar="";
        strVar += "<div class=\"pad-20\">";
       // strVar += "    <h2 class=\"left\" style=\"font-family: sans-serif;font-size: .75rem;color:#eeb214;font-weight: bold\"><b>CSN "+CSN+"<\/b><\/h2>";
        strVar += "    <h5><\/h5>";
        strVar += "    <h2 class=\"left\" style=\"font-family: sans-serif;line-height: 1.25;color:#1f83ad;font-weight: bold;font-size: 1.2em\"><b>"+accountRec.Name+"<\/b><\/h2>";
        strVar += "    <p style=\"font-family: sans-serif;line-height: 1.25;\">";
        strVar += street+"<br>"+ city +", "+ state +" "+ postalCode + "<br>" + country; 
        strVar += "        <br>";
        strVar += "    <\/p>";
        strVar += "    <div class=\"clear\"><\/div>";
        strVar += "    <p style=\"font-family: sans-serif;line-height: 1.25;\">";
        strVar += "        <strong>Contact Name:<\/strong> " + contact + "  <br> Phone: " + phone + "<br> Website: " + website; //"<br> E-mail: " + email +
        strVar += "    <\/p>";
        strVar += "    <div class=\"slds-size1-of-1\" >";
        strVar += "    <a class=\"slds-button slds-button_destructive\" style=\"width:100%;margin-top:15px;font-size: 11px;font-weight: bold;border-radius: 0px;color: #fff; padding-left: 1rem; padding-right: 1rem;\" href=/" + $A.get("$Label.c.Community_Prefix") + "/s/RequestAQuote?RepId=" + accountId + "&ProductID=" + productId + "&Request=" + searchOption + "&Location=" + stateCountry + " target=\"_blank\">Request a Quote<\/a>";
        strVar += "        <br>";
        strVar += "    <a href="+gmap+" target=\"_blank\" class=\"slds-button\" style=\"width:100%;margin-top:10px; padding-left: 1rem;font-size: 11px;font-weight: bold;color: #444444;border-radius: 0px;padding-right: 1rem; border: 1pt solid lightgrey;\">Get Directions<\/a>";
        strVar += "    <\/div>";
        strVar += "    <div class=\"clear\"><\/div>";
        strVar += "<\/div>";
        return strVar;
    }
})