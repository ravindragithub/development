public with sharing class ControllerAssignTitlesToCharge {
    public invoiceit_s__Job_Rate_Plan_Charge__c orderCharge{get;set;}
    public list<innerTitles> listofTitlesClass {get;set;}
    innerTitles innerTitlesobj;
    public map<Integer, Order_Charge_Titles__c> mapOfOrderChargeTitles {get;set;}
    list<Order_Charge_Titles__c> listofOrderTitleTodelete = new list<Order_Charge_Titles__c>();
    public string sSearchString {get;set;}
    string sQueryStatic = '';
    string sQuery = '';
    string sQueryStaticTitles = '';
    public string sSearchStringFormat {get;set;}
    set<Id> setOfTitles = new set<Id>();
    public boolean isVOD = false;
    list<Titles__c> listofTitle; 
    CustomIterableForTitles CustomIterableForTitles;
    public integer iCount {get;set;}
    public boolean hasPrevious {get;set;}
    public boolean hasNext {get;set;}
    set<Id> setofTitleFormat;

    public ControllerAssignTitlesToCharge(ApexPages.StandardController controller) {
        listofTitle = new list<Titles__c>();
        orderCharge = (invoiceit_s__Job_Rate_Plan_Charge__c)controller.getRecord();
        sSearchString = '';
        sSearchStringFormat = '';
        orderCharge = [select name,invoiceit_s__Order__c,invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Job__r.invoiceit_s__Account__c,invoiceit_s__Order__r.Name,invoiceit_s__Order__r.invoiceit_s__Status__c
                       ,Count_Of_Titles__c,invoiceit_s__Order__r.invoiceit_s__Account__c,invoiceit_s__Service_Activation_Date__c,invoiceit_s__Service_End_Date__c,invoiceit_s__Quantity__c
                       ,invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product_Code__c,invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name
                       ,invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.invoiceit_s__Product__r.invoiceit_s__Product_Family__c,invoiceit_s__Order__r.Wet_or_Dry_Cargo__c,
                       invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name,invoiceit_s__Order__r.Order_Type_KVH__c,invoiceit_s__Order__r.Platform_or_Vessel_detail__c
                       From invoiceit_s__Job_Rate_Plan_Charge__c
                       Where id =:orderCharge.id];

        sQueryStatic = 'SELECT Name,Included_in_VOD__c,Series__c,Title_Platform_Detail__c,Platform_Type__c,BMS_Code__c,(SELECT Name,Regional_Format__c,Delivery_Method_s__c, Format__c, Language__c FROM Title_Types__r WHERE Status__c = \'Current\' ';

        If(orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'Rental Library' || orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Sale') {
            sQueryStatic = sQueryStatic + 'AND Delivery_Method_s__c includes(\'DVD\',\'VHS\',\'CD-ROM\')';
        } else if(orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' || orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'NVOD') {
            sQueryStatic = sQueryStatic + 'AND Delivery_Method_s__c includes(\'VOD G2\')';
        } 

        sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c ';

        if(orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Full VOD') {
            sQueryStaticTitles = sQueryStaticTitles + 'WHERE Included_in_VOD__c includes(\'Full VOD\')';
            if(orderCharge.invoiceit_s__Order__r.Wet_or_Dry_Cargo__c != null) {
                string sWetorDry = '\'' + orderCharge.invoiceit_s__Order__r.Wet_or_Dry_Cargo__c.replaceAll(';', '\',\'') + '\'';
                sQueryStaticTitles = sQueryStaticTitles + ' AND Platform_Type__c includes(' + sWetorDry +') ';
            }
        } else if((orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD' || orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD') && orderCharge.invoiceit_s__Order__r.Platform_or_Vessel_detail__c != null) {
            sQueryStaticTitles = sQueryStaticTitles + 'WHERE Title_Platform_Detail__c includes(\'' +orderCharge.invoiceit_s__Order__r.Platform_or_Vessel_detail__c + '\') AND Included_in_VOD__c includes(\'' +orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name + '\')';
        }

        sQuery = sQuery + sQueryStaticTitles + ' ';
        getTitles();
        for( Titles__c title : listofTitle ) {
            if(title.Title_Types__r.size() > 0) { 
                innerTitlesobj = new innerTitles();
                innerTitlesobj.title = title;
                If(! (orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                    && orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental')) {
                    list<innerFormats> listofinnerFormats = new list<innerFormats>();
                    innerFormats innerFormatsobj;
                    for(Format_Types__c formatTypes : title.Title_Types__r) {
                        innerFormatsobj = new innerFormats();
                        innerFormatsobj.formatType = formatTypes;
                        listofinnerFormats.add(innerFormatsobj);
                    }

                    innerTitlesobj.listofinnerFormats.addAll(listofinnerFormats);
                }  
                listofTitlesClass.add(innerTitlesobj);
            }
        } 

        list<Order_Charge_Titles__c> listofCharges = [SELECT Id,Order_Rate_Plan_Charge__c ,Titles__c,Format_Type__c  FROM Order_Charge_Titles__c WHERE Order_Rate_Plan_Charge__c =:orderCharge.Id ];         
        mapOfOrderChargeTitles = new map<Integer, Order_Charge_Titles__c>();                 
        integer iCounter = 0;
        for(Order_Charge_Titles__c chargeTitles : listofCharges ) {
            iCounter++;
            mapOfOrderChargeTitles.put(iCounter, chargeTitles);
            setOfTitles.add(chargeTitles.Titles__c);
        }

        if((orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD' 
            || orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD'
                || orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Flexi VOD')
                &&  orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental' && orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD') {
            isVOD = true;
        }
    }

    public void next() {
        populateTitles(CustomIterableForTitles.next());
        hasNext = CustomIterableForTitles.hasNext();
        hasPrevious = CustomIterableForTitles.hasPrevious();
    }

    public void previous() {
        populateTitles(CustomIterableForTitles.previous());
        hasNext = CustomIterableForTitles.hasNext();
        hasPrevious = CustomIterableForTitles.hasPrevious();
    }

    public void first() {
        populateTitles(CustomIterableForTitles.first());
        hasNext = CustomIterableForTitles.hasNext();
        hasPrevious = CustomIterableForTitles.hasPrevious();
    }

    public void last() {
        populateTitles(CustomIterableForTitles.last());
        hasNext = CustomIterableForTitles.hasNext();
        hasPrevious = CustomIterableForTitles.hasPrevious();
    }

    public void populateTitles(list<Titles__c> listofTitle) {
        listofTitlesClass = new list<innerTitles>();

        for( Titles__c title : listofTitle ) {
            if(title.Title_Types__r.size() > 0) { 
                innerTitlesobj = new innerTitles();
                innerTitlesobj.title = title;
                If(! ( orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                    && orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental')) {
                    list<innerFormats> listofinnerFormats = new list<innerFormats>();
                    innerFormats innerFormatsobj;
                    for(Format_Types__c formatTypes : title.Title_Types__r) {
                        innerFormatsobj = new innerFormats();
                        innerFormatsobj.formatType = formatTypes;
                        listofinnerFormats.add(innerFormatsobj);
                    }
                    innerTitlesobj.listofinnerFormats.addAll(listofinnerFormats);
                }  
                listofTitlesClass.add(innerTitlesobj);
            }
        } 
    }

    public void addTitles() {
        map<Integer, Order_Charge_Titles__c> mapOfOrderChargeTitlesLoc = new map<Integer, Order_Charge_Titles__c>();
        integer iCounter = mapOfOrderChargeTitles.size();
        integer iQuantity = Integer.valueOf(orderCharge.invoiceit_s__Quantity__c);
        boolean isSelectedQuantityMore = false;
        for(innerTitles innerTitleObj : listofTitlesClass) {
            if(innerTitleObj.isSelected) {
                setOfTitles.add(innerTitleObj.title.Id);
                if( (((orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD' && setOfTitles.size() > 50)
                        || (orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD' && setOfTitles.size() > 100)
                        || (orderCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Flexi VOD' && setOfTitles.size() > 30))
                        &&  orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental' && orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD')
                        || (orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental' && orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'Rental Library' && setOfTitles.size() > 50)
                        )
                {
                    isSelectedQuantityMore = true;
                }

                If(orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                    && orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental') {
                    iCounter++;
                    mapOfOrderChargeTitlesLoc.put(iCounter, new Order_Charge_Titles__c (Order_Rate_Plan_Charge__c =orderCharge.Id, Titles__c = innerTitleObj.title.Id ) );          
                }

                for(innerFormats innerFormats : innerTitleObj.listofinnerFormats ) {
                    if(innerFormats.isSelected) {
                        if(iQuantity == iCounter && (!( ( orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' || orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'Rental Library') && orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental'))) {
                            isSelectedQuantityMore = true;
                        }
                        iCounter++;
                        mapOfOrderChargeTitlesLoc.put(iCounter, new Order_Charge_Titles__c (Format_Type__c = innerFormats.formatType.Id, Order_Rate_Plan_Charge__c =orderCharge.Id, Titles__c = innerTitleObj.title.Id ) );
                        innerFormats.isSelected = false;
                    }
                }
                innerTitleObj.isSelected = false;

            }
        }  
        /*if(isSelectedQuantityMore) {
            mapOfOrderChargeTitlesLoc.clear();
            Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'The Selected titles are more than charge quantity');
            Apexpages.addMessage(infoMessage);
        }*/
        mapOfOrderChargeTitles.putAll(mapOfOrderChargeTitlesLoc); 
        
        setOfTitles = new set<Id>();
        for(Order_Charge_Titles__c orderChargeTitle : mapOfOrderChargeTitles.values()) {
            setOfTitles.add(orderChargeTitle.Titles__c);
        }
        orderCharge.Count_Of_Titles__c = setOfTitles.size(); 
    }

    public void removeTitles() {
        integer iCounterToRemove = Integer.valueOf(apexpages.currentpage().getparameters().get('removeTitles'));
        Order_Charge_Titles__c titles = mapOfOrderChargeTitles.get(iCounterToRemove);
        if(titles.Id != null)
            listofOrderTitleTodelete.add(new Order_Charge_Titles__c(Id = titles.Id));
        mapOfOrderChargeTitles.remove(iCounterToRemove);

        if(isVOD) { 
            setOfTitles = new set<Id>();
            for(Order_Charge_Titles__c orderChargeTitle : mapOfOrderChargeTitles.values()) {
                setOfTitles.add(orderChargeTitle.Titles__c);
            }
        }
    }

    public void saveTitles() {
        saveTitlesAndRedirect();
        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'The records have saved successfully.');
        Apexpages.addMessage(infoMessage);
    }

    public pagereference saveTitlesAndRedirect() {
        upsert mapOfOrderChargeTitles.values();
        delete listofOrderTitleTodelete;

        set<Id> setOfTitels = new set<Id>(); 
        for(Order_Charge_Titles__c orderCharge : mapOfOrderChargeTitles.values()) {
            setOfTitels.add(orderCharge.Titles__c);
        }
        
        if(orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'Training Titles') {
            list<Titles__c> listofTitles = [SELECT List_Price__c FROM Titles__c WHERE Id in: setOfTitels AND List_Price__c!=null];
            Decimal dSumOfTitlesAmount = 0;
            for (Titles__c Titles : listofTitles) {
                dSumOfTitlesAmount = dSumOfTitlesAmount + Titles.List_Price__c;
            }
            
            orderCharge.invoiceit_s__Unit_Price__c = dSumOfTitlesAmount;
        }
            
        orderCharge.Count_Of_Titles__c = setOfTitels.size();    
        update orderCharge;

        invoiceit_s__Job__c orderObj = new invoiceit_s__Job__c(Id = orderCharge.invoiceit_s__Order__c,  invoiceit_s__Recalculate__c = true);
        update orderObj;

        pagereference orderPage = new pagereference('/'+orderCharge.invoiceit_s__Order__c);  
        return orderPage;
    }

    public void searchTitles() {
        sQuery = '';
        string s =  sSearchString;
        sSearchString = '%' +sSearchString+ '%';

        if(sQueryStaticTitles == '') {
            sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c WHERE Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString OR CODE_NO__c LIKE: sSearchString OR Included_in_VOD__c includes(\'' +s+ '\')';
        } else {
            sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c ' + sQueryStaticTitles + ' AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString OR CODE_NO__c LIKE: sSearchString OR Included_in_VOD__c includes(\'' +s+ '\') )';
        }

        getTitles();

        if(!listofTitle.isEmpty()) {
            for( Titles__c title : listofTitle ) {
                if(title.Title_Types__r.size() > 0) { 
                    innerTitlesobj = new innerTitles();
                    innerTitlesobj.title = title;
                    If(! (orderCharge.invoiceit_s__Job_Rate_Plan__r.invoiceit_s__Job_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                        && orderCharge.invoiceit_s__Order__r.Order_Type_KVH__c == 'Rental')) {
                        list<innerFormats> listofinnerFormats = new list<innerFormats>();
                        innerFormats innerFormatsobj;
                        for(Format_Types__c formatTypes : title.Title_Types__r) {
                            innerFormatsobj = new innerFormats();
                            innerFormatsobj.formatType = formatTypes;
                            listofinnerFormats.add(innerFormatsobj);
                        }

                        innerTitlesobj.listofinnerFormats.addAll(listofinnerFormats);
                    }  
                    listofTitlesClass.add(innerTitlesobj);
                }
            } 
        } else {
            Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'No records meet the search criteria.');
            Apexpages.addMessage(infoMessage);
        }
        sSearchString = s;
    }

    public void getTitles() {
        list<Titles__c> listofTitleObj = database.query(sQuery);
        listofTitle = new list<Titles__c> ();
        for(Titles__c Titles : listofTitleObj) {
            if(titles.Title_Types__r.size() > 0) { 
                listofTitle.add(Titles);
            }
        } 
        iCount = listofTitle.size();
        CustomIterableForTitles = new CustomIterableForTitles(listofTitle);
        if(iCount > 100) { 
            hasNext = CustomIterableForTitles.hasNext();
            hasPrevious = CustomIterableForTitles.hasPrevious();
        } else {
            hasNext = false;
            hasPrevious = false;
        }

        if(!listofTitle.isEmpty()) {
            CustomIterableForTitles = new CustomIterableForTitles(listofTitle);
            listofTitle = CustomIterableForTitles.first();
            listofTitlesClass = new list<innerTitles>();
        }
    }

    list<Format_Types__c> listofFormatTypes;
    string sTitle;
    public void searchFormats() {
        string sFormat =  sSearchStringFormat;
        sTitle = sSearchString;
        if(sSearchStringFormat != '') {    
            sSearchStringFormat = '%' +sSearchStringFormat+ '%';
            sSearchString = '%' +sSearchString+ '%';
            string sQueryFormat = 'SELECT Name,Regional_Format__c,Delivery_Method_s__c,Title__c,Format__c,Language__c FROM Format_Types__c WHERE (Format__c LIKE: sSearchStringFormat OR Language__c LIKE: sSearchStringFormat) AND Status__c = \'Current\' ';

            listofFormatTypes = database.query(sQueryFormat);

            if(listofFormatTypes.isEmpty()) {
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'No records meet the search criteria.');
                Apexpages.addMessage(infoMessage);
            } else {
                setofTitleFormat = new set<Id>();
                for(Format_Types__c format : listofFormatTypes) {
                    setofTitleFormat.add(format.Title__c);
                }
                if (sQueryStaticTitles == '') {
                    sQuery = sQueryStatic + ' AND Id In:listofFormatTypes ),CODE_NO__c FROM Titles__c WHERE Id in: setofTitleFormat AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString OR CODE_NO__c LIKE: sSearchString OR Included_in_VOD__c includes(\'' +sTitle+ '\') )';
                } else {
                    sQuery = sQueryStatic + ' AND Id In:listofFormatTypes ),CODE_NO__c FROM Titles__c ' + sQueryStaticTitles + ' AND Id in: setofTitleFormat AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString OR CODE_NO__c LIKE: sSearchString OR Included_in_VOD__c includes(\'' +sTitle+ '\') )';
                }

                getTitles();

                for( Titles__c title : listofTitle ) {
                    if(title.Title_Types__r.size() > 0) { 
                        innerTitlesobj = new innerTitles();
                        innerTitlesobj.title = title;

                        list<innerFormats> listofinnerFormats = new list<innerFormats>();
                        innerFormats innerFormatsobj;
                        for(Format_Types__c formatTypes : title.Title_Types__r) {
                            innerFormatsobj = new innerFormats();
                            innerFormatsobj.formatType = formatTypes;
                            listofinnerFormats.add(innerFormatsobj);
                        }

                        innerTitlesobj.listofinnerFormats.addAll(listofinnerFormats);
                        listofTitlesClass.add(innerTitlesobj);
                    }
                } 
            }
        }
        sSearchStringFormat= sFormat;
        sSearchString = sTitle;
    }

    public class innerTitles {
        public Titles__c title {get;set;}
        public boolean isSelected  {get;set;}
        public list<innerFormats> listofinnerFormats {get;set;}
        public innerTitles() {
            title = new Titles__c();
            isSelected = false;
            listofinnerFormats = new list<innerFormats>();
        }
    }

    public class innerFormats {
        public Format_Types__c formatType {get;set;}
        public boolean isSelected  {get;set;}
        public innerFormats() {
            formatType = new Format_Types__c();
            isSelected = false;
        }
    }
}