/**
* Created by Jai Chaturvedi on 3/08/2017.
*/
public without sharing class WhereToBuyController {

    public static String searchType = 'WhereToBuy';
    public static List<String> pickValues(Sobject object_name, String field_name) {
        List<String> options = new List<String>();
        Schema.sObjectType sobject_type = object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(a.getValue());
        }
        return options; //return the List
    }
    
    public static List<String> getObjects(String objectParam, String field_name){
        sObject sObj = Schema.getGlobalDescribe().get(objectParam).newSObject();
        System.debug(objectParam);
        System.debug(sObj);
        return WhereToBuyController.pickValues(sObj, field_name) ;
    }
    
    @AuraEnabled
    public static Map<String,Object> loadOptions(Integer productId){
        System.debug('loadOption');
        Map<String, Object> resultMap = new Map<String, Object>();
        resultMap.put('countries',WhereToBuyController.getObjects('Country__c', 'Country__c'));
        resultMap.put('market',WhereToBuyController.getObjects('Product_Market_Sector__c', 'market__c'));
        if(productId != null){
            Product_Market_Sector__c ms = fetchDefaultProductMarketSector(productId);
            resultMap.put('productmarketsector',ms);
         }
        System.debug(resultMap);
        return resultMap;
    }
    
    private static Product_Market_Sector__c fetchDefaultProductMarketSector(Integer productId){
        List<Product_Market_Sector__c> marketSectorlst = [Select Product__c,Market__c,Sector__c from Product_Market_Sector__c where External_ProductID__c =: productId limit 1];
        if(marketSectorlst.size()>0)
            return marketSectorlst[0];
        return null;
    }
    
    @AuraEnabled
    public static List<Product_Market_Sector__c> searchMarketSector(String market,String sector, String searchOption){
        String query = 'SELECT Market__c, Sector__c, Product_Line1__c, Product_Series1__c, Product__c, Catalog_Display_Name__c FROM Product_Market_Sector__c WHERE Display_Product__c = true AND ' +
                        'Market__c = \'' + market + '\' AND Sector__c = \'' + sector + '\'';
        if (String.isNotBlank(searchOption)) {
            if (searchOption.equalsIgnoreCase('WhereToBuy')) {
                query = query + ' AND Retired__c=false';//Sales__c
            }else{
                Date todaysDate = Date.today();
                Date pastServiceDate = Date.valueOf(String.valueOf(todaysDate.year() - 8) + '-' + String.valueOf(todaysDate.month()) + '-' + String.valueOf(todaysDate.day()) + ' 00:00:00');
                query = query + ' AND ( Retired_Date__c = null OR Retired_Date__c >=: pastServiceDate )';//Sales__c
            }
        }
        System.debug(query);
        List<Product_Market_Sector__c> mktSctQuery = Database.query(query);
        List<Product_Market_Sector__c> productMarketSectorList = new List<Product_Market_Sector__c>();
        List<Id> products = new List<Id>();
        for (Product_Market_Sector__c pms : mktSctQuery) {
            if (listContainsElement(products, pms.Product__c) == false){
                products.add(pms.Product__c);
                productMarketSectorList.add(pms);
            }
        }
        return productMarketSectorList;
    }
    
    @AuraEnabled
    public static List<Id> findMarketSectorIds(String market,String sector, String product){
        List<Product_Market_Sector__c> marketSectors = new List<Product_Market_Sector__c>();
        if (product != 'None'){
            marketSectors = Database.query('SELECT Id FROM Product_Market_Sector__c WHERE Market__c = \'' + market + '\' AND Sector__c = \'' + sector + '\' AND Product__c = \'' + product + '\' AND Display_Product__c = true');
        }else{
            marketSectors = Database.query('SELECT Id FROM Product_Market_Sector__c WHERE Market__c = \'' + market + '\' AND Sector__c = \'' + sector + '\' AND Display_Product__c = true');
        }
        List<Id> marketSectorsIds = new List<Id>();
        for (Product_Market_Sector__c mktSct : marketSectors) {
            marketSectorsIds.add(mktSct.Id);
        }
        return marketSectorsIds;
    }
    
    
    @AuraEnabled
    public static String findLatLongOfZip(String country,String zipcode){
        String address = country + ',' + zipcode;
        Double lat;
        Double lon;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + address +'&sensor=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        Type resultType = Type.forName('GoogleGeoCodeClass');
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        if (m.get('status') != 'OK'){
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + zipcode +'&sensor=false');
            req.setMethod('GET');
            res = h.send(req);
            m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            if (m.get('status') != 'OK'){
                return 'Failure';
            }
        }
        GoogleGeoCodeClass.GoogleGeoCode deserializeResults = GoogleGeoCodeClass.parse(res.getBody());
        List<GoogleGeoCodeClass.Address_components> address_components = deserializeResults.results[0].address_components;
        GoogleGeoCodeClass.Location location = deserializeResults.results[0].geometry.location;
        lat = location.lat;
        lon = location.lng;
        String latLong = lat + ',' + lon;
        return latLong;
    }   
    
    @AuraEnabled
    public static List<Country__c> findCountries(String country,String state, Boolean stateFlag, String market, String sector, String product){
        List<Id> marketSectorsIds = findMarketSectorIds(market, sector, product);
        String countryQuery = 'SELECT Country__c, Product_Catalog__c,State__c, Sales_Representative__c , Sales_Representative_Name__c, ' + 
            'Sales_Representative__r.Rep_City__c, Sales_Representative__r.Rep_Country__c, Sales_Representative__r.Rep_State__c, ' +
            'Sales_Representative__r.Rep_Street__c, Sales_Representative__r.Rep_Zip__c, Sales_Representative__r.Sales_Rep_Contact__c, ' +
            'Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress,Sales_Representative__r.Sales_Rep_Contact__r.Mailing_Longitude__c,Sales_Representative__r.Sales_Rep_Contact__r.Mailing_Latitude__c, ' +
            'Sales_Representative__r.Sales_Rep_Contact__r.Partner_Portal_Email__c ,Sales_Representative__r.Sales_Rep_Contact__r.account.recordType.name,' +
            'Sales_Representative__r.Sales_Rep_Contact__r.Partner_Portal_Phone__c  FROM Country__c WHERE';
        if(stateFlag){
            countryQuery = countryQuery + ' Country__c =\''+ country + '\' AND State__c INCLUDES ( \''+ state +'\' )';
        }else{
            countryQuery = countryQuery + ' Country__c =\''+ country + '\'';
        }
        countryQuery = countryQuery + ' AND Product_Catalog__r.Product_Market_Sector__c IN : marketSectorsIds';
        return Database.query(countryQuery);
    }
    
    @AuraEnabled
    public static List<Product_Catalogue__c> findProductCatalogues(List<Country__c> dbCountryQuery, String market, String sector, String searchOption, String prodId){
        Set<Id> product_catalogueIds = new Set<Id>();
        for (Country__c cont : dbCountryQuery) {
            product_catalogueIds.add(cont.Product_Catalog__c);
        }
        String query = 'SELECT Id, Product_Market_Sector__r.Market__c, Product_Market_Sector__r.Sector__c, Product_Line__c, Product_Series__c, Partner_Account__r.Shipping_Latitude__c,' +
            'Partner_Account__r.Shipping_Longitude__c, Catalog_Display_Name__c, Product_Market_Sector__r.Product__c, Partner_Account__r.Account_Status__c, Partner_Account__r.Info_Only__c,' +
            'Partner_Account__c, Sales__c, CSN_Level__c, Services_Only__c, Product_ID__c ' +
            'FROM Product_Catalogue__c ' +
            'WHERE CSN_Level__c != null AND Partner_Account__r.Account_Status__c = \'Active\' AND Display_Product__c = true AND Partner_Account__r.Info_Only__c = false AND ' +
            'Product_Market_Sector__r.Market__c=\'' + market + '\' AND ' +
            'Product_Market_Sector__r.Sector__c=\'' + sector + '\' AND ' +
            'Id IN : product_catalogueIds';
        if (String.isNotBlank(searchOption)) {
            if (searchOption.equalsIgnoreCase('WhereToBuy')) {
                query = query + ' AND Sales__c=true AND Partner_Account__r.Display_on_Where_to_Buy__c=true';//Sales__c
            } else {
                query = query + ' AND Services_Only__c=true AND Partner_Account__r.Display_on_Where_to_Get_Service__c=true';//Service_Only__c
            }
        }
        query = query + ' AND Product_Market_Sector__r.Product__c =\'' + prodId +'\'';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static Map<Id, Account> getAccountInfo(List<String> accountIdList){
        return new Map<Id, Account>([SELECT Name, ShippingAddress, Shipping_Latitude__c,Shipping_Longitude__c,
                                     Account_Status__c, Partner_Role__c, Partner_Portal_Phone__c, Website,
                                     Partner_Portal_Email__c, Partner_Portal_Main_Contact__r.Name,recordType.name
                                     FROM Account WHERE Id IN :accountIdList ]);
        
    }
    
    @AuraEnabled
    public static Map<String, List<DistanceWrapper>> getKVHAccount(Map<String, List<DistanceWrapper>> typeDistanceWrappers, List<String> allProductIDSet){
        DefaultAccounts__c kvhDefaultAccount = DefaultAccounts__c.getInstance('KVH_Official_Internal_Contacts');
        List<String> kvhIds = new List<String>();
        kvhIds.add(kvhDefaultAccount.Account_ID__c);
        for(Account kvhaAccount : getAccountInfo(kvhIds).values()){
            kvhaAccount.Latitude__c = kvhaAccount.Shipping_Latitude__c;
            kvhaAccount.Longitude__c = kvhaAccount.Shipping_Longitude__c;
            kvhaAccount.Name = 'KVH Industries';
            DistanceWrapper distanceWrapper = new DistanceWrapper();
            distanceWrapper.accountId = kvhaAccount.Id;
            distanceWrapper.accountRecordType  = kvhaAccount.recordType.name;
            distanceWrapper.account = kvhaAccount;
            distanceWrapper.productId = new Set<String>(allProductIDSet);
            distanceWrapper.CSN = 'Master';
            distanceWrapper.Sales = true;
            distanceWrapper.ServicesOnly = true;
            if (typeDistanceWrappers.containsKey('Representative')){
                List<DistanceWrapper> tempDstWrppr = typeDistanceWrappers.get('Representative');
                tempDstWrppr.add(distanceWrapper);
                typeDistanceWrappers.put('Representative',tempDstWrppr);
            }else{
                typeDistanceWrappers.put('Representative',new List<DistanceWrapper>{distanceWrapper});
            }
        }
        return typeDistanceWrappers;
    }
    
    @AuraEnabled
    public static Double getMilesLimit(String unit, String distance){
        Double mileLimit = 0.0;
        if (String.isNotBlank(unit)) {
            if (unit.equalsIgnoreCase('miles')) {
                mileLimit = (Integer.valueOf(distance) * 1609.34);
            } else {
                mileLimit = (Integer.valueOf(distance) * 1000);
            }
        }
        return mileLimit;
    }
    
    
    @AuraEnabled
    public static GoogleDisMatrixJSONParser getGoogleDestinations(String latLong, Map<Id, String> latitudeLongitute){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req = new HttpRequest();
        req.setMethod('GET');
        String url = 'https://maps.googleapis.com/maps/api/distancematrix/json' + '?origins=' +
            latLong +
            '&destinations=' + String.join(latitudeLongitute.values(), '|') +
            '&mode=driving' + '&language=en' + '&units=imperial';
        System.debug(url);
        req.setEndPoint(url);
        HTTPResponse resp = h.send(req);
        System.debug(resp);
        return (GoogleDisMatrixJSONParser) JSON.deserialize(resp.getBody(), GoogleDisMatrixJSONParser.class);
    }
    
    @AuraEnabled
    public static Account getContactInformation(Account account, Country__c cont){
        Account tempAccount = new Account();
        tempAccount.Partner_Portal_Account_Name__pc = account.Name;
        tempAccount.Partner_Role__c = 'Representative';
        tempAccount.Partner_Portal_Phone__c = cont.Sales_Representative__r.Sales_Rep_Contact__r.Partner_Portal_Phone__c;
        tempAccount.Partner_Portal_Email__c = cont.Sales_Representative__r.Sales_Rep_Contact__r.Partner_Portal_Email__c;
        tempAccount.Name = cont.Sales_Representative_Name__c;
        tempAccount.Website = account.Website;
        if (cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress != null){
            tempAccount.ShippingStreet = cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress.getStreet();
            tempAccount.ShippingCity = cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress.getCity();
            tempAccount.ShippingState = cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress.getState();
            tempAccount.ShippingPostalCode = cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress.getPostalCode();
            tempAccount.ShippingCountry = cont.Sales_Representative__r.Sales_Rep_Contact__r.MailingAddress.getCountry();
            tempAccount.Latitude__c = cont.Sales_Representative__r.Sales_Rep_Contact__r.Mailing_Latitude__c;
            tempAccount.Longitude__c = cont.Sales_Representative__r.Sales_Rep_Contact__r.Mailing_Longitude__c;
        }else if (account.ShippingAddress != null) {
            tempAccount.ShippingStreet = account.ShippingAddress.getStreet();
            tempAccount.ShippingCity = account.ShippingAddress.getCity();
            tempAccount.ShippingState = account.ShippingAddress.getState();
            tempAccount.ShippingPostalCode = account.ShippingAddress.getPostalCode();
            tempAccount.ShippingCountry = account.ShippingAddress.getCountry();
            tempAccount.Latitude__c = account.Shipping_Latitude__c;
            tempAccount.Longitude__c = account.Shipping_Longitude__c;
        } else{
            tempAccount.Latitude__c = null;
            tempAccount.Longitude__c = null;
        }
        return tempAccount;
    }
    
    
    @AuraEnabled
    public static Map<String, List<DistanceWrapper>> getDistanceWrappersByType(Map<String, List<DistanceWrapper>> typeDistanceWrappers, List<DistanceWrapper> distanceWrappers){
        for (DistanceWrapper dw : distanceWrappers) {
            system.debug(dw);
            if (typeDistanceWrappers.containsKey(dw.account.Partner_Role__c)) {
                List<DistanceWrapper> dwTempListWrappers = typeDistanceWrappers.get(dw.account.Partner_Role__c);
                Boolean duplicateFlag = false;
                for (DistanceWrapper d : dwTempListWrappers) {
                    for (DistanceWrapper dInner : dwTempListWrappers) {
                        if (dInner.accountId == dw.accountId) {
                            duplicateFlag = true;
                        }
                    }
                }
                if (!duplicateFlag) {
                    dwTempListWrappers.add(dw);
                    typeDistanceWrappers.put(dw.account.Partner_Role__c, dwTempListWrappers);
                }
            } else {
                typeDistanceWrappers.put(dw.account.Partner_Role__c, new List<DistanceWrapper>{dw});
            }
        }
        return typeDistanceWrappers;
    }
    
    @AuraEnabled
    public static Boolean listContainsElement(List<Id> internalRepIds, Id accountId){
        for (Id acctId : internalRepIds){
            if (acctId == accountId){
                return true;
            }
        }
        return false;
    }
    
    @AuraEnabled
    public static List<WhereToBuyController.AccountType> getAccountsByType(List<WhereToBuyController.AccountType> accountTypes, Map<String, List<DistanceWrapper>> typeDistanceWrappers, List<Id>internalRepIds, Boolean externalRepsWereSet){
        Integer count = 1;
        Map<String, Object> results = new Map<String, Object>();
        for (String accountType : typeDistanceWrappers.keySet()) {
            List<DistanceWrapper> dwList = typeDistanceWrappers.get(accountType);
            List<DistanceWrapper> externalAccounts = new List<DistanceWrapper>();
            List<DistanceWrapper> internalReps = new List<DistanceWrapper>();
            List<DistanceWrapper> kvhFinalAccount = new List<DistanceWrapper>();
            dwList.sort();
            system.debug(dwList);
            for (DistanceWrapper d : dwList) {
                if (WhereToBuyController.hasSObjectField(d.account,'Partner_Portal_Account_Name__pc') && listContainsElement(internalRepIds,d.accountId)) {
                    d.account.Partner_Portal_Account_Name__pc = 'KVH Industries';
                    internalReps.add(d);
                }else if (d.account.Name == 'KVH Industries'){
                    kvhFinalAccount.add(d);
                }else{
                    externalAccounts.add(d);
                }
            }
            List<DistanceWrapper> finalDWList = new List<DistanceWrapper>();
            externalAccounts.sort();
            for (DistanceWrapper d : externalAccounts) {
                d.srnumber = count;
                count++;
                finalDWList.add(d);
            }
            if (!externalRepsWereSet){
                internalReps.sort();
                for (DistanceWrapper d : internalReps) {
                    d.srnumber = count;
                    count++;
                    finalDWList.add(d);
                }
            }
            for (DistanceWrapper d : kvhFinalAccount) {
                d.srnumber = count;
                count++;
                finalDWList.add(d);
            }
            accountTypes.add(new AccountType(accountType, finalDWList));
        }
        accountTypes.sort();
        return accountTypes;
    }    

    @AuraEnabled
    public static Map<String,Object> searchPartner(String zipcode,String country,String market,String sector,String prodId, String distance,String unit,String searchOption,String state) {
        WhereToBuyController.searchType = searchOption;
        Map<String, Object> resultMap = new Map<String, Object>();
        Map<String, KVH_Countries__mdt> countryMap = New Map<String, KVH_Countries__mdt>();

        for(KVH_Countries__mdt mCountry: [SELECT Label, IsoCode_2__c FROM KVH_Countries__mdt]){
            countryMap.put(mCountry.Label.toUpperCase(),mCountry);
        }
        if (countryMap.containsKey(country.toUpperCase())){
            resultMap.put('country', countryMap.get(country.toUpperCase()).IsoCode_2__c);
        }else{
            resultMap.put('country', country);
        }
        if(String.isNotBlank(zipcode)){
            resultMap.put('state','');
        }else if (state != null || String.isNotBlank(state)){
            Map<String, KVH_States__mdt> stateMap = New Map<String, KVH_States__mdt >();
            
            for(KVH_States__mdt mState: [SELECT Label, FullIsoCode__c FROM KVH_States__mdt ]){
                stateMap.put(mState.Label.toUpperCase(),mState);
            }
            if (state != null && stateMap.containsKey(state.toUpperCase())){
                resultMap.put('state', stateMap.get(state.toUpperCase()).FullIsoCode__c);
            }else{
                resultMap.put('state', state);
            }
        }
        try{
            List<WhereToBuyController.AccountType> accountTypes = new List<WhereToBuyController.AccountType>();
            resultMap.put('accountlist', accountTypes);
            Boolean stateFlag = false;
            List<String> states = new List<String>();
            String latLong = '';
            if(String.isNotBlank(zipcode)){
                latLong = findLatLongOfZip(country, zipcode);
                if (latLong == 'Failure'){
                    return resultMap;
                }
            }else if(state != null && !state.equalsIgnoreCase('None')){
                stateFlag = true;
            }
            Boolean externalRepsWereSet = false;
            Map<Id, String> latitudeLongitute = new Map<Id, String>();
            Map<String, String> accountIdLatLanMap = new Map<String, String>();
            Map<String,String> repAccountRecordTypeMap = new Map<String,String>();
            Map<String, Set<String>> accountId_ProductCatalogue = new Map<String, Set<String>>();
            List<String> accountIdList = new List<String>();
            List<Product_Catalogue__c> Product_CatalogueList = new List<Product_Catalogue__c>();
            Map<String, List<DistanceWrapper>> typeDistanceWrappers = new Map<String, List<DistanceWrapper>>();
            List<Country__c> dbCountryQuery = findCountries(country, state, stateFlag, market, sector, prodId);
            Set<String> allProductIDSet = new Set<String>();
            allProductIDSet.add(prodId);
            List<Id> internalRepIds = new List<Id>();
            DefaultAccounts__c kvhDefaultAccount = DefaultAccounts__c.getInstance('KVH_Official_Internal_Contacts');
            if (!dbCountryQuery.isEmpty()) {
                List<Product_Catalogue__c> dbQuery = findProductCatalogues(dbCountryQuery, market, sector, searchOption, prodId);
                Map<Id, String> CSN = new Map<Id, String>();
                Map<Id, Boolean> ServicesOnly = new Map<Id, Boolean>();
                Map<Id, Boolean> Sales = new Map<Id, Boolean>();
                for (Product_Catalogue__c pc : dbQuery) {
                    latitudeLongitute.put(pc.Partner_Account__c, pc.Partner_Account__r.Shipping_Latitude__c.toPlainString() + ',' + pc.Partner_Account__r.Shipping_Longitude__c.toPlainString());
                    accountIdList.add(pc.Partner_Account__c);
                    Product_CatalogueList.add(pc);
                    CSN.put(pc.Partner_Account__c, pc.CSN_Level__c);
                    ServicesOnly.put(pc.Partner_Account__c, pc.Services_Only__c);
                    Sales.put(pc.Partner_Account__c, pc.Sales__c);
                    if (accountId_ProductCatalogue.containsKey(pc.Partner_Account__c)) {
                        Set<String> prodIdSet = accountId_ProductCatalogue.get(pc.Partner_Account__c);
                        prodIdSet.add(pc.Product_Market_Sector__r.Product__c);
                        allProductIDSet.add(pc.Product_Market_Sector__r.Product__c);
                        accountId_ProductCatalogue.put(pc.Partner_Account__c, prodIdSet);
                    } else {
                        accountId_ProductCatalogue.put(pc.Partner_Account__c,new Set<String>{pc.Product_Market_Sector__r.Product__c});
                        allProductIDSet.add(pc.Product_Market_Sector__r.Product__c);
                    }
                }
                Map<Id, Account> accountsByIds = new Map<Id, Account>(getAccountInfo(accountIdList));
                for(Id accId : accountsByIds.keySet()){
                    Account account = accountsByIds.get(accId);
                    if (account.Partner_Role__c == 'Rep'){
                        //remove account from accountsByIds Contacts being added
                        accountsByIds.remove(accId);
                        ServicesOnly.remove(accId);
                        Sales.remove(accId);
                        CSN.remove(accId);
                        latitudeLongitute.remove(accId);
                        accountId_ProductCatalogue.remove(accId);
                        for (Product_Catalogue__c pc : dbQuery) {
                            if (pc.Partner_Account__c == accId){
                                for (Country__c cont : dbCountryQuery) {
                                    if(pc.Id == cont.Product_Catalog__c){
                                        Account tempAccount = getContactInformation(account, cont);
                                        if (tempAccount.Latitude__c != null && tempAccount.Longitude__c != null){
                                            accountsByIds.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, tempAccount);
                                            CSN.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, pc.CSN_Level__c);
                                            Sales.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, pc.Sales__c);
                                            ServicesOnly.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, pc.Services_Only__c);
                                            latitudeLongitute.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, tempAccount.Latitude__c.toPlainString() + ',' + tempAccount.Longitude__c.toPlainString());
                                            repAccountRecordTypeMap.put(cont.Sales_Representative__r.Sales_Rep_Contact__c,cont.Sales_Representative__r.Sales_Rep_Contact__r.account.recordType.name);
                                            if (accountId_ProductCatalogue.containsKey(cont.Sales_Representative__r.Sales_Rep_Contact__c)) {
                                                Set<String> prodIdSet = accountId_ProductCatalogue.get(cont.Sales_Representative__r.Sales_Rep_Contact__c);
                                                accountId_ProductCatalogue.put(cont.Sales_Representative__r.Sales_Rep_Contact__c, prodIdSet);
                                            } else {
                                                accountId_ProductCatalogue.put(cont.Sales_Representative__r.Sales_Rep_Contact__c,new Set<String>{pc.Product_Market_Sector__r.Product__c});
                                                allProductIDSet.add(pc.Product_Market_Sector__r.Product__c);
                                            }
                                            if (kvhDefaultAccount.Account_ID__c != accId){
                                                externalRepsWereSet = true;
                                            }else{
                                                internalRepIds.add(cont.Sales_Representative__r.Sales_Rep_Contact__c);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else if (account.Partner_Role__c == 'Service Provider'){
                        account.Partner_Role__c = 'Distributor';
                        if (account.Shipping_Latitude__c != null && account.Shipping_Longitude__c != null){
                            account.Latitude__c = account.Shipping_Latitude__c;
                            account.Longitude__c = account.Shipping_Longitude__c;
                        }
                        accountsByIds.remove(accId);
                        accountsByIds.put(accId, account);
                    }else {
                        account.Latitude__c = account.Shipping_Latitude__c;
                        account.Longitude__c = account.Shipping_Longitude__c;
                        accountsByIds.remove(accId);
                        accountsByIds.put(accId, account);
                    }
                }
                List<DistanceWrapper> distanceWrappers = new List<DistanceWrapper>();
                if(String.isNotBlank(zipcode) && latitudeLongitute.size() > 0){
                    GoogleDisMatrixJSONParser temp = getGoogleDestinations(latLong, latitudeLongitute);
                    List<String> destinations = temp.destination_addresses;
                    Double mileLimit = getMilesLimit(unit, distance);
                    List<Id> latitudeLongituteKeys = new List<Id>();
                    latitudeLongituteKeys.addall(latitudeLongitute.keySet());
                    if (destinations != null && !destinations.isEmpty()) {
                        for (Integer i = 0; i < temp.rows[0].elements.size(); i++) {
                            if (temp.rows[0].elements[i].distance.value < mileLimit) {
                                Id latLonKey = latitudeLongituteKeys.get(i);
                                
                               
                                DistanceWrapper tempdw = new DistanceWrapper(accountId_ProductCatalogue.get(latLonKey), accountsByIds.get(latLonKey), 
                                                                                      latLonKey, CSN.get(latLonKey), Sales.get(latLonKey), ServicesOnly.get(latLonKey), 
                                                                                      temp.rows[0].elements[i].distance.text, temp.rows[0].elements[i].duration.value,
                                                                                      temp.rows[0].elements[i].duration.text, temp.destination_addresses[i]);
                                 if(repAccountRecordTypeMap.containskey(latLonKey))
                                    tempdw.accountRecordType = repAccountRecordTypeMap.get(latLonKey);
                                distanceWrappers.add(tempdw);
                            }
                        }
                    }
                }else{
                    for(Id accId : accountsByIds.keySet()){
                         DistanceWrapper tempdw = new DistanceWrapper(accountId_ProductCatalogue.get(accId), accountsByIds.get(accId), 
                                                                 accId, CSN.get(accId), Sales.get(accId), ServicesOnly.get(accId));
                        if(repAccountRecordTypeMap.containskey(accId))
                                tempdw.accountRecordType = repAccountRecordTypeMap.get(accId);
                          
                        distanceWrappers.add(tempdw);
                    }
                }
                system.debug(distanceWrappers);
                typeDistanceWrappers = getDistanceWrappersByType(typeDistanceWrappers, distanceWrappers);
            }
            typeDistanceWrappers = getKVHAccount(typeDistanceWrappers, new List<String>(allProductIDSet));
            accountTypes = getAccountsByType(accountTypes, typeDistanceWrappers, internalRepIds, externalRepsWereSet);
            resultMap.put('accountlist', accountTypes);
        }catch(Exception ex){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'sfsupport@kvh.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Where To Buy Failure');
            mail.setSenderDisplayName('Salesforce Support');
            mail.setReplyTo('sfsupport@kvh.com');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('Zipcode: ' + zipcode + ',' + 'market: ' + market + ',' + 'country: ' + country + ',' + 'sector: ' + sector + ',' + 
                                  'distance: ' + distance + ',' + 'prodId: ' + prodId + ',' + 'unit: ' + unit + ',' + 'searchOption: ' + searchOption + ',' + 
                                  'state: ' + state);
            mail.setHtmlBody('<p>' +'Zipcode: ' + zipcode + ',' + 'market: ' + market + ',' + 'country: ' + country + ',' + 'sector: ' + sector + ',' + 
                                  'distance: ' + distance + ',' + 'prodId: ' + prodId + ',' + 'unit: ' + unit + ',' + 'searchOption: ' + searchOption + ',' + 
                                  'state: ' + state + '</p>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        return resultMap;
    }
    
    public static boolean hasSObjectField(SObject so, String fieldName){
        String s = JSON.serialize(so);
        // Deserialize it back into a key/value map
        Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(s);
        
        // Build a set containing the fields present on our SObject
        Set<String> fieldsPresent = obj.keyset().clone();
        
        return fieldsPresent.contains(fieldName);
    }
    
    public class AccountType implements Comparable{
        @AuraEnabled public String accType {get;set;}
        @AuraEnabled List<DistanceWrapper> distanceWrappers {get;set;}
        
        
        public AccountType(String accType, List<DistanceWrapper> distanceWrappers){
            this.accType = accType;
            this.distanceWrappers = distanceWrappers;
        }
        
        public Integer compareTo(Object obj) {
           
            AccountType at = (AccountType)(obj);
            Map<String, Integer> accTypelevel = new Map<String, Integer>();
            accTypelevel.put('Dealer', 1);
            accTypelevel.put('Distributor', 2);
            accTypelevel.put('Representative', 3);
            if (accTypelevel.get(this.accType) > accTypelevel.get(at.accType)){
                return 1;
            }else if (accTypelevel.get(this.accType) == accTypelevel.get(at.accType)){
                return 0;
            }else {
                return -1;
            }
       }
    }

    
}