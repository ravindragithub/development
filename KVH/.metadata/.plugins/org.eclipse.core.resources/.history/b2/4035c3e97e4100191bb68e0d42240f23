/**
* @createdby        :   Teertha prasad
* @createddate      :   04/18/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   04/18/2017
* @description      :   Class Used in Activation Terms Component To show 
*                       dynamic popup terms in page level.
**/

public class Act_Terms_Component_Controller {
    public String strPageReferenceName ;
    public Map<String, List<Activation_Terms__c>> mapActivationTerms {get; set;}
    
    public void setstrPageReferenceName(String pageReferenceName){
        if(strPageReferenceName == null || strPageReferenceName == ''){ 
            strPageReferenceName = pageReferenceName;
            loadActivationTerms();
        }
    }
    
    public String getstrPageReferenceName(){
        return strPageReferenceName; 
    }
    
    /** Constructor - Start **/
    public Act_Terms_Component_Controller(){
    }
    /** Constructor - End **/
    
    Private void loadActivationTerms(){
        mapActivationTerms = New Map<String, List<Activation_Terms__c>>();
       // system.debug('strPageReferenceName'+strPageReferenceName);        
        for(Activation_Terms__c objActivationTerm : [SELECT Id, Name, Page_Reference__c, Reference_Name__c, Quote_Term__c, Quote_Term__r.SBQQ__Body__c FROM Activation_Terms__c WHERE Page_Reference__c =: strPageReferenceName ORDER BY Reference_Name__c, Term_Display_Order__c ASC]){
            if(!mapActivationTerms.containsKey(objActivationTerm.Reference_Name__c))
                mapActivationTerms.put(objActivationTerm.Reference_Name__c, New List<Activation_Terms__c>{objActivationTerm});
            else
                mapActivationTerms.get(objActivationTerm.Reference_Name__c).add(objActivationTerm);
        }
       system.debug('mapActivationTerms' + mapActivationTerms);
    }
}