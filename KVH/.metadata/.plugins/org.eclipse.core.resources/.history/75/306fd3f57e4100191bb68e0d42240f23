public with sharing class CountryStateMethods { 
    public map<String, KVH_Countries__mdt> CountryMap = new map<String, KVH_Countries__mdt>();                     //Use to lookup Countries by ISO Code 2
    Set<string> lstCountry = new Set<string>();
    /*Deprecated Method*/
    public map<String, KVH_Countries__mdt> buildCountryMap(Set<string> lstCountryISO){ 
        return getCountryMap(lstCountryISO);
    }
    /*End Deprecated */
    
    //Constructor
    public CountryStateMethods(){
        CountryMap = getCountryMap(lstCountry);
    }
    
    public map<String, KVH_Countries__mdt> getCountryMap(Set<string> lstCountryISO){
        //create a map of just <ISO_Code_2, Country>
        map<String, KVH_Countries__mdt> returnMap = new map<String, KVH_Countries__mdt>();
        for(KVH_Countries__mdt c : [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt 
                                            WHERE IsoCode_2__c =: lstCountryISO
                                            ORDER BY TrimmedName__c ASC]){
            returnMap.put(c.IsoCode_2__c, c);                   
        }
        return returnMap;
    }
    public map<String, KVH_Countries__mdt> getNamedCountryMap(){
        //create a map of just <ISO_Code_2, Country>
        map<String, KVH_Countries__mdt> returnMap = new map<String, KVH_Countries__mdt>();
        for(KVH_Countries__mdt c : [SELECT Id, TrimmedName__c, IsoCode_2__c, IsoCode_3__c FROM KVH_Countries__mdt 
                                            //WHERE IsoCode_2__c = 'US' OR IsoCode_2__c = 'CA'          //just for testing...
                                            ORDER BY TrimmedName__c ASC]){
            returnMap.put(c.TrimmedName__c, c);                                                           //Populate the Country Map
            //KVHCountryStateMap.put(c, new list<KVH_States__mdt>());                                       //initialize the State Map!
        }
        return returnMap;
    }
    public map<String, KVH_States__mdt> getStateMap(Set<string> lstCountryISO){
        //create a map of just <FullIsoCode__c, Country>
        map<String, KVH_States__mdt> returnMap = new map<String, KVH_States__mdt>();
        for(KVH_States__mdt c : [SELECT Id, TrimmedName__c, FullIsoCode__c, CountryIsoCode_2__c, IsoCode__c FROM KVH_States__mdt 
                                            WHERE CountryIsoCode_2__c =: lstCountryISO
                                            ORDER BY CountryIsoCode_2__c ASC]){
            returnMap.put(c.FullIsoCode__c, c);                                       
        }
        return returnMap;
    }
    
    public map<String, KVH_States__mdt> getNamedStateMap(Set<string> lstCountryISO){
        //create a map of just <FullIsoCode__c, Country>
        map<String, KVH_States__mdt> returnMap = new map<String, KVH_States__mdt>();
        for(KVH_States__mdt c : [SELECT Id, TrimmedName__c, FullIsoCode__c, CountryIsoCode_2__c, IsoCode__c FROM KVH_States__mdt 
                                            WHERE CountryIsoCode_2__c =: lstCountryISO
                                            ORDER BY CountryIsoCode_2__c ASC]){
            returnMap.put(c.CountryIsoCode_2__c.Trim()+'@@'+ c.TrimmedName__c.Trim(), c);                                                           //Populate the State Map
        }
        return returnMap;
    }
    
    //CountriesList with +1 overloaded setters!
    public list<selectOption> setupCountryPicklist(){
        //SelectOption option = new SelectOption(value, label);
        list<SelectOption> returnList = new list<SelectOption>();
        List<KVH_Countries__mdt> lstKVHCountry = new List<KVH_Countries__mdt>([SELECT Id, TrimmedName__c,MasterLabel, IsoCode_2__c FROM KVH_Countries__mdt ORDER BY TrimmedName__c ASC]);
        returnList.add(new SelectOption('Choose One', 'Choose One'));
        //read the countries and ISO codes...
        for(KVH_Countries__mdt c : lstKVHCountry ){
            returnList.add(new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));
        }
        return returnList;
    }
    public list<selectOption> setupCountryPicklist(String CountryISOCode){
        //SelectOption option = new SelectOption(value, label);
        list<SelectOption> returnList = new list<SelectOption>();
        returnList.add(new SelectOption('Choose One', 'Choose One'));
        //read the countries and ISO codes...
        List<KVH_Countries__mdt> lstKVHCountry = new List<KVH_Countries__mdt>([SELECT Id, TrimmedName__c,MasterLabel, IsoCode_2__c FROM KVH_Countries__mdt ORDER BY TrimmedName__c ASC]);
        for(KVH_Countries__mdt c : lstKVHCountry ){
            returnList.add(new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));
            if(c.IsoCode_2__c == CountryISOCode){
                returnList.add(0, new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));                      //put this one at the top too!
            }
        }
        return returnList;
    }
    //StatesList with +2 overloaded setters!
    public list<SelectOption> setupStatesPicklist(){
        system.debug('Invoking setupStatesPicklist with no parameters');
        list<SelectOption> returnList = new list<SelectOption>();
        returnList.clear();                                             //clear it out first...
        returnList.add(new SelectOption('Choose Country First', 'Choose Country First'));
        return returnList;
    }
    public list<SelectOption> setupStatesPicklist(string CountryISOCode){
        system.debug('Invoking setupStatesPicklist with: ' + CountryISOCode);
        list<SelectOption> returnList = new list<SelectOption>();
        returnList.clear();                                             //clear it out first... 
        returnList.add(new SelectOption('Choose One', 'Choose One'));
        List<KVH_States__mdt > lstKVHState = new List<KVH_States__mdt >([SELECT MasterLabel, TrimmedName__c, CountryIsoCode_2__c, Id FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: countryISOCode ORDER BY TrimmedName__c ASC]);
        for(KVH_States__mdt s : lstKVHState ){
            returnList.add(new SelectOption(s.TrimmedName__c, s.TrimmedName__c));
        }
        system.debug('Number of States returned: ' + returnList.size());
        if(returnList.size() == 1){                                 //There's NO states for the selected country
            returnList.clear();                                     //clear it out first...
            returnList.add(new SelectOption('n/a', 'n/a', true));   //do not allow a selection
        } else if(returnList.size() == 2){                          //only ONE state! who knew!
            returnList.remove(0);                                   //remove that 'choose one' option...
        }
        return returnList;
    }
    public list<SelectOption> setupStatesPicklist(string countryISOCode, string namedState){
        //SelectOption option = new SelectOption(value, label);
        system.debug('Invoking setStatesList with: ' + countryISOCode + ' and: ' + namedState);
        list<SelectOption> returnList = new list<SelectOption>();
        returnList.clear();                                             //clear it out first...
        returnList.add(new SelectOption(namedState, namedState));       //set the top of the list...
        for(KVH_States__mdt s : [SELECT MasterLabel, TrimmedName__c, CountryIsoCode_2__c, Id 
                                 FROM KVH_States__mdt
                                 WHERE CountryIsoCode_2__c =: countryISOCode]){
            returnList.add(new SelectOption(s.TrimmedName__c, s.TrimmedName__c));
        }
        return returnList;
    }
    /* change method to generic version
     * require parameters for Country and State (state may be null!)
     * return list<SelectOption> of States */
    public list<SelectOption> CountryChangeHandler(string ISO2CountryCode, string StateTrimmedName){
        list<SelectOption> returnList = new list<SelectOption>();               //setup return list
        system.debug('Invoking Country Change Handler with: ' + ISO2CountryCode + ' And: ' + StateTrimmedName);
        if(ISO2CountryCode != null){    //Subscriber Country is normally populated.
            list<KVH_States__mdt> filteredStates = [SELECT TrimmedName__c FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: ISO2CountryCode ORDER BY TrimmedName__c ASC];
            //Four condition...NO WAIT 5 (five) conditions!!
            if(StateTrimmedName == null && ISO2CountryCode.left(6) != 'choose'){//previously selected country had zero states!
                returnList = setupStatesPicklist(ISO2CountryCode);
            } else if(ISO2CountryCode.left(6) != 'choose' && StateTrimmedName.left(6) != 'choose'){
                system.debug('Need to Validate State Picklist with: ' + ISO2CountryCode + ' and: ' + StateTrimmedName); //Previously selected State?? Check for valid state!
                if(filteredStates.size() == 0){//"no states" condition
                    system.debug('Not so cool... Country and State do not correspond!');
                    returnList = setupStatesPicklist(ISO2CountryCode);
                } else {
                    Boolean CountryAndStateCorrespond = false;
                    for(KVH_States__mdt c :filteredStates){ //maybe use a map instead of looping?
                        if(c.TrimmedName__c == StateTrimmedName){
                            system.debug('We are cool, Country and State in alignment!');
                            CountryAndStateCorrespond = true;
                            break;
                        }
                    }
                    if (CountryAndStateCorrespond){
                        returnList = setupStatesPicklist(ISO2CountryCode, StateTrimmedName);
                    } else {
                        returnList = setupStatesPicklist(ISO2CountryCode);
                    }
                }
            } else if(ISO2CountryCode.left(6) == 'choose' /*&& StateTrimmedName.left(10) != 'choose cou'*/){//handles "null" StateTrimmedName
                system.debug('Need to Default Country and State Picklist...');                              //Country got set back to "Choose" after a state was chosen
                //SubscriberCountriesList = setupCountryPicklist();
                returnList = setupStatesPicklist(); //setup with no params
            } else if (ISO2CountryCode.left(6) != 'choose' && StateTrimmedName.left(6) == 'choose'){
                system.debug('Need to Setup State Picklist with: ' + ISO2CountryCode);      //Country Chosen, setup States Picklist
                returnList = setupStatesPicklist(ISO2CountryCode);
            } else { // .... and a WTF!?
                //SubscriberCountriesList = setupCountryPicklist();
                returnList = setupStatesPicklist();
            }
        } else { //Billing Country == null.... another WTF!?.... but rather then throwing a null exception error, check first!
            //SubscriberCountriesList = setupCountryPicklist();
            returnList = setupStatesPicklist();
        }
        return returnList;
    }
}