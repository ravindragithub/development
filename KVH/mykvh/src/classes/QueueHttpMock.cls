@isTest
public with sharing class QueueHttpMock implements HttpCalloutMock{
  HttpResponse[] responses = new HttpResponse[0];     //This is the response queue
  public void addResponse(HttpResponse response) {    //this method adds a response to the queue
    responses.add(response);
  }
  public HttpResponse respond(HttpRequest request) {  //this method returns the current response and removes it from queue
    return responses.remove(0);
  }
}