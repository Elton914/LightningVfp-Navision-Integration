@isTest
private class AccountApprovalController_test {
    
    @isTest
    private static void beforeInsert_pass_TGN_TEST()
    {
        
        Account drAccount= generateAccount(); 
        
        Account_History__c history = new Account_History__c();
        history.Account__c = drAccount.Id;
        history.New_Value__c = '1';
        history.Old_Value__c = '0';
        history.Approval_Status__c = 'Pending';
        
        insert history;
        System.debug(history);
        Test.startTest();
        
        AccountApprovalController accApproval = new AccountApprovalController();
        accApproval.accountRecord = drAccount;
        accApproval.recipientUser = [SELECT Id from User where id= :Userinfo.getUserId()];
        System.assertEquals(1, accApproval.getFieldHistoryListData().size());
      
        System.assertEquals(drAccount.Id, accApproval.accountRecord.Id);
        System.assertEquals(Userinfo.getUserId(), accApproval.recipientUser.Id);
        
        Test.stopTest();
    }
    
    
    static private Account generateAccount()
    {
        Account drAccount=new Account();
        drAccount.Name = 'New Account';
        drAccount.BillingCity = 'Nairobi';
        drAccount.BillingCountry = 'Kenya';
        drAccount.BillingState = 'Nairobi';
        drAccount.billingStreet = 'Kena';
        drAccount.Phone = '+254711455555';
        drAccount.Tax_Identification_Number__c = '123123123';
        drAccount.BillingPostalCode = '11111';
        drAccount.Navision_Customer_ID__c = '123123';
        insert drAccount;
        
        return drAccount;
    }
}