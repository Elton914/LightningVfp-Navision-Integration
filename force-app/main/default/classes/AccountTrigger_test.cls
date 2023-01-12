@isTest
private class AccountTrigger_test{
    
    @isTest
    private static void beforeUpdate_TEST(){
        
        
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
        drAccount.Approval_Manager__c = System.UserInfo.getUserId();
    //  drAccount.Approval_Action_Taken__c = true;
        drAccount.Sync_Record_Data__c = false;
        
        insert drAccount;
         System.assertNotEquals(null,drAccount.Id );
         drAccount.BillingState = 'Nakuru';
        update drAccount;
        
        System.assertEquals('Nakuru',drAccount.BillingState );
    }
    
}