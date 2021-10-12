@isTest
private class ReceiptLineTriggerHandler_Test {
    
    @isTest
    private static void beforeInsert_pass_TGN_TEST(){
        
        Account drAccount= generateAccount();
        
        Invoice__c drInvoice_c = new Invoice__c();
        drInvoice_c.Account__c = drAccount.Id;
        drInvoice_c.CustomerNo__c = '123123';
        drInvoice_c.No__c = '123123';
        insert drInvoice_c;
        
        Receipt__c reciept = new Receipt__c();
        reciept.Name = '123123';
        reciept.Account__c = drAccount.Id;
        reciept.CustomerNo__c = '123123';
        
        insert reciept;
        
        Receipt_Line__c recieptline =new Receipt_Line__c();
        recieptline.Invoice__c = drInvoice_c.id;
        recieptline.InvoiceNo__c = '123123';
        recieptline.ReceiptNo__c = '123123';
        recieptline.Receipt__c =reciept.Id;
        
        Test.startTest();
        
        insert recieptline;
        
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
   
            
            Receipt__c reciept = new Receipt__c();
            reciept.Name = '123123';
           // reciept.Account__c = drAccount.Id;
         //   reciept.CustomerNo__c = '123123';
            
            
            
            insert reciept;
            
            
        }
        catch (DmlException d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertNotEquals(null, expectedException, 'CustomerNo field cannot be blank');
        
    }
    
    
        @isTest
    private static void beforeInsert_reciept_line_fail_TGN_TEST(){
        
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
   
         Receipt__c reciept = new Receipt__c();
        reciept.Name = '123123';
        reciept.Account__c = drAccount.Id;
        reciept.CustomerNo__c = '123123';
        
        insert reciept;
        
        Receipt_Line__c recieptline =new Receipt_Line__c();
        recieptline.Invoice__c = drInvoice_c.id;
       // recieptline.InvoiceNo__c = '123123';
      //  recieptline.ReceiptNo__c = '123123';
        //recieptline.Receipt__c =reciept.Id;
        
         insert recieptline;   
            
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