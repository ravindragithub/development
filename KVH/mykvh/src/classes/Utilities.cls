public without sharing class Utilities {
    
    @AuraEnabled
    public static List<String> getPicklistValues(String objApiName, String fieldApiName) {
        List<String> values = new List<String>();
        String[] types = new String[]{objApiName};
        System.debug(objApiName);
        System.debug(fieldApiName);
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        System.debug(results);
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldApiName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        return values;
    }
    
}