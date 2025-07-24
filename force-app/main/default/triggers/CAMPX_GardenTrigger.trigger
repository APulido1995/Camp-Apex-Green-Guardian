trigger CAMPX_GardenTrigger on CAMPX__Garden__c (before insert, after insert, after update, before update) {

    //Before insert triggers
    if(trigger.isinsert && trigger.isbefore){
        CAMPX_GardenInitialFields.setInitialFields(trigger.new);

        CAMPX_GardenManagerStart.initManagerFields(trigger.new);
     }
    //After insert triggers
    if(trigger.isinsert && trigger.isafter){
        //task creation when manager is not null
        List<CAMPX__Garden__c> gardensForTasks = new List<CAMPX__Garden__c>();

        for(CAMPX__Garden__c g : trigger.new) {
            if(g.CAMPX__Manager__c != null) {
                gardensForTasks.add(g);
            }
        }
        CAMPX_GardenTaskCreation.createTask(gardensForTasks);
    }

    //After update triggers
    if(trigger.isafter && trigger.isupdate){
        //task creation when manager is updated from null to value
            List<CAMPX__Garden__c> gardensForTasks2 = new List<CAMPX__Garden__c>();

        for(Integer i = 0; i < trigger.new.size(); i++){
            if(trigger.old[i].CAMPX__Manager__c != trigger.new[i].CAMPX__Manager__c && trigger.old[i].CAMPX__Manager__c == null){
                gardensForTasks2.add(trigger.new[i]);
            }
        }
        CAMPX_GardenTaskCreation.createTask(gardensForTasks2);

        //task reassignment when garden manager changes
        for(Integer i = 0; i < trigger.new.size(); i++){
            if(trigger.old[i].CAMPX__Manager__c != trigger.new[i].CAMPX__Manager__c && trigger.old[i].CAMPX__Manager__c != null && trigger.new[i].CAMPX__Manager__c != null){
                CAMPX_GardenTaskReassignment.reassignTask(trigger.new);
            }
        }

        //task deletion when there is no new manager on the garden
        for(Integer i = 0; i < trigger.new.size(); i++){
            if(trigger.old[i].CAMPX__Manager__c != trigger.new[i].CAMPX__Manager__c && trigger.new[i].CAMPX__Manager__c == null){
                CAMPX_GardenTaskReassignment.deleteTasks(trigger.new);
            }
        }
    }

    //Before update triggers
    if(trigger.isupdate && trigger.isbefore){
        for(Integer i = 0; i < trigger.new.size(); i++){
            // initial manager fields when manager is changed
            if(trigger.old[i].CAMPX__Manager__c != trigger.new[i].CAMPX__Manager__c){
                CAMPX_GardenManagerStart.initManagerFields(trigger.new);
            }
            //calculate capacity in trigger
            if(trigger.old[i].CAMPX__Total_Plant_Count__c != trigger.new[i].CAMPX__Total_Plant_Count__c || trigger.old[i].CAMPX__Max_Plant_Count__c != trigger.new[i].CAMPX__Max_Plant_Count__c){
                if(trigger.new[i].CAMPX__Total_Plant_Count__c == null){
                    trigger.new[i].CAMPX__Capacity__c = 0;
                }
                else if(trigger.new[i].CAMPX__Max_Plant_Count__c == 0){
                    trigger.new[i].CAMPX__Capacity__c = 0;
                }
                else{
                    trigger.new[i].CAMPX__Capacity__c = (trigger.new[i].CAMPX__Total_Plant_Count__c / trigger.new[i].CAMPX__Max_Plant_Count__c) * 100;
                }
            }   
        }
    }
}