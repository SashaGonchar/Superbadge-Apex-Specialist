@isTest
public with sharing class WarehouseSyncScheduleTest {

	@IsTest
	static void testScheduledJob() {
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		Test.startTest();
		String jobId = System.schedule('WarehouseSyncScheduleJob', '00 00 1 * * ?', new WarehouseSyncSchedule());
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		system.assertEquals(jobId, ct.Id);
		Test.stopTest();
	}
}