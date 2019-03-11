public class SpolightImageConfigurationCtrl{
    public List<SpotlightWrapper> imagelst{get;set;}
    public Integer rownumber{get;set;}
    
    public SpolightImageConfigurationCtrl(){
        
        init();
    }
    
    private void init(){
        imagelst = new List<SpotlightWrapper>();
        for(Spotlight_Image_Configuration__c sp : [Select id,url__c,name,Description__c,Sort_Order__c,(Select id,name from Attachments) from Spotlight_Image_Configuration__c ORDER BY Sort_Order__c]){
            imagelst.add(new SpotlightWrapper(sp));
        }
        
        addSpotlight();
    }
    
    private void addSpotlight(){
        integer count = 3-imagelst.size();
        for(integer i = 1;i<=count ;i++){
            imagelst.add(new SpotlightWrapper(new Spotlight_Image_Configuration__c()));
        }
    }
    
    public void saveRecords(){
        if(imagelst.size()>0){
            List<Spotlight_Image_Configuration__c> insertlst = new List<Spotlight_Image_Configuration__c>();
            for(SpotlightWrapper sp : imagelst){
                Spotlight_Image_Configuration__c spotlight = new Spotlight_Image_Configuration__c();
                spotlight = sp.spotlight;
                if(sp.spotlight.Name != null){
                    insertlst.add(spotlight);
                }
            }
            
            if(insertlst.size()>0){
                upsert insertlst;
            }
            //insert attachments
            List<Attachment> attlst = new List<Attachment>();
            Set<String> parentIDs = new Set<String>();
            for(SpotlightWrapper sp : imagelst){                
                if(sp.file != null){
                    attlst.add(new Attachment(body = sp.file,name = sp.filename,parentid = sp.spotlight.id));
                    sp.file = null;
                    parentIDs.add(sp.spotlight.id);
                }
            }
            //delete old attachments
            if(parentIDs.size()>0){
                List<Attachment> deleteAttachmentlist = [Select id from Attachment where parentid  IN : parentIDs];
                if(deleteAttachmentlist.size()>0)
                    delete deleteAttachmentlist;
            }
                
            if(attlst.size()>0)
                insert attlst;
        }
        init();
    }
    
    public class SpotlightWrapper{
        public Spotlight_Image_Configuration__c spotlight{get;set;}
        public Blob file{get;set;}
        public String filename{get;set;}
        
        public SpotlightWrapper(Spotlight_Image_Configuration__c spotlight){
            this.spotlight = spotlight;
        }
    }
    
    public void deleteSpotlight(){
        SpotlightWrapper sp = imagelst.remove(rownumber);
        if(sp.spotlight.Id != null){
            List<Spotlight_Image_Configuration__c> deletelst = [Select id from Spotlight_Image_Configuration__c  where ID =: sp.spotlight.Id];
            if(deletelst.size()>0)
                delete deletelst;
        }
        addSpotlight();
    }
}