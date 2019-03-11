@isTest
global class CCDS_MockTestsForInventoryCallouts {

    global class addReservedNumbersToOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addReservedNumbersToOrderResponse_element responseElement = new CCDS_Inventory.addReservedNumbersToOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateLineResponse_element responseElement = new CCDS_Inventory.updateLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class submitOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.submitOrderResponse_element responseElement = new CCDS_Inventory.submitOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisByOrderIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisByOrderIdResponse_element responseElement = new CCDS_Inventory.getEntityAnisByOrderIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisForStatusMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisForStatusResponse_element responseElement = new CCDS_Inventory.getEntityAnisForStatusResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addAniWithBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AddLineWithBtnReturn  invData = new CCDS_Inventory.AddLineWithBtnReturn ();
               CCDS_Inventory.addAniWithBtnResponse_element responseElement = new CCDS_Inventory.addAniWithBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class terminateCustomerItemMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.terminateCustomerItemResponse_element responseElement = new CCDS_Inventory.terminateCustomerItemResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getFidsForAddLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineFidDetailReturn  invData = new CCDS_Inventory.LineFidDetailReturn ();
               CCDS_Inventory.getFidsForAddLineResponse_element responseElement = new CCDS_Inventory.getFidsForAddLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityBtnsByCustomerNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.BtnReturn  invData = new CCDS_Inventory.BtnReturn ();
               CCDS_Inventory.getEntityBtnsByCustomerNumberResponse_element responseElement = new CCDS_Inventory.getEntityBtnsByCustomerNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addMultipleAnisMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addMultipleAnisResponse_element responseElement = new CCDS_Inventory.addMultipleAnisResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getCustomerItemsForLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.CustomerItemReturn  invData = new CCDS_Inventory.CustomerItemReturn ();
               CCDS_Inventory.getCustomerItemsForLineResponse_element responseElement = new CCDS_Inventory.getCustomerItemsForLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class terminateLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.terminateLineResponse_element responseElement = new CCDS_Inventory.terminateLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateBtnLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateBtnLineResponse_element responseElement = new CCDS_Inventory.updateBtnLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getLineStatusOptionsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineStatusReturn  invData = new CCDS_Inventory.LineStatusReturn ();
               CCDS_Inventory.getLineStatusOptionsResponse_element responseElement = new CCDS_Inventory.getLineStatusOptionsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getAvailableNumbersSummaryMockImpl implements WebServiceMock {
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
               CCDS_Inventory.NumbersInventorySummaryReturn  invData = new CCDS_Inventory.NumbersInventorySummaryReturn ();
               CCDS_Inventory.getAvailableNumbersSummaryResponse_element responseElement = new CCDS_Inventory.getAvailableNumbersSummaryResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addVoipMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addVoipResponse_element responseElement = new CCDS_Inventory.addVoipResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAniMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniWithBtnReturn  invData = new CCDS_Inventory.AniWithBtnReturn ();
               CCDS_Inventory.getEntityAniResponse_element responseElement = new CCDS_Inventory.getEntityAniResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getFidsForOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.OrderFidDetailReturn  invData = new CCDS_Inventory.OrderFidDetailReturn ();
               CCDS_Inventory.getFidsForOrderResponse_element responseElement = new CCDS_Inventory.getFidsForOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisByOrderIdAndStatusMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisByOrderIdAndStatusResponse_element responseElement = new CCDS_Inventory.getEntityAnisByOrderIdAndStatusResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getNpaNxxForCustomerNumberAndStatusMockImpl implements WebServiceMock {
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
               CCDS_Inventory.NpaNxxReturn  invData = new CCDS_Inventory.NpaNxxReturn ();
               CCDS_Inventory.getNpaNxxForCustomerNumberAndStatusResponse_element responseElement = new CCDS_Inventory.getNpaNxxForCustomerNumberAndStatusResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateMultipleLineProvisioningOptionsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateMultipleLineProvisioningOptionsResponse_element responseElement = new CCDS_Inventory.updateMultipleLineProvisioningOptionsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateMultipleAnisMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateMultipleAnisResponse_element responseElement = new CCDS_Inventory.updateMultipleAnisResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addDocumentMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addDocumentResponse_element responseElement = new CCDS_Inventory.addDocumentResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addBtnResponse_element responseElement = new CCDS_Inventory.addBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getFidsByLineIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineFidDetailReturn  invData = new CCDS_Inventory.LineFidDetailReturn ();
               CCDS_Inventory.getFidsByLineIdResponse_element responseElement = new CCDS_Inventory.getFidsByLineIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class reserveAndAddNumberToOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.reserveAndAddNumberToOrderResponse_element responseElement = new CCDS_Inventory.reserveAndAddNumberToOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class deleteOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.deleteOrderResponse_element responseElement = new CCDS_Inventory.deleteOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getActiveOrdersForProspectIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.ActiveOrderNumberReturn  invData = new CCDS_Inventory.ActiveOrderNumberReturn ();
               CCDS_Inventory.getActiveOrdersForProspectIdResponse_element responseElement = new CCDS_Inventory.getActiveOrdersForProspectIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getLineProvisioningOptionsForLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineProvisioningOptionsReturn  invData = new CCDS_Inventory.LineProvisioningOptionsReturn ();
               CCDS_Inventory.getLineProvisioningOptionsForLineResponse_element responseElement = new CCDS_Inventory.getLineProvisioningOptionsForLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class terminateAniMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.terminateAniResponse_element responseElement = new CCDS_Inventory.terminateAniResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addItemMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addItemResponse_element responseElement = new CCDS_Inventory.addItemResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getAddressForLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineAddressReturn  invData = new CCDS_Inventory.LineAddressReturn ();
               CCDS_Inventory.getAddressForLineResponse_element responseElement = new CCDS_Inventory.getAddressForLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getActiveOrdersForExternalIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.ActiveOrderNumberReturn  invData = new CCDS_Inventory.ActiveOrderNumberReturn ();
               CCDS_Inventory.getActiveOrdersForExternalIdResponse_element responseElement = new CCDS_Inventory.getActiveOrdersForExternalIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisByCustomerNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisByCustomerNumberResponse_element responseElement = new CCDS_Inventory.getEntityAnisByCustomerNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisResponse_element responseElement = new CCDS_Inventory.getEntityAnisResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class startOrderWithExternalIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.startOrderWithExternalIdResponse_element responseElement = new CCDS_Inventory.startOrderWithExternalIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityBtnsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.BtnReturn  invData = new CCDS_Inventory.BtnReturn ();
               CCDS_Inventory.getEntityBtnsResponse_element responseElement = new CCDS_Inventory.getEntityBtnsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class itemSearchMockImpl implements WebServiceMock {
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
               CCDS_Inventory.ItemSearchReturn  invData = new CCDS_Inventory.ItemSearchReturn ();
               CCDS_Inventory.itemSearchResponse_element responseElement = new CCDS_Inventory.itemSearchResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getFidsForAddLineByProspectIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineFidDetailReturn  invData = new CCDS_Inventory.LineFidDetailReturn ();
               CCDS_Inventory.getFidsForAddLineByProspectIdResponse_element responseElement = new CCDS_Inventory.getFidsForAddLineByProspectIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getAvailableServicesForProspectOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.OrderServicesReturn  invData = new CCDS_Inventory.OrderServicesReturn ();
               CCDS_Inventory.getAvailableServicesForProspectOrderResponse_element responseElement = new CCDS_Inventory.getAvailableServicesForProspectOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getNumbersStatusByLineNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.NumbersStatusReturn  invData = new CCDS_Inventory.NumbersStatusReturn ();
               CCDS_Inventory.getNumbersStatusByLineNumberResponse_element responseElement = new CCDS_Inventory.getNumbersStatusByLineNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class deleteLineMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.deleteLineResponse_element responseElement = new CCDS_Inventory.deleteLineResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getMarketsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.MarketReturn  invData = new CCDS_Inventory.MarketReturn ();
               CCDS_Inventory.getMarketsResponse_element responseElement = new CCDS_Inventory.getMarketsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class changeNumbersStatusForOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.changeNumbersStatusForOrderResponse_element responseElement = new CCDS_Inventory.changeNumbersStatusForOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class deleteCustomerItemMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.deleteCustomerItemResponse_element responseElement = new CCDS_Inventory.deleteCustomerItemResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addOrUpdateFidMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addOrUpdateFidResponse_element responseElement = new CCDS_Inventory.addOrUpdateFidResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getCustomerItemsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.CustomerItemReturn  invData = new CCDS_Inventory.CustomerItemReturn ();
               CCDS_Inventory.getCustomerItemsResponse_element responseElement = new CCDS_Inventory.getCustomerItemsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.OrderReturn  invData = new CCDS_Inventory.OrderReturn ();
               CCDS_Inventory.getOrderResponse_element responseElement = new CCDS_Inventory.getOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateLineProvisioningOptionsMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateLineProvisioningOptionsResponse_element responseElement = new CCDS_Inventory.updateLineProvisioningOptionsResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addCustomerItemMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addCustomerItemResponse_element responseElement = new CCDS_Inventory.addCustomerItemResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getActiveOrdersForCustomerNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.ActiveOrderNumberReturn  invData = new CCDS_Inventory.ActiveOrderNumberReturn ();
               CCDS_Inventory.getActiveOrdersForCustomerNumberResponse_element responseElement = new CCDS_Inventory.getActiveOrdersForCustomerNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getFidsByLineIdAndFidIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LineFidDetailReturn  invData = new CCDS_Inventory.LineFidDetailReturn ();
               CCDS_Inventory.getFidsByLineIdAndFidIdResponse_element responseElement = new CCDS_Inventory.getFidsByLineIdAndFidIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addOptionalSubItemMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addOptionalSubItemResponse_element responseElement = new CCDS_Inventory.addOptionalSubItemResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.BtnReturn  invData = new CCDS_Inventory.BtnReturn ();
               CCDS_Inventory.getEntityBtnResponse_element responseElement = new CCDS_Inventory.getEntityBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class startOrderWithProspectIdMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.startOrderWithProspectIdResponse_element responseElement = new CCDS_Inventory.startOrderWithProspectIdResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class add800MockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.add800Response_element responseElement = new CCDS_Inventory.add800Response_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getNpaNxxForStatusMockImpl implements WebServiceMock {
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
               CCDS_Inventory.NpaNxxReturn  invData = new CCDS_Inventory.NpaNxxReturn ();
               CCDS_Inventory.getNpaNxxForStatusResponse_element responseElement = new CCDS_Inventory.getNpaNxxForStatusResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class reserveNumbersMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.reserveNumbersResponse_element responseElement = new CCDS_Inventory.reserveNumbersResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class maintainServicesOnProspectOrderMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.maintainServicesOnProspectOrderResponse_element responseElement = new CCDS_Inventory.maintainServicesOnProspectOrderResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateAniMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateAniResponse_element responseElement = new CCDS_Inventory.updateAniResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addAniMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.addAniResponse_element responseElement = new CCDS_Inventory.addAniResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class startOrderWithCustomerNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.startOrderWithCustomerNumberResponse_element responseElement = new CCDS_Inventory.startOrderWithCustomerNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getLinesByTypeAndFidValuesMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LinesReturn  invData = new CCDS_Inventory.LinesReturn ();
               CCDS_Inventory.getLinesByTypeAndFidValuesResponse_element responseElement = new CCDS_Inventory.getLinesByTypeAndFidValuesResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAnisByCustomerNumberAndStatusMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniReturn  invData = new CCDS_Inventory.AniReturn ();
               CCDS_Inventory.getEntityAnisByCustomerNumberAndStatusResponse_element responseElement = new CCDS_Inventory.getEntityAnisByCustomerNumberAndStatusResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getMarketsByNpaNxxMockImpl implements WebServiceMock {
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
               CCDS_Inventory.MarketReturn  invData = new CCDS_Inventory.MarketReturn ();
               CCDS_Inventory.getMarketsByNpaNxxResponse_element responseElement = new CCDS_Inventory.getMarketsByNpaNxxResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateMultipleLineAddressesMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateMultipleLineAddressesResponse_element responseElement = new CCDS_Inventory.updateMultipleLineAddressesResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getEntityAniByLineNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AniWithBtnReturn  invData = new CCDS_Inventory.AniWithBtnReturn ();
               CCDS_Inventory.getEntityAniByLineNumberResponse_element responseElement = new CCDS_Inventory.getEntityAniByLineNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class terminateBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.terminateBtnResponse_element responseElement = new CCDS_Inventory.terminateBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class addVoipWithBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.AddLineWithBtnReturn  invData = new CCDS_Inventory.AddLineWithBtnReturn ();
               CCDS_Inventory.addVoipWithBtnResponse_element responseElement = new CCDS_Inventory.addVoipWithBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class getLinesByLineNumberMockImpl implements WebServiceMock {
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
               CCDS_Inventory.LinesReturn  invData = new CCDS_Inventory.LinesReturn ();
               CCDS_Inventory.getLinesByLineNumberResponse_element responseElement = new CCDS_Inventory.getLinesByLineNumberResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class moveBtnMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.moveBtnResponse_element responseElement = new CCDS_Inventory.moveBtnResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    global class updateLineAddressMockImpl implements WebServiceMock {
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
               CCDS_Inventory.InventoryReturn  invData = new CCDS_Inventory.InventoryReturn ();
               CCDS_Inventory.updateLineAddressResponse_element responseElement = new CCDS_Inventory.updateLineAddressResponse_element();
               responseElement.return_x = invData ;
               response.put('response_x', responseElement); 
           }
    }
    
    
}