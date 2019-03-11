global virtual with sharing class ActivationsBaseController {               //must be global due to RemoteActions
    //Common Page attributes
    public string ActivationOrderId {get;set;}                              //should be a Q param with page request
    public string ActOrdQuery ='';                                          //Standard Query for an Activation ORder
    public Activation_Status__c ActivationStatus {get;set;}                 //Utility Class returns a list of Status Records
    
 /*   @RemoteAction       
    global static void updateSubscriber(string ActOrdId, String tabName, string formJSON) { //Try Passing in the WHOLE Subscriber sObject!
        system.debug('Javascript Remote Action updateSubscriber inputs : ' + ActOrdId + ': ' + tabName);
        system.debug('JSON String representing form data: ' + formJSON);
        //handle update to Subscriber...
        list<Activation_Subscriber__c> existingSubscribers = [SELECT Id FROM Activation_Subscriber__c WHERE Activation_Order__c =: ActOrdId];
        Activation_Subscriber__c fromJSON = (Activation_Subscriber__c)JSON.deserialize(formJSON, Activation_Subscriber__c.class);
        system.debug('Created from JSON string: ' + fromJSON);
        if(existingSubscribers.size() != 0){                //Does the Subscriber record already exist?
            fromJSON.Id = existingSubscribers[0].Id;        //YES! Use the Id with the Form Data for UPSERT
        } else {                                            
            fromJSON.Activation_Order__c = (Id)ActOrdId;    //NO! Populate the required field and INSERT (via UPSERT!)
        }
        system.debug('JSON derived sObject: ' + fromJSON);
        upsert fromJSON;
        //handle update to Status....
        Activation_Status__c existingStatus = [SELECT Id, Activation_Order__c, Subscriber_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrdId LIMIT 1];
        system.debug(existingStatus);
        system.debug(tabName);
        existingStatus.Subscriber_Active_Tab__c = tabName;
        upsert existingStatus;
    }
    @RemoteAction       
    global static void updateStatus(string ActOrdId, String tabName){ //TODO more generic??!!
        system.debug('Javascript Remote Action updateStatus inputs. Order Id: ' + ActOrdId + ' Tab Name: ' + tabName);
        //handle update to Status....
        Activation_Status__c existingStatus = [SELECT Id, Activation_Order__c, Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrdId LIMIT 1];
        system.debug(existingStatus);
        system.debug(tabName);
        existingStatus.Account_Setup_Active_Tab__c = tabName;
        upsert existingStatus;
    } */

    //Constructor
    public ActivationsBaseController(){
        //Setup Activation Order STatus Query string...
        ActOrdQuery = 'SELECT Id, Name, Activation_Order__c, Active_Page__c, First_Review_Page__c, ';         //fundamental fields and 7 pages...
        ActOrdQuery += 'Account_Setup_page__c, Account_Setup_Active_Tab__c,Account_Setup_Last_Active_Tab_Index__c, ';          //1
        ActOrdQuery += 'Installation_Type_Page__c, Installation_Type_Active_Tab__c, Installation_Type_Last_Active_Tab_Index__c, ';  //2
        ActOrdQuery += 'System_Page__c, System_Active_Tab__c, System_Type_Last_Active_Tab_Index__c, ';                        //3
        ActOrdQuery += 'Services_Page__c, Services_Active_Tab__c, Services_Type_Last_Active_Tab_Index__c, ';                    //4
        ActOrdQuery += 'Contract_Details_Page__c, Contract_Details_Active_Tab__c, Contract_Details_Last_Active_Tab_Index__c, ';          //5
        ActOrdQuery += 'OneCare_Page__c, OneCare_Active_Tab__c, OneCare_Last_Active_Tab_Index__c, ';                      //6
        ActOrdQuery += 'Activate_Page__c, Activate_Active_Tab__c ';                     //7
        ActOrdQuery += 'FROM Activation_Status__c ';                                    //AAAAND the source Object
    }
    //Helper methods commonly used in the On Line Activations app

    //Return a list of Activation Statuses given a list of Activation Order Ids
    public list<Activation_Status__c> getActivationStatus (list<Activation_Order__c> ActOrdList){
        //There should be only one STatus for Each Activation Order
        //Check for null return value
        map<Id, Activation_Order__c> ActOrdMap = new map<Id, Activation_Order__c>(ActOrdList);
        set<Id> ActOrdkeyset = ActOrdMap.keySet();
        list<Activation_Status__c> returnList = new list<Activation_Status__c>();
        returnList = Database.query(ActOrdQuery + 'WHERE Activation_Order__c IN: ActOrdkeyset');
        return returnList;
    }
    //Return a single Activation Status given a single Activation Order Id
    public Activation_Status__c readActivationStatus(string orderId){
        Activation_Status__c returnStatus = new Activation_Status__c();                         //setup return object
        list<Activation_Status__c> returnList = new list<Activation_Status__c>();
        returnList = Database.query(ActOrdQuery + 'WHERE Activation_Order__c =: orderId');
        //TODO: handle multiple returns
        returnStatus = returnList[0];
        return returnStatus;                                                                    //return the one status object
    }
    /* Next/Prev are deprecated - Tab State is text based */
    public integer next(integer s, integer MAX_TAB_STATE){                                      //state engine, forward direction
        system.debug('next() input: ' +  string.valueOf(s));
        s = s + 1;
        //Max state value...A Controller Constant???
        if(s >= MAX_TAB_STATE + 1){
            s = MAX_TAB_STATE;
        }
        system.debug('next() output: ' +  string.valueOf(s));
        return s;
    }
    public integer prev(integer s){                                                             //state engine, reverse direction
        system.debug('prev() input: ' +  string.valueOf(s));
        s = s - 1;
        //Min state value....A Controller Constant??? NO! ZERO! THE END!!
        if(s <= 0){
            s = 1;
        }
        system.debug('prev() output: ' +  string.valueOf(s));
        return s;
    }
}