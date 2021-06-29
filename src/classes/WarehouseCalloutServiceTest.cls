@IsTest
private class WarehouseCalloutServiceTest {

	@isTest static void testGetCallout() {
		Product2 testEquipment = new Product2();
		testEquipment.Maintenance_Cycle__c = 10;
		testEquipment.Name = 'Test Equipment 2';
		testEquipment.Replacement_Part__c = true;
		testEquipment.Warehouse_SKU__c = '999999';
		insert testEquipment;
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		Test.startTest();
		System.enqueueJob(new WarehouseCalloutService());
		Test.stopTest();
	}
}