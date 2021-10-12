@isTest
public class contractController_Test {
 static testMethod void test_UseCase1(){
    test.startTest();
     
     Account account_obj = new Account( Name = 'Test', Galaxy_Customer_Type__c ='Airline' ,AWB_Prefix__c = '157',Galaxy_Customer_Category__c = 'Cash',IATA_Code__c = '1234567',Carrier_Code__c = 'KQ',Sync_Record_Data__c = false,BillingCity='Nairobi',BillingCountry='Kenya',BillingPostalCode='00100',BillingState='Kenya',BillingStreet='Moi',Phone='+254711999555');
     Insert account_obj;
     Contract mc = new   Contract(AccountId = account_obj.Id, Name = 'Name734');
      Insert mc;
     string letterhead = 'option1';
    
    // apexpages.currentpage().getparameters().put('letterHeadValue' , letterhead);
    PageReference pref = Page.contractPDF;
     pref.getParameters().put('Id', mc.Id);  
    pref.getParameters().put('letterhead', letterhead);
    Test.setCurrentPage(pref);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(mc);
      contractController testAccPlan = new contractController(sc);
    test.stopTest();
  }

}