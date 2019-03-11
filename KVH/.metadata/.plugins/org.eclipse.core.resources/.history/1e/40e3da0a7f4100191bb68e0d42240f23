/**
 * Created by Jai Chaturvedi on 11/03/2017.
 */

global  class PortalOptionsWrapper implements Comparable{
    @AuraEnabled public String optionLabel { get; set; }
    @AuraEnabled public String bgOptionColor { get; set; }
    @AuraEnabled public String bgOptionImage { get; set; }

    global PortalOptionsWrapper(String optionLabel, String bgOptionColor,String bgOptionImage){
        this.optionLabel = optionLabel ;
        this.bgOptionColor = bgOptionColor ;
        this.bgOptionImage = bgOptionImage;
    }
    global  Integer compareTo(Object objToCompare) {
        return optionLabel.compareTo(((PortalOptionsWrapper)objToCompare).optionLabel);
    }
}