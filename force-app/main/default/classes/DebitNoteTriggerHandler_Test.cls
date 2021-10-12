@isTest
private class DebitNoteTriggerHandler_Test {
    
    
    
    @isTest
    private static void beforeInsert_pass_TGN_TEST(){
        
        Account drAccount= generateAccount();
        
        Invoice__c drInvoice_c = new Invoice__c();
        drInvoice_c.Account__c = drAccount.Id;
        drInvoice_c.CustomerNo__c = '123123';
        drInvoice_c.No__c = '123123';
        insert drInvoice_c;
        
        Debit_Note__c dbnote =new Debit_Note__c();
        dbnote.Invoice__c = drInvoice_c.id;
        dbnote.InvoiceNo__c = '123123';
        Test.startTest();
        
        insert dbnote;
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void beforeInsert_fail_TGN_TEST(){
        
        Test.startTest();
        DmlException expectedException;

        
        try
        {
               Account drAccount= generateAccount();
        
                Invoice__c drInvoice_c = new Invoice__c();
                drInvoice_c.Account__c = drAccount.Id;
                drInvoice_c.CustomerNo__c = '123123';
                drInvoice_c.No__c = '123123';
                insert drInvoice_c;
        
                Debit_Note__c dbnote =new Debit_Note__c();
                dbnote.Invoice__c = drInvoice_c.id;
                //dbnote.InvoiceNo__c = '123123';
                
        
       			 insert dbnote;
        
      	 
        }
        catch (DmlException d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertNotEquals(null, expectedException, 'InvoiceNo field cannot be blank');
        
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