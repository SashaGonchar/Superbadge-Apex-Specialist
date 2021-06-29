public with sharing class MaintenanceRequestHelper {

	public static void updateWorkOrders(List<Case> Cases) {
		Integer iteration = 0;
		List<Case> newCases = new List<Case>();
		List<Equipment_Maintenance_Item__c> EquipmentMaintenanceItems = [SELECT Id, Maintenance_Request__c, Equipment__c, Quantity__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN: Cases];
		List<Aggregateresult> aggregationResults = new List<Aggregateresult>(
				[SELECT MIN(Equipment__r.Maintenance_Cycle__c)MinimumValue FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN: Cases]);
		List<Equipment_Maintenance_Item__c> newEquipMainItem = new List<Equipment_Maintenance_Item__c>();
		for (Case c : Cases) {
			if (c.Status == 'Closed' && (c.type == 'Repair' || c.type == 'Routine Maintenance')) {
				Case caseFirst = new Case(
						Status = 'New',
						Vehicle__c = c.Vehicle__c,
						Type = 'Routine Maintenance',
						Subject = 'Routine Checkup',
						Date_Reported__c = Date.today(),
						Product__c = c.Product__c,
						AccountId = c.AccountId,
						ContactId = c.ContactId,
						Origin = c.Origin,
						Date_Due__c = Date.today()
				);
				newCases.add(caseFirst);
				for (Equipment_Maintenance_Item__c emi : EquipmentMaintenanceItems) {
					if (c.Id == emi.Maintenance_Request__c) {
						newEquipMainItem.add(new Equipment_Maintenance_Item__c(
								Equipment__c = emi.Equipment__c,
								Maintenance_Request__c = c.Id,
								Quantity__c = emi.Quantity__c));
					}
				}
				for (Aggregateresult r : aggregationResults) {
					if (r.get('MinimumValue') != NULL) {
						newCases[iteration].Date_Due__c = System.today() + Integer.valueof(r.get('MinimumValue'));
					}
					iteration++;
				}
			}
		}
		if (newCases.size() > 0) {
			insert newCases;
		}
		for (Case cacsSecond : newCases) {
			for (Equipment_Maintenance_Item__c emi : newEquipMainItem) {
				emi.Maintenance_Request__c = cacsSecond.id;
			}
		}
		insert newEquipMainItem;
	}
}