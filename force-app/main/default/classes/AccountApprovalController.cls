public class AccountApprovalController {

    public Account accountRecord {get; set;}
    public User recipientUser {get; set;}
    
    public AccountApprovalController() {

    }

    public List<Account_History__c> getFieldHistoryListData(){

        List<Account_History__c> fieldHistoryList = new List<Account_History__c>();

        if(accountRecord == null || recipientUser == null) return fieldHistoryList;

        fieldHistoryList = [Select Id, Field__c, Old_Value__c, New_Value__c 
                            From Account_History__c 
                            Where Approval_Status__c = 'Pending' AND Account__c = :accountRecord.Id];

        return fieldHistoryList;
    }
}