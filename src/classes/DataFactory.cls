public class DataFactory {
	public static Vehicle__c buildVehicle(Integer iteration) {
		Vehicle__c vehicle = new Vehicle__c(
				Name = 'TESTOVICH ' + iteration);
		return vehicle;
	}

	public static Case buildCase(Id vehicleId) {
		Case maintenanceRequest = new Case(
				Status = 'New',
				Origin = 'Web',
				Type = 'Routine Maintenance',
				Vehicle__c = vehicleId
		);
		return maintenanceRequest;
	}
}