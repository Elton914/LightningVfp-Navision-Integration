trigger DebitNoteTrigger on Debit_Note__c (before insert) {

    new DebitNoteTriggerHandler().run();
}