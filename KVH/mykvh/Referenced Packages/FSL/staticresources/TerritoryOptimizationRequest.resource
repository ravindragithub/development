"use strict";

function TerritoryOptimizationRequest(sobject) {
    this.id = sobject.Id;
    this.optimizationRequest = sobject[fieldNames.TerritoryOptimizationRequest.OptimizationRequest] || null;
    this.serviceTerritory = sobject[fieldNames.TerritoryOptimizationRequest.ServiceTerritory] || null;
}