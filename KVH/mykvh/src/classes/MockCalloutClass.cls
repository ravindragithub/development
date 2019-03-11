@isTest
global class MockCalloutClass implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id" : "12"}');
        res.setStatusCode(200);
        return res;
    }

}