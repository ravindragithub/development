public with sharing class HTS_virtual_terminal_ids {
    //use a big set to de-dupe
    set<string> SubscriptionIds = new set<string>();
    public HTS_virtual_terminal_ids(){ //constructor
      for(HTS_Virtual_Terminal_ID__c h : [SELECT Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c]){
        boolean dupeFlag = SubscriptionIds.add(h.Virtual_Terminal_Id__c); //invert logic...
        if(!dupeFlag){  //can't happen, can't test. Dupes inhibiited at database level
          system.debug('Duplicate Terminal Id Detected! : ' + h.Virtual_Terminal_Id__c);
          throw new HTSSubscriptionIdException('Duplicate Subscription Id Detected! : ' + h.Virtual_Terminal_Id__c );
        }
      }
    }
    public string generateSubscriptionIds(integer numberToCreate){
      string returnString = 'initializing';
      system.debug(returnString);
      integer numberCreated = 0;
      if(numberToCreate > 1000){
        returnString = 'Generator limited to 1000 or less';
        return returnString;
      }
      list<HTS_Virtual_Terminal_ID__c> insertList = new list<HTS_Virtual_Terminal_ID__c>();
      while(insertList.size() < numberToCreate){
        string VTID = string.valueOf(math.abs(Crypto.getRandomInteger())).left(8);
        if(VTID.length() == 8 && VTID.left(1) != '0' && VTID.right(1) != '0' ){
          boolean dupeFlag = SubscriptionIds.add(VTID);
          if(!dupeFlag){
            system.debug('Duplicate Subscription Id Detected! : ' + VTID + ' Skipping this one!');
          } else {
            insertList.add(new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = VTID));
          }
        } else {
          system.debug('Bogus Subscription Id Detected! : ' + VTID + ' Skipping this one!');
        }
      }
      insert insertList; //maybe wrapped up in a try-catch for DML exceptions.
      returnString = string.valueOf(insertList.size());
      return returnString;
    }
    public HTS_Virtual_Terminal_ID__c getNextAvailableVTID(){
      HTS_Virtual_Terminal_ID__c returnVTID = new HTS_Virtual_Terminal_ID__c();
      returnVTID = [SELECT Id, Name, Virtual_Terminal_Id__c
                    FROM HTS_Virtual_Terminal_ID__c
                    WHERE isReserved__c = false AND Date_Issued__c = null
                    ORDER BY Name ASC
                    LIMIT 1 ];
      return returnVTID;
    }
    public class HTSSubscriptionIdException extends Exception {}
}