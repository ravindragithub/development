public class CommentPartnerExtension {
    public Id caseId;
    public void setcaseId (){
		caseId = ApexPages.currentPage().getParameters().get('id');
	}
	public Id getcaseId(){
		return caseId;
	}
    public string newcommentbody {get;set;}
    public CaseComment newComment1 = new CaseComment();
    public CommentPartnerExtension (ApexPages.StandardController controller) {}
    public PageReference saveComment() {
        try{
            newComment1.ParentId = ApexPages.currentPage().getParameters().get('id');
            newComment1.CommentBody = newcommentbody;
            insert newComment1; }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()));
            return null;
        }
        return new PageReference('/apex/my_Case_ViewPartner?id='+caseId);
    }
    public PageReference cancelling() {
        return new PageReference('/apex/my_Case_ViewPartner?id='+caseId);
    }
}