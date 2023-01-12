public class sopController
{
    
    public sopController(ApexPages.StandardController controller ) {
        
        
        Id sopId =  ApexPages.currentPage().getParameters().get('ID');
        
        String myGeneratedFilename = [SELECT Id, Name from SOP__c where id = :sopId][0].Name;
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename); 
        
        
    }
    
}