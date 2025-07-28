trigger CAMPX_PlantTrigger on CAMPX__Plant__c (before insert, after insert, after update,before update, after delete) {
    //pull related gardens from trigger.old
    
    //before insert triggers
    if(trigger.isinsert && trigger.isbefore){
        CAMPX_PlantInitialFields.setInitialFields(trigger.new);
        

// Collect Garden IDs that need validation
Set<Id> gardenIds = new Set<Id>();
for(CAMPX__Plant__c plant : trigger.new){
    if(plant.CAMPX__Garden__c != null){
        gardenIds.add(plant.CAMPX__Garden__c);
    }
}

// Query for Garden status data
Map<Id, CAMPX__Garden__c> gardenMap = new Map<Id, CAMPX__Garden__c>();
if(!gardenIds.isEmpty()){
    gardenMap = new Map<Id, CAMPX__Garden__c>([
        SELECT Id, CAMPX__Status__c 
        FROM CAMPX__Garden__c 
        WHERE Id IN :gardenIds
    ]);
}

// Apply validation logic
for(CAMPX__Plant__c plant : trigger.new){
    if(plant.CAMPX__Garden__c != null){
        CAMPX__Garden__c garden = gardenMap.get(plant.CAMPX__Garden__c);
        if(garden != null && garden.CAMPX__Status__c == 'Permanent Closure'){
            plant.addError('The garden selected for this plant is permanently closed. Please select a different garden.');
            }
        }
    }
}
    //after insert triggers
    if(trigger.isinsert && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.new);
        CAMPX_UnhealthyPlantCount.sumUnhealthy(trigger.new);
            
    }

    //before update triggers
    if(trigger.isupdate && trigger.isbefore){
        // Collect Garden IDs that need validation
Set<Id> gardenIds = new Set<Id>();
for(CAMPX__Plant__c plant : trigger.new){
    if(plant.CAMPX__Garden__c != null){
        gardenIds.add(plant.CAMPX__Garden__c);
    }
}

// Query for Garden status data
Map<Id, CAMPX__Garden__c> gardenMap = new Map<Id, CAMPX__Garden__c>();
if(!gardenIds.isEmpty()){
    gardenMap = new Map<Id, CAMPX__Garden__c>([
        SELECT Id, CAMPX__Status__c 
        FROM CAMPX__Garden__c 
        WHERE Id IN :gardenIds
    ]);
}

// Apply validation logic
for(CAMPX__Plant__c plant : trigger.new){
    if(plant.CAMPX__Garden__c != null){
        CAMPX__Garden__c garden = gardenMap.get(plant.CAMPX__Garden__c);
        if(garden != null && garden.CAMPX__Status__c == 'Permanent Closure'){
            plant.addError('The garden selected for this plant is permanently closed. Please select a different garden.');
            }
        }
    }      
}

    //after update triggers
    if(trigger.isupdate && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.new);
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.old);
        CAMPX_UnhealthyPlantCount.sumUnhealthy(trigger.new);

        for(Integer i = 0; i < trigger.new.size(); i++){
            if(trigger.new[i].CAMPX__Status__c == 'Healthy' && trigger.new[i].CAMPX__Status__c != trigger.old[i].CAMPX__Status__c){
                CAMPX_UnhealthyPlantCount.subtractUnhealthy(trigger.new);
            }
        }
    }
    //after delete triggers
    if(trigger.isdelete && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.old);
        CAMPX_UnhealthyPlantCount.subtractUnhealthy(trigger.old);
    }
}