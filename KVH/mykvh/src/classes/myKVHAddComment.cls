public class myKVHAddComment {
    string body;
    Id ca; //case Id
    public Attachment attach {get;set;}
    public myKVHAddComment(ApexPages.StandardController controller){
        ca = controller.getId();
        attach = new Attachment();
	}
    public void InsertAttachment(Id caseId) {
        if(attach.Body==null || attach.Name==null) //if there actually is an attachment
        {
            return;
        }
        attach.ParentId = caseId;
        insert attach;
    }
    public PageReference saveComment(){
        CaseComment cc = new CaseComment();
        cc.CommentBody = body;
        cc.ParentId = ca;
        insert cc;
        InsertAttachment(ca);
        //String URL = Label.Community_URL;
        //string comm = Label.Community_Prefix;        
        string urlstr= URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pageref = new PageReference(Label.myKVH_community_url +'mykvh-case-view?recordid=' + ca);
        return pageref;
    }
    public PageReference goback(){
        //String URL = Label.Community_URL;
        //string comm = Label.Community_Prefix;
        string urlstr= URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pageref = new PageReference(Label.myKVH_community_url +'mykvh-case-view?recordid=' + ca);
        return pageref;
    }
    //shortened get set did not work.
    public string getbody(){
        return body;
    }
    public void setbody(string bod){
        body = bod;
    }
}