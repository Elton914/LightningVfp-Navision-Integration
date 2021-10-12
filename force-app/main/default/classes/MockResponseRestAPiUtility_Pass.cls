@isTest
global class MockResponseRestAPiUtility_Pass implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
 
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"responseCode": true,"responseDescription":"C000001"}');
        res.setStatusCode(200);
        return res;
    }
    
    
   
}