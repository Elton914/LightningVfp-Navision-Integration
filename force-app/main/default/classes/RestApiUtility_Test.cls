@isTest(SeeAllData=True) 
private class RestApiUtility_Test{
    
    @isTest
    private static void testGenerateProposalPass(){
        Test.startTest();
       
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new  MockResponseRestAPiUtility_Pass ());
        Account acc = generateAccount();
         
        RestApiUtility.updateRecordsInNavision('{"no":""}', acc.id,'POST');
        
        System.assertNotEquals('C000001', [Select Id, Navision_Customer_ID__c From Account Where Id = :acc.Id ].Navision_Customer_ID__c);
    
        Test.stopTest();
    }
 
     @isTest
    private static void testGenerateProposalFail(){
        
        Test.startTest();    
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockResponseRestAPiUtility_Fail());
        Account acc = generateAccount();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        RestApiUtility.updateRecordsInNavision('{"no":""}', acc.id,'POST');
        
        System.assertNotEquals('C000001', [Select Id, Navision_Customer_ID__c From Account Where Id = :acc.Id ].Navision_Customer_ID__c);
    
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