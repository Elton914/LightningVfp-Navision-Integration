@isTest
private class sopController_Test{
     
   

  static testMethod void test_UseCase1(){
    test.startTest();
     SOP__c mc = new   SOP__c(Name = 'Name734');
      Insert mc;
     string letterhead = 'option1';
    
    // apexpages.currentpage().getparameters().put('letterHeadValue' , letterhead);
    PageReference pref = Page.sopPDF;
     pref.getParameters().put('Id', mc.Id);  
    pref.getParameters().put('letterhead', letterhead);
    Test.setCurrentPage(pref);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(mc);
      sopController testAccPlan = new sopController(sc);
    test.stopTest();
  }
}