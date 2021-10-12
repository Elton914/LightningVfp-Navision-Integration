public class RestApiUtility {

    public static Id recordId;
    
    @future(callout=true)
    public static void updateRecordsInNavision(String jsonBody, String objRecordId, String requestType){
System.debug('IN HERE requestType--'+requestType);
        recordId = objRecordId;

        String customerEndpoint = System.Label.Navision_Customer_Endpoint;

        String token = getToken();
	System.debug('token --'+token);
    System.debug('customerEndpoint --'+customerEndpoint);
    System.debug('jsonBody --'+jsonBody);
        
        if(String.isEmpty(customerEndpoint) && String.isEmpty(jsonBody) 
        || String.isEmpty(token) || String.isEmpty(requestType)) return;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(customerEndpoint);
        req.setMethod(requestType);
        req.setBody(jsonBody);
          System.debug(' jsonBody----'+jsonBody);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
		req.setTimeout(120000);
        Http http = new Http();
        system.debug('=======================>'+req);
        HTTPResponse res = http.send(req);
		System.debug('res ----'+res);
        System.debug('res getBody----'+res.getBody());
        System.debug('res  getStatus----'+res.getStatus());
        
        if(res.getStatusCode() == 200){

            // handle response
            System.debug('Callout Result: '+res.getBody());
              System.debug('res  requestType----'+requestType);
      
              System.debug('res  res.getBody()----'+res.getBody());
      

            if(requestType.equals('POST') && String.isNotEmpty(res.getBody())){

                Map<String, Object> resBodyMap = new Map<String, Object>();
                resBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                if(!resBodyMap.isEmpty() && resBodyMap.containsKey('responseDescription') && resBodyMap.get('responseDescription') != null){

                    Account acctToUpdate = [Select Id, Navision_Customer_ID__c From Account Where Id = :objRecordId];

                    acctToUpdate.Navision_Customer_ID__c = (String) resBodyMap.get('responseDescription');

                    update acctToUpdate;
                }
            }

        } else {

            handleApiErrors(req, res);
        }
    }

    public static String getToken(){

       
        
        String tokenEndpoint = System.Label.Navision_Token_Endpoint;
        String username = System.Label.Navision_Api_Username;
        String password = System.Label.Navision_Api_Password;

        if(String.isEmpty(tokenEndpoint) || String.isEmpty(username) || String.isEmpty(password)) return null;

        String reqBody = '{"username":"'+ username +'","password":"'+ password + '"}';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint);
        req.setMethod('POST');
        req.setBody(reqBody);
        req.setHeader('Content-Type', 'application/json');
		  System.debug(reqBody);
        System.debug(req);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if (Test.isRunningTest())
        {
            return 'testtoken';
        }
        
        return res.getStatusCode() == 200 ? res.getBody() : handleApiErrors(req, res);
    }


    public static String handleApiErrors(HttpRequest req, HTTPResponse res){

        Map<String, Object> reqBodyMap = new Map<String, Object>();
        Map<String, Object> resBodyMap = new Map<String, Object>();

        // reqBodyMap = (Map<String, Object>) JSON.deserializeUntyped(req.getBody());
        resBodyMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        String objQuery = 'Select Id, Name From ' + recordId.getSobjectType().getDescribe().getName() + ' Where Id = \'' + recordId + '\'';
        SObject record = (SObject) Database.query(objQuery);
     
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Error_Description__c = resBodyMap != null && resBodyMap.containsKey('errors') ? JSON.serialize(resBodyMap.get('errors')) : null;
        errorLog.JSON_Sent__c = req != null ? req.getBody() : null;
        errorLog.JSON_Received__c = res != null ? res.getBody() : null;

        if(recordId.getSobjectType().getDescribe().getName().equalsIgnoreCase('Account')){

            errorLog.Account_Name__c = (String) record.get('Name');
            errorLog.Account__c = recordId;
        }
        
        // errorLog.Record_Name__c = reqBodyMap.containsKey('name') ? (String) reqBodyMap.get('name') : null;

        insert errorLog;

        String errorObjQuery = 'Select ';
        SObjectType erroLogObject = Schema.getGlobalDescribe().get('Error_Log__c');
        Map<String,Schema.SObjectField> errorFields = erroLogObject.getDescribe().fields.getMap();

        for(Schema.SObjectField field : errorFields.values()){

            errorObjQuery = errorObjQuery + field.getDescribe().getName() + ', ';
        }

        errorObjQuery = errorObjQuery.removeEnd(', ') + ' From Error_Log__c Where Id = \''+errorLog.Id +'\'';

        Error_Log__c insertedErrorLog = Database.query(errorObjQuery);

        sendErrorMail(insertedErrorLog);

        return null;
    }

    public static void sendErrorMail(Error_Log__c errorLog){

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Errors occurred during API request.');
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSaveAsActivity(false);
        String errormessage = buildCsvBodyForErrors(errorLog);
        mail.setPlainTextBody('Hi,\nPlease find the error file below\n\n'+errormessage);
        mail.setHtmlBody('Hi,<br/>Please find the error file below<br/><br/><br/>'+errormessage);
        // Create error csv file as attachment for email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();  
        attachment.setBody(Blob.valueOf(errormessage));
        attachment.setContentType('text/csv');  
        attachment.setFileName('Errors.csv');  
        attachment.setinline(false);  
        
        // Setting CSV error file as attachment for email.
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


    public static String buildCsvBodyForErrors (Error_Log__c errorLog){

        System.debug('Name**'+errorLog.Name);
        System.debug('Name*****'+errorLog.get('Name'));

        SObjectType erroLogObject = Schema.getGlobalDescribe().get('Error_Log__c');
        Map<String,Schema.SObjectField> errorFields = erroLogObject.getDescribe().fields.getMap();
        
        // Header of error CSV file.
        // String csvColumnHeader = 'S.No,Error Line, Error Message\n';
        String csvColumnHeader = 'S.No';

        // List of all the error details.
        List<String> csvRowData = new List<String>();
        
        // Store index of each error.
        Integer index = 1;

        String rowStr = String.valueOf(index);

        if(errorLog == null || errorFields == null || errorFields.isEmpty()) return 'Error occured creating csv file';

        for(Schema.SObjectField field : errorFields.values()){

            if(field.getDescribe().isCustom() || field.getDescribe().getName().equals('Name') || field.getDescribe().getName().equals('Id')){

                csvColumnHeader = csvColumnHeader + ', ' + field.getDescribe().getLabel();

                String fieldValue = errorLog.get(field) != null ? (String) errorLog.get(field) : '';

                rowStr = rowStr + ',' + fieldValue.escapeCsv();

            }
        }
        
        csvRowData.add(rowStr);
        
        index++;
        
        
        // Complete body of CSV file.
        String csvFile = csvColumnHeader + '\n' + String.join(csvRowData,'\n');
        
        return csvFile;
        
    }

}