@isTest
public class CreatingPatientControllerTest {

    @isTest
    static void testPatientCreationSuccess() {
        // Test data setup
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Appointment_Date__c = Date.today());
            // Set other required fields for Contact
        

        // Call the patientcreationmethod
        Test.startTest();
        String result = Creatingpatientcontroller.patientcreationmethod(testContact);
        Test.stopTest();

        // Assertions
        System.assertEquals('success', result, 'Expected successful insertion');
        // Add more assertions as needed to verify other aspects of the method's behavior.
    }

    @isTest
    static void testPatientCreationError() {
        // Test data setup with invalid data that should cause an exception
        Contact testContact = new Contact(
            // Incomplete or invalid data that should cause an error
        );

        // Call the patientcreationmethod
        Test.startTest();
        String result = Creatingpatientcontroller.patientcreationmethod(testContact);
        Test.stopTest();

        // Assertions
        System.assertEquals('success', result, 'Expected an exception to be thrown');
        // Add more assertions as needed to verify other aspects of the method's error handling.
    }

    // Add more test methods to cover other scenarios and edge cases.
}