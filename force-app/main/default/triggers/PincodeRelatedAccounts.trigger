trigger PincodeRelatedAccounts on Account (before insert, before update) {
    Map<Decimal, Id> pincodeToFirstAccountMap = new Map<Decimal, Id>();
    Set<Decimal> pincodes = new Set<Decimal>();

    // Collect unique pincodes from the incoming records
    for (Account acc : Trigger.new) {
        if (acc.Pincode__c != null) {
            pincodes.add(acc.Pincode__c);  // Ensure it's a Decimal Set
        }
    }

    // Query the FIRST Account created for each Pincode
    for (AggregateResult res : [
        SELECT MIN(Id) Id, Pincode__c
        FROM Account
        WHERE Pincode__c IN :pincodes
        GROUP BY Pincode__c
    ]) {
        pincodeToFirstAccountMap.put((Decimal)res.get('Pincode__c'), (Id)res.get('Id'));
    }

    // Assign ParentId based on the first Account with the same Pincode
    for (Account acc : Trigger.new) {
        if (acc.Pincode__c != null && pincodeToFirstAccountMap.containsKey(acc.Pincode__c)) {
            acc.ParentId = pincodeToFirstAccountMap.get(acc.Pincode__c);
        }
    }
}