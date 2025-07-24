public with sharing class CAMPX_GardenManagerStart {
    public static void initManagerFields(List<CAMPX__Garden__c> gardens) {
        for(CAMPX__Garden__c g : gardens) {
            if(g.CAMPX__Manager__c != null) {
                g.CAMPX__Manager_Start_Date__c = Date.today();
            }
            else{
                g.CAMPX__Manager_Start_Date__c = null;
            }
        }
    }
}