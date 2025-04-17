@isTest
public class ContactWithImageController2Test {
    @isTest
    static void testTrackingApp() {
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patients').getRecordTypeId()
        );
        insert testContact;

        List<Contact> result = ContactWithImageController2.trackingApp('john.doe@example.com');
        System.assertEquals(1, result.size(), 'Incorrect result size');
       // System.assertEquals('John', result[0].FirstName, 'Incorrect first name');
    }

    @isTest
    static void testCancelAppointment() {
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@example.com',
            SlotsAvailable__c='10:00 - 10:30',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patients').getRecordTypeId()
        );
        insert testContact;

        testContact = [SELECT Id, SlotsAvailable__c, Status__c, Email, CancelledSlot__c FROM Contact WHERE Id = :testContact.Id];

        System.assertNotEquals(null, testContact.SlotsAvailable__c, 'SlotsAvailable__c should not be null');

        List<Contact> result = ContactWithImageController2.cancelAppointment(testContact.Id, testContact.Email);
        System.assertEquals(1, result.size(), 'Incorrect result size');
        System.assertEquals('Expired/Cancelled', result[0].Status__c, 'Incorrect status');
        System.assertEquals(testContact.SlotsAvailable__c, result[0].CancelledSlot__c, 'Incorrect cancelled slot');
        System.assertEquals(null, result[0].SlotsAvailable__c, 'SlotsAvailable__c should be null');
    }

    @isTest
    static void testGetContacts() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact1 = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Doctors').getRecordTypeId(),
            Specialty__c = 'ENT',
            Location__c = 'Mumbai'
        );
        insert testContact1;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'My Document'; // Set the title of the document
        cv.PathOnClient = 'MyFolder/MyDocument.txt'; // Set the path on the client (file name with folder structure)
        cv.VersionData = Blob.valueOf('This is the content of the document.'); // Set the content of the document
        cv.FirstPublishLocationId = testContact1.id; // Set the ID of the record associated with the content (if applicable)
        cv.ContentLocation = 'S'; // Specify 'S' for Salesforce Files, 'E' for External File, or 'L' for Large Asset File
        //cv.FileType = 'txt'; // Set the file type (e.g., txt, pdf, docx)
        
        insert cv; // Insert the ContentVersion record

        // ... (similar setup for testContact2)

        List<ContactWithImageController2.ContactWithImageData> result1 = ContactWithImageController2.getContacts('John', 'ENT', 'Mumbai');
        List<ContactWithImageController2.ContactWithImageData> result2 = ContactWithImageController2.getContacts('John', null, 'Mumbai');
        System.assertEquals(1, result1.size(), 'Incorrect result size');
        System.assertEquals('John', result1[0].FirstName, 'Incorrect first name');
        System.assertEquals(1, result2.size(), 'Incorrect result size');
        System.assertEquals('John', result2[0].FirstName, 'Incorrect first name');

        

        // ... (similar assertions for other test cases)
    }
}