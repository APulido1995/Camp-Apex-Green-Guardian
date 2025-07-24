public with sharing class CAMPX_GardenTaskCreation {
    public static void createTask(List<CAMPX__Garden__c> gardens) {

        list<Task> tasksToCreate = new List<Task>();

        for(CAMPX__Garden__c g : gardens) {
            Task newTask = new Task();
            newTask.Whatid = g.id;
            newTask.OwnerId = g.CAMPX__Manager__c;
            newTask.Subject = 'Acquire Plants';

            tasksToCreate.add(newTask);
    }
            insert tasksToCreate;
}
}