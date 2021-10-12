public class DebitNoteTriggerHandler extends TriggerHandler {
    
    public DebitNoteTriggerHandler() {

    }

    public override void beforeInsert() {

        List<Debit_Note__c> newList = (List<Debit_Note__c>) Trigger.new;
        Set<String> externalIdSet = new Set<String>();

        for(Debit_Note__c debitNote : newList){

            if(String.isEmpty(debitNote.InvoiceNo__c)){

                debitNote.addError('InvoiceNo field cannot be blank');
            }

            externalIdSet.add(debitNote.InvoiceNo__c);
        }

        if(externalIdSet.isEmpty()) return;

        Map<String, String> externalIdVsInvoiceId = new Map<String, String>();

        for(Invoice__c inv : [Select Id, No__c From Invoice__c Where No__c IN :externalIdSet]){

            externalIdVsInvoiceId.put(inv.No__c, inv.Id);
        }

        for(Debit_Note__c debitNote : newList){

            if(externalIdVsInvoiceId.isEmpty() || !externalIdVsInvoiceId.containsKey(debitNote.InvoiceNo__c)){

                debitNote.addError('Invoice not found with provided external Id.');
            }            

            debitNote.Invoice__c = externalIdVsInvoiceId.get(debitNote.InvoiceNo__c);
        }

    }

}