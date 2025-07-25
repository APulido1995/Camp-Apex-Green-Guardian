public with sharing class CAMPX_PlantCountUpdates {
    public static void calcPlantCount(List<CAMPX__Plant__c> plants) {
        
        //This method built with assistance from AI for use in learning Apex.

        // Guard clause for empty input
        if (plants == null || plants.isEmpty()) {
            return;
        }
        
        // Extract unique Garden IDs to avoid duplicates
        Set<Id> gardenIds = new Set<Id>();
        for (CAMPX__Plant__c plant : plants) {
            if (plant.CAMPX__Garden__c != null) {
                gardenIds.add(plant.CAMPX__Garden__c);
            }
        }
        
        // Single SOQL query to get all related gardens
        Map<Id, CAMPX__Garden__c> gardenMap = new Map<Id, CAMPX__Garden__c>(
            [SELECT Id, CAMPX__Manager__c, CAMPX__Total_Plant_Count__c, Name, CAMPX__Total_Unhealthy_Plant_Count__c,
                    (SELECT Id, CAMPX__Status__c FROM CAMPX__Plants__r)
             FROM CAMPX__Garden__c 
             WHERE Id IN :gardenIds]
        );

        // Update plant counts and using subquery results
        List<CAMPX__Garden__c> gardensToUpdate = new List<CAMPX__Garden__c>();
        for (CAMPX__Garden__c garden : gardenMap.values()) {
            garden.CAMPX__Total_Plant_Count__c = garden.CAMPX__Plants__r.size();

        gardensToUpdate.add(garden);
        }
        // Single DML operation
        if (!gardensToUpdate.isEmpty()) {
            update gardensToUpdate;
        }
    }
}