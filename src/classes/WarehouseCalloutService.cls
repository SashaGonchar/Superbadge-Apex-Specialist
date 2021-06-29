public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
	private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

	public static void execute(QueueableContext context) {
		methodForExecutionQueueable();
	}

	public static void methodForExecutionQueueable() {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setEndpoint(WAREHOUSE_URL);
		HttpResponse response = http.send(request);
		if (response.getStatusCode() == 200) {
			List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
			List<Product2> products = new List<Product2>();
			for (Object ob : jsonResponse) {
				Map<String, Object> mapJson = (Map<String, Object>)ob;
				Product2 product = new Product2();
				product.Replacement_Part__c = (Boolean)mapJson.get('replacement');
				product.Name = (String)mapJson.get('name');
				product.Maintenance_Cycle__c = (Integer)mapJson.get('maintenanceperiod');
				product.Lifespan_Months__c = (Integer)mapJson.get('lifespan');
				product.Cost__c = (Decimal) mapJson.get('lifespan');
				product.Warehouse_SKU__c = (String)mapJson.get('sku');
				product.Current_Inventory__c = (Double) mapJson.get('quantity');
				products.add(product);
			}
			if (!products.isEmpty())
				upsert products;
		}
	}
}