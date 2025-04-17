trigger PreventDuplicateContact on Contact (before insert, before update) {
    
    // Create a set to hold Account Ids for which we need to check existing contacts
    Set<Id> accountIds = new Set<Id>();
    
    // Collect AccountIds from new contacts
    for (Contact newContact : Trigger.new) {
        if (newContact.AccountId != null) {
            accountIds.add(newContact.AccountId);
            System.debug('Adding AccountId to Set: ' + newContact.AccountId);
        }
    }

    // Only proceed if there are Account Ids to check
    if (!accountIds.isEmpty()) {
        System.debug('Account Ids to check: ' + accountIds);
        
        // Query for contacts related to the accounts in question
        Map<Id, List<Contact>> accountContactMap = new Map<Id, List<Contact>>();

        for (Contact contact : [SELECT Id, AccountId, Name, Email, Phone FROM Contact WHERE AccountId IN :accountIds]) {
            System.debug('Querying Contact: ' + contact);
            
            // Initialize the list for the AccountId if it does not exist
            if (!accountContactMap.containsKey(contact.AccountId)) {
                accountContactMap.put(contact.AccountId, new List<Contact>());
            }
            accountContactMap.get(contact.AccountId).add(contact);
        }
        
        System.debug('Account to Contact mapping: ' + accountContactMap);

        // Loop through the new contacts and compare them with existing contacts under the same Account
        for (Contact newContact : Trigger.new) {
            System.debug('Checking new Contact: ' + newContact);
            
            if (newContact.AccountId != null && accountContactMap.containsKey(newContact.AccountId)) {
                for (Contact existingContact : accountContactMap.get(newContact.AccountId)) {
                    System.debug('Comparing with existing Contact: ' + existingContact);

                    // Check for null before accessing properties
                    if (existingContact != null) {
                        // Use contains for name and email comparison
                        if (existingContact.Name != null && existingContact.Email != null && existingContact.Phone != null) {
                            if (existingContact.Name.contains(newContact.Name != null ? newContact.Name : '') && 
                                existingContact.Email.contains(newContact.Email != null ? newContact.Email : '') && 
                                existingContact.Phone.contains(newContact.Phone != null ? newContact.Phone : '')) {

                                newContact.addError('A contact with the same Name, Email, and Phone already exists for this Account.');
                                System.debug('Duplicate contact found: ' + existingContact);
                            }
                        }
                    }
                }
            }
        }
    } else {
        System.debug('No Account Ids to check, skipping duplicate check.');
    }
}