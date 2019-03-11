public with sharing class CustomIterableForTitles {
	
	public list<Titles__c> listofTitles; // This is the main list which has all the rate plans for particular product
    public list<Titles__c> listofTitlesRequested;
    public Integer i {get; set;} // Here i point to the index (or) position of elements
    public Integer setPageSize; // No of records to display in page
    public integer size;

    public CustomIterableForTitles(list<Titles__c> listoftitle) { 
        listofTitles = listoftitle;
        // Were getting the value from custom settings, based on value we are displaying the records
        setPageSize = 100;
        i = 0; 
        size = listofTitles.size();
    }   
    
    // Method will verify does it has next set of records
    public boolean hasNext(){ 
       if(i >= listofTitles.size()) {
           return false; 
       } else {
           return true; 
       }
   }
   
   // Method will verify does it has next set of records
   public boolean hasPrevious(){ 
       if(i <= setPageSize) {
           return false; 
       } else {
           return true; 
       }
   }  
   
   // This will display the next set of records
   public list<Titles__c> next(){       
       size = listofTitles.size();
       listofTitlesRequested = new list<Titles__c>(); 
       integer startNumber;
       integer iDisplaySize;
       if(hasNext())
       {  
           if(size <= (i + setPageSize))
           {
               startNumber = i;
               i = size;
           }
           else
           {
               i = (i + setPageSize);
               startNumber = (i - setPageSize);
           }
           
           for(integer start = startNumber; start < i; start++)
           {
               listofTitlesRequested.add(listofTitles[start]);
           }
       } 
       return listofTitlesRequested;
   } 
   
   // This will display the previous set of records
   public list<Titles__c> previous(){ 
       size = listofTitles.size();     
       listofTitlesRequested = new list<Titles__c>(); 
       
       if(i == size)
       {
           if(math.mod(size, setPageSize) > 0)
           {    
               i = size - math.mod(size, setPageSize);
           }
           else
           {
               i = (size - setPageSize);
           }         
       }
       else
       {
           i = (i - setPageSize);
       }
       // If the pointer index exceeds the size return the first elements
       if((i - setPageSize) > 0) {
            for(integer start = (i - setPageSize); start < i; ++start)
           {
               listofTitlesRequested.add(listofTitles[start]);
           }
       } else {
          return first();
       }
       return listofTitlesRequested;
   }
   
    public list<Titles__c> first(){
        i = 0;
        return next();
    }
    
    // This will display the last set of records
    public list<Titles__c> last(){
        size = listofTitles.size();
        i = size; 
        listofTitlesRequested = new list<Titles__c>(); 
        
        integer max;

        if(i >= setPageSize) {
            max = i - setPageSize;
        } else {
            max = i;
        }
        
        for(integer start = max; start < i; ++start)
        {
           listofTitlesRequested.add(listofTitles[start]);
        }         
       return listofTitlesRequested;
    }
}