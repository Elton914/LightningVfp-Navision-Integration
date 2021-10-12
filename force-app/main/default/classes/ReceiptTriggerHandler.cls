public class ReceiptTriggerHandler extends TriggerHandler {
    
    public ReceiptTriggerHandler() {

    }

    public override void beforeInsert() {

        System.debug('inside beforeInsert');

        List<Receipt__c> newList = (List<Receipt__c>) Trigger.new;
        Set<String> externalIdSet = new Set<String>();

        for(Receipt__c receipt : newList){

            if(String.isEmpty(receipt.CustomerNo__c)){

                receipt.addError('CustomerNo field cannot be blank');
            }

            externalIdSet.add(receipt.CustomerNo__c);
        }

        if(externalIdSet.isEmpty()) return;

        Map<String, String> externalIdVsAccountId = new Map<String, String>();

        for(Account acct : [Select Id, Navision_Customer_ID__c From Account Where Navision_Customer_ID__c IN :externalIdSet]){

            externalIdVsAccountId.put(acct.Navision_Customer_ID__c, acct.Id);
        }

        for(Receipt__c receipt : newList){

            if(externalIdVsAccountId.isEmpty() || !externalIdVsAccountId.containsKey(receipt.CustomerNo__c)){

                receipt.addError('Account not found with provided external Id.');
            }            

            receipt.Account__c = externalIdVsAccountId.get(receipt.CustomerNo__c);
        }

    }
}