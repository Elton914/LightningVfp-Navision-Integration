@isTest
global class MockResponseRestAPiUtility_Fail implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
 
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"responseCode": false,"responseDescription":"fail"}');
        res.setStatusCode(400);
        return res;
    }
    
    
   
}