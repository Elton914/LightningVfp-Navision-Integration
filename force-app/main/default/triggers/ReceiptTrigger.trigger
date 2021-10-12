trigger ReceiptTrigger on Receipt__c (before insert) {

    new ReceiptTriggerHandler().run();
}