public with sharing class ControllerAssignTitlesToQuoteCharge {
        public invoiceit_s__Quote_Rate_Plan_Charge__c quoteCharge{get;set;}
        public list<innerTitles> listofTitlesClass {get;set;}
        innerTitles innerTitlesobj;
        public map<Integer, Quote_Charge_Titles__c> mapOfquoteChargeTitles {get;set;}
        list<Quote_Charge_Titles__c> listofQuoteTitleTodelete = new list<Quote_Charge_Titles__c>();
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

        public ControllerAssignTitlesToQuoteCharge(ApexPages.StandardController controller) {
                listofTitle = new list<Titles__c>();
                quoteCharge = (invoiceit_s__Quote_Rate_Plan_Charge__c)controller.getRecord();
                sSearchString = '';
                sSearchStringFormat = '';
                quoteCharge = [select name,invoiceit_s__Quote__c,invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Quote__r.invoiceit_s__Account__c,invoiceit_s__Quote__r.Name,invoiceit_s__Quote__r.invoiceit_s__Status__c
                               ,Count_Of_Titles__c,invoiceit_s__Quote__r.invoiceit_s__Account__c,invoiceit_s__Quantity__c
                               ,invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product_Code__c,invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name
                               ,invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.invoiceit_s__Product__r.invoiceit_s__Product_Family__c,invoiceit_s__Quote__r.Wet_or_Dry_Cargo__c,
                               invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name,invoiceit_s__Quote__r.Quote_Type_KVH__c,invoiceit_s__Quote__r.Platform_or_Vessel_detail__c
                               From invoiceit_s__Quote_Rate_Plan_Charge__c
                               Where id =:quoteCharge.id];

                sQueryStatic = 'SELECT Name,Included_in_VOD__c,Series__c,Title_Platform_Detail__c,Platform_Type__c,BMS_Code__c,(SELECT Name,Regional_Format__c,Delivery_Method_s__c, Format__c, Language__c FROM Title_Types__r WHERE Status__c = \'Current\' ';

                If(quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'Rental Library' || quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Sale') {
                        sQueryStatic = sQueryStatic + 'AND Delivery_Method_s__c includes(\'DVD\',\'VHS\', \'CD-ROM\')';
                } else if(quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' || quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'NVOD') {
                        sQueryStatic = sQueryStatic + 'AND Delivery_Method_s__c includes(\'VOD G2\')';
                } 

                sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c ';

                if(quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Full VOD') {
                        sQueryStaticTitles = sQueryStaticTitles + 'WHERE Included_in_VOD__c includes(\'Full VOD\')';
                        if(quoteCharge.invoiceit_s__Quote__r.Wet_or_Dry_Cargo__c != null) {
                                string sWetorDry = '\'' + quoteCharge.invoiceit_s__Quote__r.Wet_or_Dry_Cargo__c.replaceAll(';', '\',\'') + '\'';
                                sQueryStaticTitles = sQueryStaticTitles + ' AND Platform_Type__c includes(' + sWetorDry +')';
                        }
                } else if((quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD' || quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD') && quoteCharge.invoiceit_s__Quote__r.Platform_or_Vessel_detail__c != null) {
                        sQueryStaticTitles = sQueryStaticTitles + 'WHERE Title_Platform_Detail__c includes(\'' +quoteCharge.invoiceit_s__Quote__r.Platform_or_Vessel_detail__c + '\')';
                }

                sQuery = sQuery + sQueryStaticTitles + ' ';
                getTitles();
                for( Titles__c title : listofTitle ) {
                        if(title.Title_Types__r.size() > 0) { 
                                innerTitlesobj = new innerTitles();
                                innerTitlesobj.title = title;
                                If(! (quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                                                && quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental')) {
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

                list<Quote_Charge_Titles__c> listofCharges = [SELECT Id,Quote_Rate_Plan_Charge__c ,Titles__c,Format_Type__c  FROM Quote_Charge_Titles__c WHERE Quote_Rate_Plan_Charge__c =:quoteCharge.Id ];         
                mapOfquoteChargeTitles = new map<Integer, Quote_Charge_Titles__c>();                 
                integer iCounter = 0;
                for(Quote_Charge_Titles__c chargeTitles : listofCharges ) {
                        iCounter++;
                        mapOfquoteChargeTitles.put(iCounter, chargeTitles);
                        setOfTitles.add(chargeTitles.Titles__c);
                }

                if((quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD' 
                                || quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD'
                                        || quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Flexi VOD')
                                        &&  quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental' && quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD') {
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
                                If(! (quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                                        && quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental')) {
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
                map<Integer, Quote_Charge_Titles__c> mapOfquoteChargeTitlesLoc = new map<Integer, Quote_Charge_Titles__c>();
                integer iCounter = mapOfquoteChargeTitles.size();
                integer iQuantity = Integer.valueOf(quoteCharge.invoiceit_s__Quantity__c);
                boolean isSelectedQuantityMore = false;
                for(innerTitles innerTitleObj : listofTitlesClass) {
                        if(innerTitleObj.isSelected) {
                                setOfTitles.add(innerTitleObj.title.Id);

                                if(((((quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Mini VOD' && setOfTitles.size() > 50)
                                                || (quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Midi VOD' && setOfTitles.size() > 5)
                                                || (quoteCharge.invoiceit_s__Product_Rate_Plan_Charge__r.invoiceit_s__Product_Rate_Plan__r.Name == 'Flexi VOD' && setOfTitles.size() > 30))
                                                &&  quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental' && quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD'))
                                                || (quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental' && quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'Rental Library' && setOfTitles.size() > 50)
                                                )
                                {
                                        isSelectedQuantityMore = true;
                                }

                                If(quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                                        && quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental') {
                                        iCounter++;
                                        mapOfquoteChargeTitlesLoc.put(iCounter, new Quote_Charge_Titles__c (Quote_Rate_Plan_Charge__c =quoteCharge.Id, Titles__c = innerTitleObj.title.Id ) );          
                                }

                                for(innerFormats innerFormats : innerTitleObj.listofinnerFormats ) {
                                        if(innerFormats.isSelected) {
                                                if(iQuantity == iCounter && (!( ( quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' || quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'Rental Library') && quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental'))) {
                                                        isSelectedQuantityMore = true;
                                                }
                                                iCounter++;
                                                mapOfquoteChargeTitlesLoc.put(iCounter, new Quote_Charge_Titles__c (Format_Type__c = innerFormats.formatType.Id, Quote_Rate_Plan_Charge__c =quoteCharge.Id, Titles__c = innerTitleObj.title.Id ) );
                                                innerFormats.isSelected = false;
                                        }
                                }
                                innerTitleObj.isSelected = false;

                        }
                }  
                /*if(isSelectedQuantityMore) {
                        mapOfquoteChargeTitlesLoc.clear();
                        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'The Selected titles are more than charge quantity');
                        Apexpages.addMessage(infoMessage);
                } */
                mapOfquoteChargeTitles.putAll(mapOfquoteChargeTitlesLoc); 

                setOfTitles = new set<Id>();
                for(Quote_Charge_Titles__c quoteChargeTitle : mapOfquoteChargeTitles.values()) {
                        setOfTitles.add(quoteChargeTitle.Titles__c);
                }
                quoteCharge.Count_Of_Titles__c = setOfTitles.size(); 
        }

        public void removeTitles() {
                integer iCounterToRemove = Integer.valueOf(apexpages.currentpage().getparameters().get('removeTitles'));
                Quote_Charge_Titles__c titles = mapOfquoteChargeTitles.get(iCounterToRemove);
                if(titles.Id != null)
                        listofQuoteTitleTodelete.add(new Quote_Charge_Titles__c(Id = titles.Id));
                mapOfquoteChargeTitles.remove(iCounterToRemove);

                if(isVOD) { 
                        setOfTitles = new set<Id>();
                        for(Quote_Charge_Titles__c quoteChargeTitle : mapOfquoteChargeTitles.values()) {
                                setOfTitles.add(quoteChargeTitle.Titles__c);
                        }
                }
        }

        public void saveTitles() {
                saveTitlesAndRedirect();
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'The records have saved successfully.');
                Apexpages.addMessage(infoMessage);
        }

        public pagereference saveTitlesAndRedirect() {
                upsert mapOfquoteChargeTitles.values();
                delete listofQuoteTitleTodelete;


                set<Id> setOfTitels = new set<Id>(); 
                for(Quote_Charge_Titles__c quoteCharge : mapOfquoteChargeTitles.values()) {
                        setOfTitels.add(quoteCharge.Titles__c);
                }

                if(quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'Training Titles') {
                        list<Titles__c> listofTitles = [SELECT List_Price__c FROM Titles__c WHERE Id in: setOfTitels AND List_Price__c != null];
                        Decimal dSumOfTitlesAmount = 0;
                        for (Titles__c Titles : listofTitles) {
                                dSumOfTitlesAmount = dSumOfTitlesAmount + Titles.List_Price__c;
                        }
                        quoteCharge.invoiceit_s__Unit_Price__c = dSumOfTitlesAmount;
                }

                quoteCharge.Count_Of_Titles__c = setOfTitels.size();
                update quoteCharge;

                invoiceit_s__Quote__c quoteObj = new invoiceit_s__Quote__c(Id = quoteCharge.invoiceit_s__Quote__c,  invoiceit_s__Recalculate__c = true);
                update quoteObj;

                pagereference orderPage = new pagereference('/'+quoteCharge.invoiceit_s__Quote__c);  
                return orderPage;
        }

        public void searchTitles() {
                sQuery = '';
                string s =  sSearchString;
                sSearchString = '%' +sSearchString+ '%';

                if(sQueryStaticTitles == '') {
                        sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c WHERE Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString ';
                } else {
                        sQuery = sQueryStatic + '),CODE_NO__c FROM Titles__c ' + sQueryStaticTitles + ' AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString ) ';
                }

                getTitles(); 

                if(!listofTitle.isEmpty()) {
                        for( Titles__c title : listofTitle ) {
                                if(title.Title_Types__r.size() > 0) { 
                                        innerTitlesobj = new innerTitles();
                                        innerTitlesobj.title = title;
                                        If(! (quoteCharge.invoiceit_s__Quote_Rate_Plan__r.invoiceit_s__Quote_Product__r.invoiceit_s__Product__r.Name == 'VOD' 
                                                        && quoteCharge.invoiceit_s__Quote__r.Quote_Type_KVH__c == 'Rental')) {
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
                                        sQuery = sQueryStatic + ' AND Id In:listofFormatTypes ),CODE_NO__c FROM Titles__c WHERE Id in: setofTitleFormat AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString ) ';
                                } else {
                                        sQuery = sQueryStatic + ' AND Id In:listofFormatTypes ),CODE_NO__c FROM Titles__c ' + sQueryStaticTitles + ' AND Id in: setofTitleFormat AND ( Name LIKE: sSearchString OR Series__r.Name LIKE: sSearchString ) ';
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