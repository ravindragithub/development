public with sharing class PlatformShareCustomComponent {

    public List<myKVH_Shared_Platforms__c> lstSPRecords     {get;set;}
    public Id currentID                                     {get; set;} 
  
    public Integer intPageNumber                            {get; set;} //Used for setting page number for pagination
    public Integer intPageCount                             {get; set;} //Used for Total page count for records based on page size limit
    public Integer intPageSizeLimit                         {get; set;} //Used to set Pagination List size for records
    public Integer intTotalRecordCount                      {get; set;} //Used to store total records count
    
    private List<Id> lstRecordIds = new List<Id>();          //List for holding all Product record Ids
    
    public PlatformShareCustomComponent() {
        intPageNumber = intPageCount = intTotalRecordCount = 0;
        intPageSizeLimit = 5;
        
        lstSPRecords = new List<myKVH_Shared_Platforms__c>();
        lstRecordIds = new List<Id>();
    }
  
    public void assignCurrentUrlValue() {
        List<User> lstUers = [SELECT ID FROM USER WHERE ContactID =: currentID];
        if(lstUers.size() > 0) {
            this.loadRecordIds(lstUers[0].Id);
            this.loadRecords();   
        }
    }
    
    
    /**
    Method Name : loadRecords
    Parameter   : None
    Return Type : void
    Description : Preparing List for displaying records
    **/
    public void loadRecords() {
        lstSPRecords = new List<myKVH_Shared_Platforms__c>();

        Set<Id> setTempIds = new Set<Id>();
        
        //Calculating Total page count for records
        intPageCount = lstRecordIds.size() / intPageSizeLimit; 
        
        //Checking for records if it is beyond the total page count
        if(lstRecordIds.size() > (intPageCount * intPageSizeLimit))
            intPageCount = intPageCount + 1;
        
        //Checking for 0 or negative page number entry
        intPageNumber = intPageNumber <= 0 ? 1 : intPageNumber;    
        
        //Checking for over limit of page number
        intPageNumber = intPageNumber > intPageCount ? intPageCount : intPageNumber; 
        
        //Calculating start and end index for retrieving records from List of record Ids
        Integer intStartIndex = (intPageNumber - 1) * intPageSizeLimit;
        Integer intEndIndex = intPageNumber * intPageSizeLimit;
        
        //Preparing set of Ids for displaying records for selected page number
        for(Integer i = intStartIndex; i < intEndIndex && i > -1; i++) {
            //Checking for maximum index value based on list size of record Ids
            if(i < lstRecordIds.size())  
                setTempIds.add(lstRecordIds[i]);
        }
        
        for(myKVH_Shared_Platforms__c objSP : [SELECT Id,Shared_Platform__r.Name,Shared_Platform__r.Vessel_IMO__c,Shared_Platform__r.MMSI__c,Shared_Platform__r.myKVH_Direct_Link__c,Shared_Platform__r.Vessel_Radio_Call_Sign__c,Shared_Platform__c,User__r.Name,User__c FROM myKVH_Shared_Platforms__c WHERE Id IN : setTempIds ORDER BY Name]) {
            lstSPRecords.add(objSP);                 
        }
    }
    /* End : loadRecords Method */
    
    
    /**
    Method Name : firstPage
    Parameter   : None
    Return Type : void 
    Description : Used to retrieve first page records
    **/
    public void firstPage() {
        intPageNumber = 0;
        loadRecords();
    }
    /* End : firstPage Method */
    
    
    /**
    Method Name : lastPage
    Parameter   : None
    Return Type : void 
    Description : Used to retrieve last page records
    **/
    public void lastPage() {
        intPageNumber = intPageCount;
        loadRecords();
    }
    /* End : lastPage Method */
    
    
    /**
    Method Name : nextPage
    Parameter   : None
    Return Type : void 
    Description : Used to retrieve next page records
    **/
    public void nextPage() {
        intPageNumber++;
        loadRecords();
    }
    /* End : nextPage Method */
    
    
    /**
    Method Name : previousPage
    Parameter   : None
    Return Type : void 
    Description : Used to retrieve previous page records
    **/
    public void previousPage() {
        intPageNumber--;
        loadRecords();
    }
    /* End : previousPage Method */
    
    
    /**
    Method Name : goToPage
    Parameter   : None
    Return Type : void 
    Description : Used to retrieve selected page records
    **/
    public void goToPage() {
        loadRecords();
    }
    /* End : goToPage Method */
    
    
    /**
    Method Name : loadRecordIds
    Parameter   : None
    Return Type : void
    Description : Preparing Set of Ids for all records 
    **/
    private void loadRecordIds(Id userId) {
        lstRecordIds = new List<Id>();
        
        for(myKVH_Shared_Platforms__c objSP : [SELECT Id, Shared_Platform__c, User__c FROM myKVH_Shared_Platforms__c WHERE User__c =: userId]) {
            lstRecordIds.add(objSP.Id);            
        }
        
        intTotalRecordCount = lstRecordIds.size();
    }
    /* End : loadRecordIds method */
}