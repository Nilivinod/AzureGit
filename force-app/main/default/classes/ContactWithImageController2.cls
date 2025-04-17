/**
* @description Class helps to manage contacts with images and appointments.
* @Author Vinod Nili
* @Last Modified By Vinod Nili
* @Last Modified On 28/07/2023
* @Modification Log
* Ver    Date        Author             Last Modification
* 1.0    26/06/2023  Vinod Nili         Initial Version
**/
public with sharing class ContactWithImageController2 {
    
    /**
* @description Retrieves a list of patient contacts based on the provided email.
* @param email The email address to search for patient contacts.
* @return A list of patient contacts matching the provided email.
*/
    @AuraEnabled(cacheable=true)
    public static List<Contact> trackingApp(string email) {
        email = '%' + String.escapeSingleQuotes(email) + '%';
        return [SELECT Id, Email, Name, Appointment_Date__c, SlotsAvailable__c, Status__c, CancelledSlot__c, Consult_doctor__r.Name
                FROM Contact WHERE Email LIKE :email AND RecordType.Name = 'Patients' WITH SECURITY_ENFORCED];
    }
    
    /**
* @description Cancels an appointment for a Contact record.
* @param aptId The ID of the appointment.
* @param em The email associated with the appointment.
* @return A list of updated Contact records.
*/
    @AuraEnabled
    public static List<Contact> cancelAppointment(string aptId, string em) {
        List<Contact> updatedContacts = new List<Contact>();
        aptId = String.escapeSingleQuotes(aptId);
        em = String.escapeSingleQuotes(em);
        
        // Implementation details...
        Contact con = [SELECT Id, Appointment_Date__c, Status__c, CancelledSlot__c, SlotsAvailable__c
                       FROM Contact WHERE Id = :aptId AND RecordType.Name = 'Patients' WITH SECURITY_ENFORCED];
        
        con.Status__c = 'Expired/Cancelled';
        con.CancelledSlot__c = con.SlotsAvailable__c;
        con.SlotsAvailable__c = '';
        
        if (Schema.sObjectType.Contact.isUpdateable()) {
            database.update(con, false);
        }
        
        updatedContacts = [SELECT Id, Email, Name, Appointment_Date__c, SlotsAvailable__c, Status__c, CancelledSlot__c, Consult_doctor__r.Name
                           FROM Contact WHERE Email LIKE :em AND RecordType.Name = 'Patients' WITH SECURITY_ENFORCED];
        
        return updatedContacts;
    }
    
    /**
* @description Retrieves a list of Contact records with image data.
* @param searchval01 The search value for contact name.
* @param searchval02 The search value for specialty.
* @param searchval03 The search value for location.
* @return A list of Contact records with image data.
*/
    @AuraEnabled(cacheable=true)
    public static List<ContactWithImageData> getContacts(string searchval01, string searchval02, string searchval03) {
        List<ContactWithImageData> contactsWithImageData = new List<ContactWithImageData>();
        
        searchval01 = '%' + String.escapeSingleQuotes(searchval01) + '%';
        searchval02 = sanitizeValue(searchval02);
        searchval03 = String.escapeSingleQuotes(searchval03);
        
        String query = constructQuery(searchval01, searchval02, searchval03);
        set<Id> doctorRecordTypeId = new set<Id>();
        doctorRecordTypeId.add(Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Doctors').getRecordTypeId());
        query += ' AND RecordTypeId IN: doctorRecordTypeId WITH SECURITY_ENFORCED';
        
        List<Contact> contacts = Database.query(String.escapeSingleQuotes(query));
        Map<Id, ContentVersion> contentVersionMap = getContentVersionMap();
        
        for (Contact contact : contacts) {
            ContentVersion cv = getContentVersion(contact, contentVersionMap);
            contactsWithImageData.add(new ContactWithImageData(contact, cv));
        }
        
        return contactsWithImageData;
    }
    
        /**
* @description Cancels an appointment for a Contact record.
* @param value The ID of the appointment.
* @return A list of updated Contact records.
*/
    private static String sanitizeValue(String value) {
        return String.isBlank(value) ? null : String.escapeSingleQuotes(value);
    }
    
    
        /**
* @description Retrieves a list of Contact records with image data.
* @param searchval01 The search value for contact name.
* @param searchval02 The search value for specialty.
* @param searchval03 The search value for location.
* @return A list of Contact records with image data.
*/
    private static String constructQuery(String searchval01, String searchval02, String searchval03) {
        String query = 'SELECT Id, FirstName,Name, LastName, MailingPostalCode, Account.Name, AccountId,RecordTypeId, Years_of_experience__c, Specialty__c, Email, Location__c, (SELECT Id, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks) FROM Contact WHERE';
        
       query +=  String.isNotBlank(searchval01)?' Name LIKE :searchval01':'';
       query += String.isNotBlank(searchval02) ? ' AND Specialty__c = :searchval02' : '';
        query += String.isBlank(searchval02) && String.isNotBlank(searchval03) ? ' AND Location__c = :searchval03' : '';
        query += String.isNotBlank(searchval02) && String.isNotBlank(searchval03) ? ' AND Specialty__c = :searchval02 AND Location__c = :searchval03' : '';
        return query;
    }
    
        /**
* @description Retrieves a list of Contact records with image data.
* @return A list of Contact records with image data.
*/
    
    private static Map<Id, ContentVersion> getContentVersionMap() {
        Map<Id, ContentVersion> contentVersionMap = new map<Id, ContentVersion>();
        List<ContentVersion> contentVersions = [
            SELECT VersionData, FileType, ContentDocumentId
            FROM ContentVersion WITH SECURITY_ENFORCED
        ];
        
        for (ContentVersion cv : contentVersions) {
            contentVersionMap.put(cv.ContentDocumentId, cv);
        }
        
        return contentVersionMap;
    }
        /**
* @description Retrieves a list of Contact records with image data.
* @param contact The search value for contact name.
* @param contentVersionMap The search value for specialty.

* @return A list of Contact records with image data.
*/
    
    private static ContentVersion getContentVersion(Contact contact, Map<Id, ContentVersion> contentVersionMap) {
        if (contact.ContentDocumentLinks.size() > 0) {
            ContentDocumentLink cdl = contact.ContentDocumentLinks[0];
            return contentVersionMap.get(cdl.ContentDocumentId);
        } else {
            return null;
        }
    }
    
    
    /**
* @description
* Inner class to hold Contact data with image information.
*/
    public class ContactWithImageData {
        @AuraEnabled public String id;
        @AuraEnabled public String firstName;
        @AuraEnabled public string postalcode;
        @AuraEnabled public String lastName;
        @AuraEnabled public Decimal yearsofexp;
        @AuraEnabled public String accountName;
        @AuraEnabled public String email;
        @AuraEnabled public String imageData;
        @AuraEnabled public String imageFileType;
        @AuraEnabled public string location;
        @AuraEnabled public string specialty;
        @AuraEnabled public string accountId;
        /**
* @description
* @param contact The contact of the appointment.
* @param cv The email Doc with the appointment.
* Inner class to hold Contact data with image information.
*/
        public ContactWithImageData(Contact contact, ContentVersion cv) {
            id = contact.Id;
            accountName = contact.Account.Name;
            firstName = contact.FirstName;
            postalcode = contact.MailingPostalCode;
            lastName = contact.LastName;
            yearsofexp = contact.Years_of_experience__c;
            email = contact.Email;
            location = contact.Location__c;
            specialty = contact.Specialty__c;
            accountId = contact.AccountId;
            
            if (cv != null) {
                imageData = EncodingUtil.base64Encode(cv.VersionData);
                imageFileType = cv.FileType;
            }
        }
    }
}