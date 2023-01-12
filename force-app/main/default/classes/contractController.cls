public class contractController {
    
    public String letterhead{ get; set; }
    
    public contractController(ApexPages.StandardController controller ) {
        
           Id contractId =  ApexPages.currentPage().getParameters().get('ID');
        
           String myGeneratedFilename = [SELECT Id, Name from Contract where id = :contractId][0].Name;
           Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename); 

        
    }
}