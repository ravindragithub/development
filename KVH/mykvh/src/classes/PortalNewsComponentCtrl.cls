public class PortalNewsComponentCtrl{
    
    @AuraEnabled
    public static List<NewsWrapper> getNewslist(){
         List<NewsWrapper> newslst = new List<NewsWrapper>();
         HttpRequest req = new HttpRequest();
         req.setEndpoint(Label.KVH_News_Feed_End_Point);
         req.setMethod('GET');
         Http http = new Http();
         HTTPResponse res = new HTTPResponse();
         res = http.send(req);         
         if(res.getstatuscode() == 200){        
            newslst = parseResponse(res);
         }
       
        return newslst ;
    }
    
    public static List<NewsWrapper> parseResponse(HTTPResponse res){       
        List<NewsWrapper> newslist = new List<NewsWrapper>();
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode rootNode = doc.getRootElement();
        //System.debug('@@ rootNode==>'+rootNode );
        List<Dom.XMLNode> newscategorylst;
        if(rootNode != null){
            Dom.XMLNode NewsReleases = rootNode.getChildElement('NewsReleases',null);
            if(NewsReleases != null){
                newscategorylst = NewsReleases.getChildElements();
            } 
        }
        System.debug('@@ newscategorylst ==>'+newscategorylst.size());
        if(newscategorylst != null && newscategorylst.size()>0){
            for(Dom.XMLNode newscategory : newscategorylst){
                String category = newscategory.getAttribute('Category',null);
                for(Dom.XMLNode newsnode : newscategory.getChildElements()){
                    NewsWrapper news = new NewsWrapper();
                    news.ReleaseID = newsnode.getAttribute('ReleaseID',null);
                    news.category = category;
                    for(Dom.XMLNode cnode : newsnode.getChildElements()){
                        String elmType = cnode.getName();
                        String elmValue = cnode.getText();
                        if(elmType == 'Title'){
                            news.Title = elmValue;
                        }else if(elmType == 'ExternalURL'){
                            news.ExternalURL = elmValue;
                        }else if(elmType == 'Date'){
                            news.newsdate = elmValue;
                        }
                    }
                    newslist.add(news);
                }
            }
        }
        return newslist;
    }
    
     
    public class NewsWrapper{
        public @AuraEnabled String Title;
        public @AuraEnabled String ExternalURL;
        public @AuraEnabled String newsdate;  
        public @AuraEnabled String category;  
        public @AuraEnabled String ReleaseID;            
    }
}