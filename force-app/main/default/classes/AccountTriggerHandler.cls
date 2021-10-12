public class AccountTriggerHandler extends TriggerHandler {
    
    public AccountTriggerHandler() {
        
    }
    
    public override void beforeUpdate() {
        
        // try {
        
        Map<Id, Account> newMap = (Map<Id, Account>) Trigger.newMap;
        Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;
        List<Account> newList = (List<Account>) Trigger.new;
        
        List<Account> accountsToSync = new List<Account>();
        
        List<Account_History__c> accountHistoryToInsert = new List<Account_History__c>();
        List<Account> accountsToSubmitForApproval = new List<Account>();
        
        List<Account> accountsProcessedFromApproval = new List<Account>();
        
        SObjectType accountObject = Schema.getGlobalDescribe().get('Account');
        Map<String,Schema.SObjectField> accountFields = accountObject.getDescribe().fields.getMap();
        
        Set<String> fieldsExcludedFromHistory = new Set<String>{'Submit_For_Approval__c', 'Navision_Customer_ID__c', 'Approval_Action_Taken__c', 'Approval_Manager__c', 'Approval_Status__c'};
            
            for(Account acct : newList){
                if(!String.isEmpty(acct.Navision_Customer_ID__c)){
                    
                    SObject newObj = (SObject) newMap.get(acct.Id);
                    SObject oldObj = (SObject) oldMap.get(acct.Id);
                    
                    Boolean isChanged = false;
                    
                    //check if approval action is taken for this record.
                    if(acct.Approval_Action_Taken__c){
                        
                        acct.Approval_Action_Taken__c = false;
                        
                        accountsProcessedFromApproval.add(acct);
                        
                    } else {
                        
                        for(Schema.SObjectField field : accountFields.values()){
                            
                            if(field.getDescribe().isAccessible() && field.getDescribe().isUpdateable() && !field.getDescribe().isCalculated()
                               && newObj.get(field) != oldObj.get(field) && !field.getDescribe().getName().equals('Sync_Record_Data__c') 
                               && !fieldsExcludedFromHistory.contains(field.getDescribe().getName()) 
                              ){
                                  isChanged = true;
                                  
                                  Account_History__c history = new Account_History__c();
                                  history.Account__c = acct.Id;
                                  history.Approval_Status__c = 'Pending';
                                  history.Field__c = field.getDescribe().getLabel();
                                  history.Field_Api_Name__c = field.getDescribe().getName();
                                  history.New_Value__c = String.valueOf(newObj.get(field));
                                  history.Old_Value__c = String.valueOf(oldObj.get(field));
                                  
                                  accountHistoryToInsert.add(history);
                                  
                                  acct.put(field.getDescribe().getName(), oldObj.get(field));
                              }
                        }
                        
                        if(isChanged){
                            
                            if(String.isEmpty(acct.Navision_Customer_ID__c)){
                                
                                acct.addError('cannot submit record for approval. Navision customer id missing.');
                                
                            } else if(String.isEmpty(acct.Approval_Manager__c)){
                                
                                acct.addError('Cannot submit record for approval. Approval Manager cannot be blank.');
                                
                            } else {
                                
                                accountsToSubmitForApproval.add(acct);
                                acct.Submit_For_Approval__c = true;
                                acct.Approval_Status__c = 'Pending';
                            }
                        }
                        
                    }
                    
                    
                    if(String.isNotEmpty(acct.Navision_Customer_ID__c) && acct.Sync_Record_Data__c){
                        
                        acct.addError('Cannot sync data. Navision customer id already exist.');
                    }

                    
                }
                
                if(newMap.get(acct.Id).Sync_Record_Data__c 
                   && newMap.get(acct.Id).Sync_Record_Data__c != oldMap.get(acct.Id).Sync_Record_Data__c){
                       
                       accountsToSync.add(acct);
                       
                       acct.Sync_Record_Data__c = false;
                   }
                
                
                
                
            }
        
        if(!accountHistoryToInsert.isEmpty() && !accountsToSubmitForApproval.isEmpty()){
            
            insert accountHistoryToInsert;
            
            submitForApproval(accountsToSubmitForApproval);
        }
        
        processAccountsFromApproval(accountsProcessedFromApproval, accountFields);
        
        //CREATING
        syncAccount(accountsToSync, 'POST');
        
        // } catch(Exception ex) {
        
        //     System.debug('Exception Occured: '+ex.getMessage());
        //     System.debug('Exception Cause: '+ex.getCause());
        //     System.debug('Exception Stacktrace: '+ex.getStackTraceString());
        // }
        
    }
    
    private void syncAccount(List<Account> accountsToSync, String requestType){
           System.debug('accountsToSync***'+accountsToSync);
        system.debug('=============================>'+requestType);
        if(!accountsToSync.isEmpty() && accountsToSync.size() == 1){
            
         
            //call API to sync data.
            
            Map<String, Account_Field_API_Mapping__mdt> accountFieldMapping = Account_Field_API_Mapping__mdt.getAll();
            
            if(accountFieldMapping.isEmpty()) return;
            
            String jsonBody = '';
            
            for(Account acct : accountsToSync){
                
                for(Account_Field_API_Mapping__mdt fieldMapping : accountFieldMapping.values()){
                    
                    if(fieldMapping.MasterLabel.equals('Navision_Customer_ID__c') && !requestType.equals('PUT')) continue;
                    
                    jsonBody = jsonBody + '"' + fieldMapping.DeveloperName + '"' + ': ';
                    
                    System.debug('jsonBody***'+jsonBody);
                    
                    if (fieldMapping.Field_Type__c.equals('String') )
                    {
                        jsonBody +=  + acct.get(fieldMapping.MasterLabel) != null ? '"' + acct.get(fieldMapping.MasterLabel) + '",' : (String) acct.get(fieldMapping.MasterLabel) + ',';
                        
                    }
                    else
                        
                    {
                        jsonBody +=  +  acct.get(fieldMapping.MasterLabel) != null ? '' + acct.get(fieldMapping.MasterLabel) + ',' : (String) acct.get(fieldMapping.MasterLabel) + ',';
                        
                    }
                    
                    
                    /*    else if(fieldMapping.MasterLabel.equals('Navision_Customer_ID__c') && !requestType.equals('POST'))
{
jsonBody = jsonBody + '"' + fieldMapping.DeveloperName + '"' + ': ';

if (fieldMapping.Field_Type__c.equals('String') )
{
jsonBody +=  + acct.get(fieldMapping.MasterLabel) == null ? '"' + acct.get(fieldMapping.MasterLabel) + '",' : (String) acct.get(fieldMapping.MasterLabel) + ',';

}
else

{
jsonBody +=  +  acct.get(fieldMapping.MasterLabel) == null ? '' + acct.get(fieldMapping.MasterLabel) + ',' : (String) acct.get(fieldMapping.MasterLabel) + ',';

}


}
*/
                    
                }
                
            }
            if(requestType.equals('POST'))
            {
                jsonBody +='"no": ""';
            }
            jsonBody = '{ ' + jsonBody.removeEnd(',') + ' }';
            
            System.debug('jsonBody***'+jsonBody);
            
            
            
            
            RestApiUtility.updateRecordsInNavision(jsonBody, accountsToSync[0].Id, requestType);
            
        }
    }
    
    
    public void submitForApproval(List<Account> accountsToSubmitForApproval){
        
        if(accountsToSubmitForApproval == null || accountsToSubmitForApproval.isEmpty()) return;
        
        List<Approval.ProcessSubmitRequest> requestList = new List<Approval.ProcessSubmitRequest>();
        
        for(Account acct : accountsToSubmitForApproval){
            
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
            req.setComments('Submitting approval request using Trigger');      
            
            req.setObjectId(acct.id);
            
            requestList.add(req);
        }
        
        // Submit the approval request for the Account        
        Approval.ProcessResult[] result = Approval.process(requestList);
    }
    
    private void processAccountsFromApproval(List<Account> accountsProcessedFromApproval, Map<String, Schema.SObjectField> accountFields){
        
        List<Account_History__c> accountHistoryToUpdate = new List<Account_History__c>();
        
        //Update new values that are approved and update
        if(accountsProcessedFromApproval != null && !accountsProcessedFromApproval.isEmpty()){
            
            Map<String, List<Account_History__c>> accountIdVsHistoryMap = new Map<String, List<Account_History__c>>();
            
            for(Account_History__c history : [Select Id, Field__c, Field_Api_Name__c, Old_Value__c, New_Value__c, Account__c 
                                              From Account_History__c 
                                              Where Approval_Status__c = 'Pending' AND Account__c IN :accountsProcessedFromApproval]){
                                                  
                                                  if(accountIdVsHistoryMap.isEmpty() || !accountIdVsHistoryMap.containsKey(history.Account__c)){
                                                      
                                                      accountIdVsHistoryMap.put(history.Account__c, new List<Account_History__c>{});
                                                  }
                                                  
                                                  accountIdVsHistoryMap.get(history.Account__c).add(history);                    
                                              }
            
            if(!accountIdVsHistoryMap.isEmpty()){
                
                for(Account acct : accountsProcessedFromApproval){
                    
                    if(!accountIdVsHistoryMap.containsKey(acct.Id)) continue;
                    
                    for(Account_History__c history : accountIdVsHistoryMap.get(acct.Id)){
                        
                        if(String.isNotEmpty(acct.Approval_Status__c) && acct.Approval_Status__c.equals('Approved')){
                            
                            String fieldType = String.valueOf(accountFields.get(history.Field_Api_Name__c).getDescribe().getSOAPType());
                            
                            if(String.isEmpty(history.New_Value__c)){
                                
                                acct.put(history.Field_Api_Name__c, null);
                                
                            } else if(fieldType.equalsIgnoreCase('ID') || fieldType.equalsIgnoreCase('String')){
                                
                                acct.put(history.Field_Api_Name__c, String.valueOf(history.New_Value__c));
                                
                            } else if(fieldType.equalsIgnoreCase('Integer')){
                                
                                acct.put(history.Field_Api_Name__c, Integer.valueOf(history.New_Value__c));
                                
                            } else if(fieldType.equalsIgnoreCase('Double')){
                                
                                acct.put(history.Field_Api_Name__c, Double.valueOf(history.New_Value__c));
                                
                            } else if(fieldType.equalsIgnoreCase('Boolean')){
                                
                                acct.put(history.Field_Api_Name__c, Boolean.valueOf(history.New_Value__c));
                                
                            } else if(fieldType.equalsIgnoreCase('Date')){
                                
                                acct.put(history.Field_Api_Name__c, Date.valueOf(history.New_Value__c));
                                
                            } else if(fieldType.equalsIgnoreCase('DateTime')){
                                
                                acct.put(history.Field_Api_Name__c, DateTime.valueOf(history.New_Value__c));
                                
                            }
                            
                            
                            history.Approval_Status__c = 'Approved';
                            
                        } else {
                            
                            history.Approval_Status__c = 'Rejected';
                        }
                        
                        accountHistoryToUpdate.add(history);
                        
                    }
                }
                
                if(!accountHistoryToUpdate.isEmpty()){
                    
                    update accountHistoryToUpdate;
                    
                    //UPDATES
                    syncAccount(accountsProcessedFromApproval, 'PUT');
                }
                
            }
        }
        
    }
    
    
}