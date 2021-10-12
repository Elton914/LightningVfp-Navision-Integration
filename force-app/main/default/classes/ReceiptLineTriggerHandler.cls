public class ReceiptLineTriggerHandler extends TriggerHandler {
    
    public ReceiptLineTriggerHandler() {

    }

    public override void beforeInsert() {

        List<Receipt_Line__c> newList = (List<Receipt_Line__c>) Trigger.new;
        Set<String> externalIdSet = new Set<String>();

        for(Receipt_Line__c receiptLine : newList){

            if(String.isEmpty(receiptLine.InvoiceNo__c)){

                receiptLine.addError('InvoiceNo field cannot be blank');
            }

            externalIdSet.add(receiptLine.InvoiceNo__c);
        }

        if(externalIdSet.isEmpty()) return;

        Map<String, String> externalIdVsInvoiceId = new Map<String, String>();

        for(Invoice__c inv : [Select Id, No__c From Invoice__c Where No__c IN :externalIdSet]){

            externalIdVsInvoiceId.put(inv.No__c, inv.Id);
        }

        for(Receipt_Line__c receiptLine : newList){

            if(externalIdVsInvoiceId.isEmpty() || !externalIdVsInvoiceId.containsKey(receiptLine.InvoiceNo__c)){

                receiptLine.addError('Invoice not found with provided external Id.');
            }            

            receiptLine.Invoice__c = externalIdVsInvoiceId.get(receiptLine.InvoiceNo__c);
        }

    }

}