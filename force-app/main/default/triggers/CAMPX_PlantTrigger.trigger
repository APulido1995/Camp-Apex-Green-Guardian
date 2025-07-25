trigger CAMPX_PlantTrigger on CAMPX__Plant__c (before insert, after insert, after update, after delete) {
    //pull related gardens from trigger.old
    
    //before insert triggers
    if(trigger.isinsert && trigger.isbefore){
        CAMPX_PlantInitialFields.setInitialFields(trigger.new);
    }
    //after insert triggers
    if(trigger.isinsert && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.new);
        CAMPX_UnhealthyPlantCount.sumUnhealthy(trigger.new);
            
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