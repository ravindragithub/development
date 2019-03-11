public with sharing class my_Case_Comments_Controller {
	public List<CaseComment> cComments;
	public Id caseId;
	
	public void setcaseId (Id theCase){
		caseId = theCase;
	}
	public Id getcaseId(){
		return caseId;
	}
	
	public List<CaseComment> getcComments(){
		/*Add a NULL check here*/
		if(caseId != NULL){
			cComments = [SELECT CommentBody,CreatedBy.Name,CreatedDate FROM CaseComment 
							WHERE ParentId = :caseId AND IsPublished = True ORDER BY CreatedDate DESC NULLS FIRST];
		}
		return cComments;
	}
}