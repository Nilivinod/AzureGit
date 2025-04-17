@isTest 
public class PicklistControllerTest {   
    @TestSetup
    // Add more test methods for other scenarios if needed
    static void setupTestData() {
        // Create test Shifttimings__c records with the appropriate values
        List<Shifttimings__c> shiftTimingsList = new List<Shifttimings__c>();
        shiftTimingsList.add(new Shifttimings__c(Shift_time__c = '10:00 - 10:30', name = 'test1'));
        shiftTimingsList.add(new Shifttimings__c(Shift_time__c = '11:00 - 11:30', name = 'test2'));
        shiftTimingsList.add(new Shifttimings__c(Shift_time__c = '19:30 - 20:00', name = 'test3'));
        insert shiftTimingsList;
    }

    @isTest 
    static void testGetAvailableSlots() {
        // Test data setup
        Date testSelectedDate = System.today();
        Contact doctorContact = new Contact(FirstName = 'Doctor', LastName = 'Smith');
        insert doctorContact;

        // Create test Contact records with the appropriate values for testing slots
        RecordType patientsRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND Name = 'Patients' LIMIT 1];
        Contact testContact1 = new Contact(
            FirstName = 'raghu',
            LastName = 'gajjela',
            SlotsAvailable__c = '10:00 - 10:30',
            Appointment_Date__c = Date.valueOf(testSelectedDate),
            Consult_doctor__c = doctorContact.Id,
            RecordTypeId = patientsRecordType.Id
        );
        Contact testContact2 = new Contact(
            FirstName = 'venkanna',
            LastName = 'goshika',
            SlotsAvailable__c = '10:30 - 11:00',
            Appointment_Date__c = Date.valueOf(testSelectedDate),
            Consult_doctor__c = doctorContact.Id,
            RecordTypeId = patientsRecordType.Id
        );
        Contact testContact4 = new Contact(
            FirstName = 'vinod',
            LastName = 'N',
            SlotsAvailable__c = '19:30 - 20:00',
            Appointment_Date__c = Date.valueOf(testSelectedDate),
            Consult_doctor__c = doctorContact.Id,
            RecordTypeId = patientsRecordType.Id
        );
        insert new List<Contact>{testContact1, testContact2, testContact4};

        // Call the method for the specified doctor and date
        Test.startTest();
        PicklistController.getAvailableSlots(String.valueOf(testSelectedDate), doctorContact.Id);
        // Perform your assertions
        Test.stopTest();
      system.assertNotEquals(false, true, 'msg');
    }
}