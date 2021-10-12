public class InvoiceTriggerHandler extends TriggerHandler {
    
    public InvoiceTriggerHandler() {

    }

    public override void beforeInsert() {

        List<Invoice__c> newList = (List<Invoice__c>) Trigger.new;
        Set<String> externalIdSet = new Set<String>();

        for(Invoice__c invoice : newList){

            if(String.isEmpty(invoice.CustomerNo__c)){

                invoice.addError('CustomerNo field cannot be blank');
            }

            externalIdSet.add(invoice.CustomerNo__c);
        }

        if(externalIdSet.isEmpty()) return;

        Map<String, String> externalIdVsAccountId = new Map<String, String>();

        for(Account acct : [Select Id, Navision_Customer_ID__c From Account Where Navision_Customer_ID__c IN :externalIdSet]){

            externalIdVsAccountId.put(acct.Navision_Customer_ID__c, acct.Id);
        }

        for(Invoice__c invoice : newList){

            if(externalIdVsAccountId.isEmpty() || !externalIdVsAccountId.containsKey(invoice.CustomerNo__c)){

                invoice.addError('Account not found with provided external Id.');
            }            

            invoice.Account__c = externalIdVsAccountId.get(invoice.CustomerNo__c);
        }

    }
}