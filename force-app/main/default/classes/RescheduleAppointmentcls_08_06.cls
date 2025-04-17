/**
 * @description     : Class helps to manage contacts with images and appointments.
 * @Author          : Vinod Nili
 * @Last Modified By: Vinod Nili
 * @Last Modified On: 28/07/2023
 * @Modification Log:
 * Ver    Date        Author             Last Modification
 * 1.0    26/06/2023  Vinod Nili         Initial Version
 **/
public with sharing class RescheduleAppointmentcls_08_06 {
    /**
     * Retrieves a list of patient contacts based on the provided email.
     * @param email The email address to search for patient contacts.
     * @return A list of patient contacts matching the provided email.
     * @description
     */
    @AuraEnabled(Cacheable=true)
    public static list<Contact> methodgetappointments(string email) {
        // Implementation is provided in the original code
        email = '%' + String.escapeSingleQuotes(email) + '%';
        return [SELECT Id, Name, FirstName, LastName, Email, Phone, Appointment_Date__c, SlotsAvailable__c, Consult_doctor__c, Consult_doctor__r.Name, Consult_doctor__r.Specialty__c, Consult_doctor__r.Location__c, Consult_doctor__r.FirstName, Consult_doctor__r.LastName, Consult_doctor__r.Appointment_Date__c, Consult_doctor__r.SlotsAvailable__c
                FROM Contact WHERE Email LIKE :email AND RecordType.Name = 'Patients' WITH SECURITY_ENFORCED];
    }

    @AuraEnabled(Cacheable=true)
    /**
     * @description
     * Retrieves a list of available time slots for appointments based on the selected date and doctor ID.
     * @param selectedDate The selected date for which to retrieve available slots (in string format: "YYYY-MM-DD").
     * @param doctorId The ID of the doctor for whom to retrieve available slots.
     * @return A list of strings representing available time slots for appointments.
     */
    public static list<String> methodslots(String selectedDate, string doctorId) {
        // Implementation is provided in the original code
        Date appointmentDate = Date.valueOf(selectedDate);
        Map<String, Id> contactsMap = new Map<String, Id>();
        
        Date today = System.today();
        String todayString = String.valueOf(today);
        
        // Query patient contacts with matching appointment date and doctor ID
        List<Contact> contacts = [SELECT Id, SlotsAvailable__c, Consult_doctor__c
                                  FROM Contact WHERE Appointment_Date__c = :appointmentDate AND Consult_doctor__c = :doctorId WITH SECURITY_ENFORCED];
        
        for (Contact contact : contacts) {
            contactsMap.put(contact.SlotsAvailable__c, contact.Id);
        }
        
        List<String> availableSlots = new List<String>();
        for (Shifttimings__c ss : [SELECT Id, Shift_time__c
                                   FROM Shifttimings__c
                                   WITH SECURITY_ENFORCED
                                   ORDER BY CreatedDate ASC]) {
            availableSlots.add(ss.Shift_time__c);
        }
        
        Time currentTime = System.now().time();
        String currentTimeString = String.valueOf(currentTime);
        
        List<String> slotsToRemove = new List<String>();
        
        for (String slot : availableSlots) {
            if (!contactsMap.containsKey(slot) && 
                ((selectedDate == todayString && slot >= currentTimeString) || 
                 (selectedDate != todayString))) {
                slotsToRemove.add(slot);
            }
        }
        
        return slotsToRemove;
    }
    
    @AuraEnabled
   /**
     * @description
     * Confirms the rescheduling of an appointment for a patient.
     * @param selectedDate The selected date for rescheduling (in string format: "YYYY-MM-DD").
     * @param patientId The ID of the patient to reschedule the appointment for.
     * @param selectedSlot The selected time slot for the rescheduled appointment.
     */
    public static void confirmingreschedulemethod(String selectedDate, String patientId, String selectedSlot) {
        // Implementation is provided in the original code
        Date appointmentDate = Date.valueOf(selectedDate);
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Contact contact : [SELECT Id, Appointment_Date__c, SlotsAvailable__c
                                FROM Contact WHERE Id = :patientId WITH SECURITY_ENFORCED]) {
            contact.Appointment_Date__c = appointmentDate;
            contact.SlotsAvailable__c = selectedSlot;
            contactsToUpdate.add(contact);
        }
        
        if (!contactsToUpdate.isEmpty() && Schema.sObjectType.Contact.isUpdateable()) {
            database.update(contactsToUpdate, false);
        }
    }
}