/**
 * @description         : Class helps to manage contacts with images and appointments.
 * @Author              : Vinod Nili
 * @Last Modified By    : Vinod Nili
 * @Last Modified On    : 28/07/2023
 * @Modification Log    :
 * Ver               Date                  Author                      LastModification
 * 1.0           26/06/2023               Vinod Nili                 Initial Version
 **/
public with sharing class PicklistController {
    
    /**
     * @description 
     * Retrieves a list of available time slots for appointments based on the selected date and doctor ID.
     * @param selectedDate The selected date for which to retrieve available slots (in string format: "YYYY-MM-DD").
     * @param doctorid The ID of the doctor for whom to retrieve available slots.
     * @return A list of strings representing available time slots for appointments.
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getAvailableSlots(String selectedDate, String doctorid) {
        Date appointmentDate = Date.valueOf(selectedDate);
        Map<String, Id> contactsMap = getContactsMap(appointmentDate, doctorid);
        List<String> availableSlots = getShiftTimings();
        String currentTimeString = String.valueOf(System.now().time());
        DateWrapper varble = new DateWrapper();
        varble.selectDate1 = selectedDate;
        varble.currentTime = currentTimeString;
        List<String> slotsToRemove = filterSlotsToRemove(varble, availableSlots, contactsMap);
        return slotsToRemove;
    }
    
    /**
     * @description 
     * Retrieves a map of patient contacts with available time slots associated with the provided appointment date and doctor ID.
     * @param appointmentDate The date of the appointment to retrieve contacts for.
     * @param doctorid The ID of the doctor to filter contacts by.
     * @return A map where keys are time slot strings and values are contact IDs.
     * @private
     */
    private static Map<String, Id> getContactsMap(Date appointmentDate, String doctorid) {
        Map<String, Id> contactsMap = new Map<String, Id>();
        List<Contact> contacts = [SELECT Id, SlotsAvailable__c FROM Contact WHERE Appointment_Date__c = :appointmentDate AND Consult_doctor__c = :doctorid WITH SECURITY_ENFORCED];
        for (Contact contact : contacts) {
            contactsMap.put(contact.SlotsAvailable__c, contact.Id);
        }
        return contactsMap;
    }
    
    /**
     * @description 
     * Retrieves a list of available shift timings for appointments.
     * @return A list of strings representing available shift timings.
     * @private
     */
    private static List<String> getShiftTimings() {
        List<String> availableSlots = new List<String>();
        List<Shifttimings__c> shiftTimingsList = [SELECT Shift_time__c FROM Shifttimings__c WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC];
        for (Shifttimings__c ss : shiftTimingsList) {
            availableSlots.add(ss.Shift_time__c);
        }
        return availableSlots;
    }
    
    /**
     * @description Filters and returns a list of time slots to remove based on selected date, current time, available slots, and contacts map.
     * @param dateTimevar The selected date for filtering.
     * @param availableSlots The list of available slots to filter.
     * @param contactsMap The map of contacts with available slots.
     * @return  slotsToRemove A list of strings representing time slots to remove.
     */
    private static List<String> filterSlotsToRemove(DateWrapper dateTimevar, List<String> availableSlots, Map<String, Id> contactsMap) {
        List<String> slotsToRemove = new List<String>();
        String datetoday = String.valueOf(System.today());
        for (String slot : availableSlots) {
            if ((dateTimevar.selectDate1 == datetoday && slot >= dateTimevar.currentTime && !contactsMap.containsKey(slot)) ||
                (dateTimevar.selectDate1 != datetoday && !contactsMap.containsKey(slot))) {
                slotsToRemove.add(slot);
            }
        }
        return slotsToRemove;
    }
        /**

     *@description  Retrieves a list of available shift timings for appointments.
     * @param  selectDate1 A list of strings representing available shift timings.
     * @param currentTime
     */
    public class DateWrapper{
        public string selectDate1;
        public string currentTime;
    }
}