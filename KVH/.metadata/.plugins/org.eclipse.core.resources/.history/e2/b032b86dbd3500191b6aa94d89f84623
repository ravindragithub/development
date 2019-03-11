public class QRLabelController {
  //inputs (all requried Query parameters!)
  public String url {get; private set;}         //if not provided, defaults to kvh.com
  public String qr_version {get; private set;}  //also required
  public String device {get; private set;}      //required to derive default SSID, and password
  //outputs (derived from inputs in constructor)
  public String urlContent {get; private set;}
  public String jsonContent {get; private set;}
  public String default_ssid {get; private set;}
  public String default_wifi_password {get; private set;}
  //Query Parameters are "passed through" to the output, but they start as a map
  public map<String, String> qpMap {get; private set;}
  

  public QRLabelController() { //constructor does all the work!
    @TestVisible String defaultURL = 'https://www.kvh.com'; //just in case!
    qpMap = new map<String, String>();
    qpMap = System.currentPageReference().getParameters();
    system.debug(qpMap);
    if(qpMap.get('url') == null){
      qpMap.put('url', defaultURL);
    } //else ERROR!
    //JSON content has ALL qParams...
    JSONGenerator gen = JSON.createGenerator(false);
    gen.writeObject(qpMap);
    jsonContent = gen.getAsString();
    system.debug(jsonContent);
    //need to populate some label details
    default_wifi_password = LTEOSS_lte_devices.generateDefaultKey(qpMap.get('device'));
    default_ssid = 'TracPhone LTE1-' + qpMap.get('device').mid(10,4);
    //We don't want this qParams in the QR code
    qpMap.remove('device');
    urlContent = EncodingUtil.urlEncode(qpMap.remove('url') + stringify_qparams(qpMap), 'UTF-8');
  }
  
  @TestVisible private string stringify_qparams(map<string, string> params){ //copied from HTSOSS_Base :( ... can diverge independently :)
    //Turns a map of strings to a single query parameter string with appropriate ?s and &s
    string returnString = '';
    integer counter = 0;
    for(string key : params.keySet()){
      if (params.get(key) !=null){
        if(counter == 0){
          returnString = returnString + '?';
        } else {
          returnString = returnString + '&';
        }
        string key_value_pair = EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
        returnString = returnString + key_value_pair;
        counter++;
      }
    }
    return returnString;
  }
}