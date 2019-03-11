@RestResource(urlMapping='/V1/activations/*')
global class REST_activations {
  @HttpGet  //responds to a GET naturally
  global static activation_response doGet(){
    return new activation_response();
  }

  @HttpPost //responds to a POST naturally
  global static activation_response doPost(String recordId){
    system.debug('Input Record Id: ' + recordId);
    activation_response returnObj = new activation_response();
    //Invoke that Transform Service here using the input recordId.....
    Id rawFormId = (id)recordId;  //convert string to Id
    LTE_activation__c rawForm = new LTE_activation__c(id = rawFormId);  //create form sObject
    serviceResults sr = Service_LTE_activation_transform.transformLTEActivationForm(rawForm);
    //Assuming all goes well!....
    returnObj.recordMap = Service_LTE_activation_transform.getrecordMap();
    returnObj.resultCode.success = sr.success;
    if(!sr.success){
      returnObj.resultCode.exceptionMessage = sr.message;
    } else {
      returnObj.resultCode.exceptionMessage = '';
    }
    return returnObj;
  }

  global class activation_response{   //return Object for POST and GET
    public map<String, String> recordMap = new map<String, String>();
    public REST_API_utilities.resultCode resultCode 
      = new REST_API_utilities.resultCode();    //resultCode class...
  }
}