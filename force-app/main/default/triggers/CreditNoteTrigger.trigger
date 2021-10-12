trigger CreditNoteTrigger on Credit_Note__c (before insert) {

    new CreditNoteTriggerHandler().run();
}