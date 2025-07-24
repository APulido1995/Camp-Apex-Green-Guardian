public with sharing class CAMPX_GardenInitialFields {
    public static void setInitialFields(list<CAMPX__Garden__c> gardens) {
        for(CAMPX__Garden__c g : gardens) {
            if(g.CAMPX__Status__c == null){
            g.CAMPX__Status__c = 'Awaiting Resources';
            }
            if(g.CAMPX__Max_Plant_Count__c == null){
            g.CAMPX__Max_Plant_Count__c = 100;
            }
            if(g.CAMPX__Minimum_Plant_Count__c == null){
            g.CAMPX__Minimum_Plant_Count__c = 1;
            }
            if(g.CAMPX__Total_Plant_Count__c == null){
            g.CAMPX__Total_Plant_Count__c = 0;
            }
            if(g.CAMPX__Total_Unhealthy_Plant_Count__c == null){
            g.CAMPX__Total_Unhealthy_Plant_Count__c = 0;
            }
            g.CAMPX__Capacity__c = (g.CAMPX__Total_Plant_Count__c / g.CAMPX__Max_Plant_Count__c) * 100;
        }
    }
}