@isTest
public class RescheduleAppointmentcls_08_06_Test {
    @isTest
    static void testMethodgetappointments() {
        // Create test data
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@test.com', RecordType = new RecordType(Name = 'Patients'), SlotsAvailable__c='19:30 - 20:00', Appointment_Date__c=System.today());
        insert testContact;
        
        // Call the method to be tested
        List<Contact> result = RescheduleAppointmentcls_08_06.methodgetappointments('john.doe@test.com');
        
        // Assert the results
        System.assertEquals(1, result.size(), 'Incorrect number of results returned');
        System.assertEquals(testContact.Id, result[0].Id, 'Contact Id does not match');
    }
    
    @isTest
    static void testMethodslots() {
        // Test data setup
        Date testSelectedDate = System.today();
        
        // Create a doctor record
        Contact testDoctor = new Contact(FirstName = 'Doctor', LastName = 'Smith', Email = 'doctor@test.com', RecordType = new RecordType(Name = 'Doctors'));
        insert testDoctor;
        
        // Create test Contact records with the appropriate values for testing slots
        Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@test.com', 
                                           RecordType = new RecordType(Name = 'Patients'), SlotsAvailable__c='11:00 - 11:30',
                                           Appointment_Date__c=testSelectedDate, Consult_doctor__c=testDoctor.Id);
        Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', Email = 'jane.smith@test.com', 
                                           RecordType = new RecordType(Name = 'Patients'), SlotsAvailable__c='11:30 - 12:00',
                                           Appointment_Date__c=testSelectedDate, Consult_doctor__c=testDoctor.Id);
        insert new List<Contact>{testContact1,testContact2};
        
        // Create a Shifttimings__c record
        Shifttimings__c setting = new Shifttimings__c(Shift_time__c = '11:00 - 11:30', Name = 'Test1');
        insert setting;
        
        // Call the methodslots
        Test.startTest();
        List<String> result = RescheduleAppointmentcls_08_06.methodslots(String.valueOf(testSelectedDate), testDoctor.Id);
        Test.stopTest();
        
        System.assertEquals(0, result.size(), 'Slots were returned but expected none');
        // Add your assertions here to verify the results returned by the method
    }
    
    @isTest
    static void testConfirmingreschedulemethod() {
        // Create test data - Insert a Contact record to be queried
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@test.com', RecordType = new RecordType(Name = 'Patients'));
        insert testContact;
        
        // Call the method to be tested
        RescheduleAppointmentcls_08_06.confirmingreschedulemethod('2023-08-02', testContact.Id, '19:30 - 20:00');
        
        // Assert the results
        System.assertEquals(1, [SELECT COUNT() FROM Contact LIMIT 1], 'Contact was not updated as expected');
        // Add your assertions here to verify the results
    }
}