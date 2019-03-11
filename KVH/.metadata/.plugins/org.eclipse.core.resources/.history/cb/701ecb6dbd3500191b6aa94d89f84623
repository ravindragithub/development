@isTest
private class QRLabelController_test {

  static testMethod void test_stringify_qparams() {
    // TO DO: implement unit test
    Map<string, String> m1 = new Map<string, String>();
    m1.put('1', 'First item');
    m1.put('2', 'Second+item');
    m1.put('3', 'Third item');
    m1.put('4', 'Fourth+item');
    
    PageReference pageRef
      = new PageReference(
        '/apex/QRLabel_LTE?qr_version=1.0&serial_number=180500001&url=https://www.mykvh.com/LTEactivate&default_ssid=LTE1-40C1&device=2933-BAD9-E505&random_qp=random'
      );
    Test.setCurrentPage(pageRef);

    QRLabelController util = new QRLabelController();
    string qparams = util.stringify_qparams(m1);
    system.debug(qparams);
    //URL Encoding does not seem to work super good....
    system.assertEquals('?1=First+item&2=Second%2Bitem&3=Third+item&4=Fourth%2Bitem', qparams);
    
    Map<string, String> m2 = new Map<string, String>();
    qparams = util.stringify_qparams(m2);
    system.debug(qparams);
    system.assertEquals('', qparams);
  }
  static testMethod void test_QRLabelController_constructor(){
    PageReference pageRef
      = new PageReference(
        '/apex/QRLabel_LTE?qr_version=1.0&serial_number=180500001&url=https://www.mykvh.com/LTEactivate&default_ssid=LTE1-40C1&device=2933-BAD9-E505&random_qp=random'
      );
    Test.setCurrentPage(pageRef);

    QRLabelController util = new QRLabelController();

    //URL Encoded!! :)
    system.assert(util.urlContent.contains('https%3A%2F%2Fwww.mykvh.com%2FLTEactivate'), util.urlContent);
    system.assert(util.urlContent.contains('qr_version%3D1.0'), util.urlContent);
    //ApexPages.currentPage().getParameters().put('random_qp', 'random'); 
    system.assert(util.urlContent.contains('random_qp%3Drandom'), util.urlContent); //nothing should break
  }

}