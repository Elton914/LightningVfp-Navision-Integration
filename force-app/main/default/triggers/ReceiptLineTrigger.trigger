trigger ReceiptLineTrigger on Receipt_Line__c (before insert) {

    new ReceiptLineTriggerHandler().run();
}