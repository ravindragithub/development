public class Act_Static_IP_Component_Controller {
    
    public Activation_Service__c objActivationService ;
    private static String strPlanName 	=	'Optional Plans & Services';
    private static String strFeatureName = 'Global Static IP Service';
    public String strFeatureIds 	{get; set;} 
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){ 
            objActivationService = ActivationService; 
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strPlanName).Product_Bundle_Id__c;
            for(SBQQ__ProductOption__c objProductOption : [SELECT Id, Name,SBQQ__Feature__r.Name,SBQQ__Feature__r.Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c FROM SBQQ__ProductOption__c WHERE SBQQ__OptionalSKU__c != null AND SBQQ__ConfiguredSKU__c != null AND SBQQ__ConfiguredSKU__c =: strProductbundleId AND SBQQ__Feature__r.Name =: strFeatureName ORDER BY SBQQ__Number__c]){ 
                objActivationService.Global_Static_IP_Product__c = objProductOption.SBQQ__OptionalSKU__c;
                strFeatureIds = (strFeatureIds == null ? String.valueOf(objProductOption.SBQQ__Feature__r.Id) : (strFeatureIds + '@@' + String.valueOf(objProductOption.SBQQ__Feature__r.Id)));
            }
            if(strFeatureIds != null)
                strFeatureIds = strFeatureIds.removeEnd('@@');
        }
    } 
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    /** Constructor - Start **/
    public Act_Static_IP_Component_Controller(){
    }
    /** Constructor - End **/
    
}