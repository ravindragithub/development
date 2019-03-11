public class SpotlightComponentController{
    @Auraenabled
    public static List<ImageWrapper> getImagelist(){
        List<ImageWrapper> imagelst = new List<ImageWrapper>();
       
        for(Spotlight_Image_Configuration__c sp : [Select id,url__c,name,Description__c,(Select id,name from Attachments) from Spotlight_Image_Configuration__c  ORDER BY Sort_Order__c limit 3]){
            ImageWrapper img = new ImageWrapper();
            img.url = sp.url__c;
            img.name = sp.name;
            img.description = sp.Description__c;
            if(sp.Attachments != null && sp.Attachments.size()>0)
                img.imageURL =   +'/servlet/servlet.FileDownload?file=' + sp.Attachments[0].id;
              //  img.imageURL = 'https://jai-kvhcommunity.cs15.force.com/myKVH/servlet/servlet.FileDownload?file=' + sp.Attachments[0].id;
            imagelst.add(img);
        }
        return imagelst;
    }

    public class ImageWrapper{
        public @auraenabled String imageURL;
        public @auraenabled String url;
        public @auraenabled String name;
        public @auraenabled String description;
    }
}