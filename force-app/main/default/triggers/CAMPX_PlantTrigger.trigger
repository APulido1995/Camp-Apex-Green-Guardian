trigger CAMPX_PlantTrigger on CAMPX__Plant__c (before insert, after insert, after update, after delete) {
    //pull related gardens from trigger.old
    
    //before insert triggers
    if(trigger.isinsert && trigger.isbefore){
        CAMPX_PlantInitialFields.setInitialFields(trigger.new);
    }
    //after insert triggers
    if(trigger.isinsert && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.new);
    }
    //after update triggers
    if(trigger.isupdate && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.new);
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.old);
    }
    //after delete triggers
    if(trigger.isdelete && trigger.isafter){
        CAMPX_PlantCountUpdates.calcPlantCount(trigger.old);
    }
}