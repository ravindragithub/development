/****************************************************************
    Name        :        CourseProgressTriggerHandler
    Description :        It's trigger handler for skilljar__Course_Progress__c 
*****************************************************************/
public class CourseProgressTriggerHandler{
    
    /************************************************************
        Name    :    updateCSNLevel
        Description : update the CSN level of the product catelog when ever 
                        any student complete the course
    *************************************************************/
    public static void updateCSNLevel(Map<ID,skilljar__Course_Progress__c> courseMap,Map<ID,skilljar__Course_Progress__c> oldCourseMap){
        Set<String> courseIds = new Set<String>();
        Set<String> accountId = new Set<String>();
        for(skilljar__Course_Progress__c c : [Select id,skilljar__Completed_At__c,skilljar__Published_Course__c,skilljar__Contact__c,skilljar__Contact__r.AccountId from skilljar__Course_Progress__c where ID IN : courseMap.keyset()]){
            skilljar__Course_Progress__c oldObj = oldCourseMap.get(c.Id);
            if(c.skilljar__Published_Course__c != null && c.skilljar__Contact__c != null && oldObj.skilljar__Completed_At__c != c.skilljar__Completed_At__c && c.skilljar__Completed_At__c != null){
                courseIds.add(c.skilljar__Published_Course__c);
                accountId.add(c.skilljar__Contact__r.AccountId);
            }
        }
        
        if(courseIds.size()>0 && accountId.size()>0){
            Map<String,Product_Catalogue__c> updateCatalogueMap = new Map<String,Product_Catalogue__c>();
            //for basic CSN
            for(Product_Catalogue__c cat : [Select id,CSN_Level__c from Product_Catalogue__c 
                                                where Partner_Account__c IN : accountId 
                                                AND Product_Market_Sector__r.Product__r.Related_Certification_Course__c IN : courseIds
                                                AND CSN_Level__c = NULL]){
                Product_Catalogue__c catObj = updateCatalogueMap.get(cat.Id);
                if(catObj == null){                
                    catObj = cat;
                }
                cat.CSN_Level__c = 'Basic';  
                updateCatalogueMap.put(cat.Id,cat);            
            }
            
            //for Advanced CSN
            for(Product_Catalogue__c cat : [Select id,CSN_Level__c from Product_Catalogue__c 
                                                where Partner_Account__c IN : accountId 
                                                AND Product_Market_Sector__r.Product__r.Advanced_Certification_Course__c IN : courseIds
                                                AND (CSN_Level__c = NULL OR CSN_Level__c = 'Basic')]){
                Product_Catalogue__c catObj = updateCatalogueMap.get(cat.Id);
                if(catObj == null){                
                    catObj = cat;
                }
                cat.CSN_Level__c = 'Advanced';  
                updateCatalogueMap.put(cat.Id,cat);            
            }
            
            //for Master CSN
            for(Product_Catalogue__c cat : [Select id,CSN_Level__c from Product_Catalogue__c 
                                                where Partner_Account__c IN : accountId 
                                                AND Product_Market_Sector__r.Product__r.Master_Certification_Course__c IN : courseIds
                                                AND (CSN_Level__c = NULL OR CSN_Level__c = 'Basic' OR CSN_Level__c = 'Advanced')]){
                Product_Catalogue__c catObj = updateCatalogueMap.get(cat.Id);
                if(catObj == null){                
                    catObj = cat;
                }
                cat.CSN_Level__c = 'Master';  
                updateCatalogueMap.put(cat.Id,cat);            
            }
            
            if(updateCatalogueMap.size()>0)
                update updateCatalogueMap.values();
        }
    }
}