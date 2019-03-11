public class Act_Voice_Line_Component_Ctrl {
    
    public Activation_Service__c objActivationService; // very important to pass vf component "attribute" value to controller 
    public Boolean boolSecondVoiceLine {get; set;}
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){
            objActivationService = ActivationService;
            if(objActivationService.Voice_Line_2_Type__c != null)
                boolSecondVoiceLine = true;
        }
    } 
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    /** Constructor - Start **/
    public Act_Voice_Line_Component_Ctrl(){
        boolSecondVoiceLine = false;
    }
    /** Constructor - End **/
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   09/20/2016
    * @description          :   updateActivationService Method.
    *                           Upsert Activation Service
    * @return               :   void
    * @invoke               :   From action method of Vf page
    **/
    public pagereference updateActivationServiceVoice1(){
        objActivationService.Voice_1_Product__c =  objActivationService.Voice_Line_1_Type__c != null && objActivationService.Voice_Line_1_Type__c != '' ?  Activation_Product_Bundle__c.getValues(objActivationService.Voice_Line_1_Type__c+' 1').Product_Bundle_Id__c : null;
        objActivationService.Voice_2_Product__c =  objActivationService.Voice_Line_2_Type__c != null && objActivationService.Voice_Line_2_Type__c != '' ?  Activation_Product_Bundle__c.getValues(objActivationService.Voice_Line_2_Type__c+' 2').Product_Bundle_Id__c : null;
        update objActivationService; 
        return null;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   11/07/2016
    * @description          :   saveActivationServiceVoice Method.
    *                           Upsert Activation Service
    * @return               :   void
    * @invoke               :   From action method of Vf page
    **/
    public pagereference saveActivationServiceVoice(){
        update objActivationService; 
        return null;
    }
    
    
     /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   10/17/2016
    * @description          :   ActivationServiceVoice2Show Method.
    * @return               :   void
    * @invoke               :   From action method of Vf page
    **/
    public pagereference ActivationServiceVoice2Show(){
        boolSecondVoiceLine = true;
       return null;
    }
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   10/17/2016
    * @description          :   ActivationServiceVoice2Hide Method.
    * @return               :   void
    * @invoke               :   From action method of Vf page
    **/
    public pagereference ActivationServiceVoice2Hide(){
        boolSecondVoiceLine = false;
        objActivationService.Voice_2_Product__c = null;
        objActivationService.Voice_Line_2_Type__c = '';
        return null;
    }
    
}