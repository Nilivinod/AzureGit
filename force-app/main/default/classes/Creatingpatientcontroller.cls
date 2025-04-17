/**
@description         : Class helps to manage contacts with images and appointments.
@Author              : Vinod Nili
@Last Modified By    : Vinod Nili
@Last Modified On    : 28/07/2023
@Modification Log    :
Ver               Date                  Author                      LastModification
1.0           26/06/2023               Vinod Nili                 Initial Version
**/
public with sharing class Creatingpatientcontroller {
 @AuraEnabled
    /**
* Creates a new patient record with the provided contact information.
* @description
* @param patientContact The contact information for the new patient.
* @return A string indicating the outcome of the record creation (success or error message).
*/
    public static string patientcreationmethod(Contact patientContact){
        // Get the record type Id for the 'Patients' record type
        Id doctorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patients').getRecordTypeId();
        // Set the record type Id and status for the patient contact
        patientContact.RecordTypeId = doctorRecordTypeId;
        Contact cosss = patientContact;
        cosss.Status__c = 'Scheduled';
        // Check if an appointment date is provided
       
        if(Schema.sObjectType.Contact.isCreateable() ) {
            database.insert(cosss,false);
            return 'success';
        }else{
            return 'error';
        }      
    }
}