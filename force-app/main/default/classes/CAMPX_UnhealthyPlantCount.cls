public with sharing class CAMPX_UnhealthyPlantCount {
    public static void sumUnhealthy(List<CAMPX__Plant__c> newPlants) {
        
        // Extract unique Garden IDs to avoid duplicates
    Set<Id> gardenIds = new Set<Id>();
    for (CAMPX__Plant__c plant : newPlants) {
        if (plant.CAMPX__Garden__c != null) {
            gardenIds.add(plant.CAMPX__Garden__c);
            }
        }
        
        // Single SOQL query to get all related gardens
    Map<Id, CAMPX__Garden__c> gardenMap = new Map<Id, CAMPX__Garden__c>(
        [SELECT Id, Name, CAMPX__Total_Unhealthy_Plant_Count__c,
                (SELECT Id, CAMPX__Status__c FROM CAMPX__Plants__r)
        FROM CAMPX__Garden__c 
        WHERE Id IN :gardenIds]);
        
    Decimal unhealthyPlantCount = 0;
    List<CAMPX__Garden__c> gardenUpdates = new List<CAMPX__Garden__C>();

    for(CAMPX__Garden__c garden : gardenMap.values()){
        for(CAMPX__Plant__c plant : garden.CAMPX__Plants__r) {
            if(plant.CAMPX__Status__c == 'Deceased' || plant.CAMPX__Status__c == 'Sick' || plant.CAMPX__Status__c == 'Wilting'){
                unhealthyPlantCount++; 
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = unhealthyPlantCount;
            }
        }
        gardenUpdates.add(garden);
    }
    update gardenUpdates;
    }

    public static void subtractUnhealthy(List<CAMPX__Plant__c> oldPlants) {
        // Extract unique Garden IDs to avoid duplicates
    Set<Id> gardenIds = new Set<Id>();
    for (CAMPX__Plant__c plant : oldPlants) {
        if (plant.CAMPX__Garden__c != null) {
            gardenIds.add(plant.CAMPX__Garden__c);
            }
        }
        
        // Single SOQL query to get all related gardens
    Map<Id, CAMPX__Garden__c> gardenMap = new Map<Id, CAMPX__Garden__c>(
        [SELECT Id, Name, CAMPX__Total_Unhealthy_Plant_Count__c,
                (SELECT Id, CAMPX__Status__c FROM CAMPX__Plants__r)
        FROM CAMPX__Garden__c 
        WHERE Id IN :gardenIds]);
        
    List<CAMPX__Garden__c> gardenUpdates = new List<CAMPX__Garden__C>();
    
    for(CAMPX__Garden__c garden : gardenMap.values()){
            Decimal unhealthyPlantCount = garden.CAMPX__Total_Unhealthy_Plant_Count__c;
            
        for(CAMPX__Plant__c plant : garden.CAMPX__Plants__r){
                unhealthyPlantCount--;
                garden.CAMPX__Total_Unhealthy_Plant_Count__c = unhealthyPlantCount;
            }
            gardenUpdates.add(garden);
        }
        update gardenUpdates;
    }
}