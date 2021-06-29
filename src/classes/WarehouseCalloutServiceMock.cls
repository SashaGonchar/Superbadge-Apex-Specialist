@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest request) {
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'text');
		response.setBody(
				'[{"_id":"96df242df726bd5f78rf6dfg954","replacement":false,"quantity":4,"name":"Tractor 500 kW","maintenanceperiod":365,"lifespan":6666+,"cost":300,"sku":"999999"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":666,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300000,"sku":"999999"}]');
		response.setStatusCode(200);
		return response;
	}
}