public class CreditNoteTriggerHandler extends TriggerHandler {
    
    public CreditNoteTriggerHandler() {

    }

    public override void beforeInsert() {

        List<Credit_Note__c> newList = (List<Credit_Note__c>) Trigger.new;
        Set<String> externalIdSet = new Set<String>();

        for(Credit_Note__c creditNote : newList){

            if(String.isEmpty(creditNote.InvoiceNo__c)){

                creditNote.addError('InvoiceNo field cannot be blank');
            }

            externalIdSet.add(creditNote.InvoiceNo__c);
        }

        if(externalIdSet.isEmpty()) return;

        Map<String, String> externalIdVsInvoiceId = new Map<String, String>();

        for(Invoice__c inv : [Select Id, No__c From Invoice__c Where No__c IN :externalIdSet]){

            externalIdVsInvoiceId.put(inv.No__c, inv.Id);
        }

        for(Credit_Note__c creditNote : newList){

            if(externalIdVsInvoiceId.isEmpty() || !externalIdVsInvoiceId.containsKey(creditNote.InvoiceNo__c)){

                creditNote.addError('Invoice not found with provided external Id.');
            }            

            creditNote.Invoice__c = externalIdVsInvoiceId.get(creditNote.InvoiceNo__c);
        }

    }

}