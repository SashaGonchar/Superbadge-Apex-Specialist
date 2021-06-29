@isTest
public with sharing class MaintenanceRequestHelperTest {
	@isTest static void createRequest() {
		Vehicle__c testVehicle = new Vehicle__c (Name = 'Test Vehicle');
		insert testVehicle;

		List<Case> existingMRs = new List<Case>();
		for (integer iteration = 0;iteration < 320;iteration++) {
			Case existingMR = new Case();
			if (iteration >= 300) {
				existingMR.Type = 'Electrical';
			} else {
				existingMR.Type = 'Repair';
			}
			existingMR.Status = 'New';
			existingMR.Origin = 'Web';
			existingMR.Subject = string.valueOf(iteration);
			existingMR.Description = 'Test Description' + string.valueOf(iteration);
			existingMRs.add(existingMR);

		}
		if (existingMRs.size() > 0)
			insert existingMRs;

		Product2 testEquipmentFirst = new Product2();
		testEquipmentFirst.Maintenance_Cycle__c = 15;
		testEquipmentFirst.Name = 'Test Equipment';
		testEquipmentFirst.Replacement_Part__c = true;
		insert testEquipmentFirst;

		Product2 testEquipmentSecond = new Product2();
		testEquipmentSecond.Maintenance_Cycle__c = 10;
		testEquipmentSecond.Name = 'Test Equipment 2';
		testEquipmentSecond.Replacement_Part__c = true;
		insert testEquipmentSecond;

		Test.startTest();
		List<Case> insertedMRs = [SELECT ID, Subject, Status FROM Case LIMIT 320];
		List<Case> updatedMRs = new List<Case>();
		Map<Integer, ID> insertedMRMap = new Map<Integer, ID>();
		for (Case caseRecordForInsert : insertedMRs) {
			insertedMRMap.put(Integer.valueOf(caseRecordForInsert.Subject), caseRecordForInsert.ID);
			caseRecordForInsert.Status = 'Closed';
			updatedMRs.add(caseRecordForInsert);
		}
		List<Equipment_Maintenance_Item__c> EMIs = new List<Equipment_Maintenance_Item__c>();
		for (Integer iteration = 0;iteration < 320;iteration++) {
			Equipment_Maintenance_Item__c testEMI = new Equipment_Maintenance_Item__c();
			testEMI.Equipment__c = testEquipmentFirst.Id;
			testEMI.Maintenance_Request__c = insertedMRMap.get(iteration);
			testEMI.Quantity__c = 2;
			EMIs.add(testEMI);
			if (iteration < 50) {
				Equipment_Maintenance_Item__c testEMI2 = new Equipment_Maintenance_Item__c();
				testEMI2.Equipment__c = testEquipmentSecond.Id;
				testEMI2.Maintenance_Request__c = insertedMRMap.get(iteration);
				testEMI2.Quantity__c = 1;
				EMIs.add(testEMI2);
			}
		}
		if (!EMIs.isEmpty())
			insert EMIs;
		if (!updatedMRs.isEmpty())
			update updatedMRs;
		Test.stopTest();
		List<Case> createdMRs =
				new List<Case>([SELECT ID, Date_Due__c, Date_Reported__c FROM Case WHERE Type='Routine Maintenance']);
		List<Case> dueDates = new List<Case>();
		for (Case caseRec : createdMRs) {
			Date reportedDate = caseRec.Date_Reported__c;
			Date dueDate = caseRec.Date_Due__c;
			integer difference = reportedDate.daysBetween(dueDate);
			if (difference == 10)
				dueDates.add(caseRec);
		}
		System.AssertEquals(createdMRs.size(), 300);
		System.AssertEquals(dueDates.size(), 300);
	}
}