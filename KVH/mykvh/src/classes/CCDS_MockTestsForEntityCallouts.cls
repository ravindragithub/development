@isTest
global class CCDS_MockTestsForEntityCallouts {

    global class getByExternalIdMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityReturn  entityData = new CCDS_Entity.EntityReturn ();
               CCDS_Entity.getByExternalIdResponse_element responseElement  =new CCDS_Entity.getByExternalIdResponse_element();
               responseElement.return_x=entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getByProspectIdMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityReturn  entityData = new CCDS_Entity.EntityReturn ();
               CCDS_Entity.getByProspectIdResponse_element responseElement = new CCDS_Entity.getByProspectIdResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getContactsByExternalIdMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactReturn  entityData = new CCDS_Entity.EntityContactReturn ();
               CCDS_Entity.getContactsByExternalIdResponse_element responseElement = new CCDS_Entity.getContactsByExternalIdResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getContactsByCustomerNumberMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactReturn  entityData = new CCDS_Entity.EntityContactReturn ();
               CCDS_Entity.getContactsByCustomerNumberResponse_element responseElement = new CCDS_Entity.getContactsByCustomerNumberResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getAddressesMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityAddressReturn  entityData = new CCDS_Entity.EntityAddressReturn ();
               CCDS_Entity.getAddressesResponse_element responseElement = new CCDS_Entity.getAddressesResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getAddressesByCustomerNumberMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityAddressReturn  entityData = new CCDS_Entity.EntityAddressReturn ();
               CCDS_Entity.getAddressesByCustomerNumberResponse_element responseElement = new CCDS_Entity.getAddressesByCustomerNumberResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class search_xMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityReturn  entityData = new CCDS_Entity.EntityReturn ();
               CCDS_Entity.searchResponse_element responseElement = new CCDS_Entity.searchResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class deleteEntityContactsMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactReturn  entityData = new CCDS_Entity.EntityContactReturn ();
               CCDS_Entity.deleteEntityContactsResponse_element responseElement = new CCDS_Entity.deleteEntityContactsResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityContactTypesMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactTypeReturn  entityData = new CCDS_Entity.EntityContactTypeReturn ();
               CCDS_Entity.getEntityContactTypesResponse_element responseElement = new CCDS_Entity.getEntityContactTypesResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getByCustomerNumberMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityReturn  entityData = new CCDS_Entity.EntityReturn ();
               CCDS_Entity.getByCustomerNumberResponse_element responseElement = new CCDS_Entity.getByCustomerNumberResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateEntityContactsMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactReturn  entityData = new CCDS_Entity.EntityContactReturn ();
               CCDS_Entity.updateEntityContactsResponse_element responseElement = new CCDS_Entity.updateEntityContactsResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addEntityContactsMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityContactReturn  entityData = new CCDS_Entity.EntityContactReturn ();
               CCDS_Entity.addEntityContactsResponse_element responseElement = new CCDS_Entity.addEntityContactsResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    global class searchLimitedByZipCodeMockImpl implements WebServiceMock {
        global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               CCDS_Entity.EntityReturn  entityData = new CCDS_Entity.EntityReturn ();
               CCDS_Entity.searchLimitedByZipCodeResponse_element responseElement = new CCDS_Entity.searchLimitedByZipCodeResponse_element();
               responseElement.return_x = entityData ;
               response.put('response_x', responseElement); 
           }
    }
    
    
}