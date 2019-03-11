public Class PortalNewsDetailController{
    @AuraEnabled
    public static wrapper getNewsDetail(string releaseId){
         wrapper responsewrapper = new wrapper();
        
         HttpRequest req = new HttpRequest();
         req.setEndpoint(Label.KVH_News_Detail_End_Point+releaseId+'.xml');
         req.setMethod('GET');
         Http http = new Http();
         HTTPResponse res = new HTTPResponse();
         res = http.send(req);  
         //system.debug('@@ '+res.getBody());
         if(res.getstatuscode() == 200){        
            responsewrapper = parseResponse(res);
         }
       system.debug('@@ responsewrapper==>'+responsewrapper);
        return responsewrapper;
    }
    
    public static wrapper parseResponse(HTTPResponse res){    
        wrapper responsewrapper = new wrapper();
        //System.debug('@@ res==>'+res.getbody());   
        String xml = res.getbody();
        xml = xml.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );        
        string responsehtml = xml.substring(xml.indexOf('<ReleaseText>'),xml.indexof('</NewsReleaseText>'));
        if(responsehtml != null)
           responsewrapper.content = responsehtml.replaceAll('<ReleaseText>XML_CDATA_START','').replaceAll('XML_CDATA_END</ReleaseText>','');
      
        system.debug('responsehtml==>'+responsewrapper.content);
        
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode rootNode = doc.getRootElement();
        //System.debug('@@ rootNode==>'+rootNode );
        List<Dom.XMLNode> newscategorylst;
        if(rootNode != null){
            Dom.XMLNode NewsReleaseText = rootNode.getChildElement('NewsReleaseText',null);
            if(NewsReleaseText != null){
                for(Dom.XMLNode news: NewsReleaseText.getChildElements()){
                    String elmType = news.getName();
                    String elmValue = news.getText();
                    if(elmType == 'Title'){
                        responsewrapper.title = elmValue;
                    }else if(elmType == 'Date'){
                        responsewrapper.newsdate= elmValue;
                    }
                }
            } 
        }
        
        
        return responsewrapper;
    }
    
    public class wrapper{
        public @auraenabled string title;
        public @auraenabled string newsdate;
        public @auraenabled string content;
    }
}