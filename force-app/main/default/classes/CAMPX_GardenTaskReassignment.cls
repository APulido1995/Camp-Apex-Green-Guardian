public with sharing class CAMPX_GardenTaskReassignment {
    public static void reassignTask(List<CAMPX__Garden__c> gardens) {

        list<Task> tasksToAssign = new List<Task>(); 

        tasksToAssign = [SELECT Id, Status, OwnerId, Subject, Whatid
                         FROM Task
                         WHERE Whatid IN :gardens
                         AND Subject = 'Acquire Plants'
                         AND Status != 'Completed'];

        list<CAMPX__Garden__c> taskOwner = new list<CAMPX__Garden__c>();

        for(Task t : tasksToAssign) {
            taskOwner = [SELECT CAMPX__Manager__c
                         FROM CAMPX__Garden__c
                         WHERE Id = :t.WhatId
                         LIMIT 1];
            Id ownId = taskOwner[0].CAMPX__Manager__c;
            t.OwnerId = ownId;
        }
        update tasksToAssign;
    }

    public static void deleteTasks(List<CAMPX__Garden__c> gardens) {
        list<Task> tasksToDelete = new List<Task>(); 

        tasksToDelete = [SELECT Id, Status, OwnerId, Subject, Whatid
                         FROM Task
                         WHERE Whatid IN :gardens
                         AND Subject = 'Acquire Plants'
                         AND Status != 'Completed'];
        delete tasksToDelete;
    }
}
