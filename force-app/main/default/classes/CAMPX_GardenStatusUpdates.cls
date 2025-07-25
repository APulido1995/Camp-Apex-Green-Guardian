public with sharing class CAMPX_GardenStatusUpdates {
    public static void updateStatus(list<CAMPX__Garden__c> gardens) {
        for(CAMPX__Garden__c g : gardens) {
            if(g.CAMPX__Status__c == 'Permanent Closure') {
                break;
            }
            else if((100 >= g.CAMPX__Capacity__c && g.CAMPX__Capacity__c >= 70) && (g.CAMPX__Total_Plant_Count__c >= g.CAMPX__Minimum_Plant_Count__c) && g.CAMPX__Health_Index__c >= 70) {
                g.CAMPX__Status__c = 'Operational';
            } 
            else if(g.CAMPX__Capacity__c == 0) {
                g.CAMPX__Status__c = 'Temporary Closure';
            }
            else if(g.CAMPX__Capacity__c > 100){
                g.CAMPX__Status__c = 'Over Capacity';
            }
            else if ((70 > g.CAMPX__Capacity__c && g.CAMPX__Capacity__c > 0) || (70 > g.CAMPX__Health_Index__c) || (g.CAMPX__Minimum_Plant_Count__c > g.CAMPX__Total_Plant_Count__c)) {
                g.CAMPX__Status__c = 'Awaiting Resources';
            }
        }
    }
}