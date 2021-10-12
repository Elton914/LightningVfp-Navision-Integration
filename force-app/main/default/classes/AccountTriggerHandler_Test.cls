@isTest
private class AccountTriggerHandler_Test{
    
    @isTest
    private static void beforeUpdate_TEST(){
        
        Account drAccount= generateAccount();
        Test.startTest();
        
         drAccount.Name = 'New Name';
        drAccount.E_Mail__c ='test@test.com';
        drAccount.Phone = '+254711444555';
        
        
        update drAccount;
        
        System.assert([SELECT Id from  Account_History__c  where Account__c = : drAccount.Id].size() > 1);
        
            // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new  MockResponseRestAPiUtility_Pass ());
    
        
         drAccount.Approval_Action_Taken__c = true;
         drAccount.Approval_Status__c = 'Approved';
        
        update drAccount;
        
        Test.stopTest();
    }
    
    
      @isTest
    private static void beforeUpdate_ApprovalActionTaken_TEST(){
        
        Account drAccount= generateAccount();
        Test.startTest();
        
         drAccount.Name = 'New Name';
        drAccount.Approval_Action_Taken__c = true;
        update drAccount;
        
        System.assertEquals(0, [SELECT Id from  Account_History__c  where Account__c = : drAccount.Id].size());
        
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
        drAccount.Approval_Manager__c = System.UserInfo.getUserId();
    //  drAccount.Approval_Action_Taken__c = true;
        drAccount.Sync_Record_Data__c = false;
        
        insert drAccount;
        
        return drAccount;
    }
}