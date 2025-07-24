public with sharing class CAMPX_PlantInitialFields {
    public static void setInitialFields(List<CAMPX__Plant__c> plants) {
        for(CAMPX__Plant__c p : plants) {
            if(p.CAMPX__Soil_Type__c == null){
                p.CAMPX__Soil_Type__c = 'All Purpose Potting Soil';
            }
            if(p.CAMPX__Water__c == null) {
                p.CAMPX__Water__c = 'Once Weekly';
            }
            if(p.CAMPX__Sunlight__c == null && p.CAMPX__Garden__r.CAMPX__Sun_Exposure__c != null){
                p.CAMPX__Sunlight__c = p.CAMPX__Garden__r.CAMPX__Sun_Exposure__c;
            }
            else{
                p.CAMPX__Sunlight__c = 'Partial Sun';
            }
    }
}
}