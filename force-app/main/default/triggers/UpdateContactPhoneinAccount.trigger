trigger UpdateContactPhoneinAccount on Account (After insert,after Update) {
 /*   Set<Id> accid = new Set<Id>();
    if(trigger.isafter && (trigger.isinsert || trigger.isupdate)){
        for(Account acc:trigger.new){
            if(acc.Active__c == 'Yes'){
               accid.add(acc.id); 
                system.debug('vinnii'+accid);
            }
            
        }
    }
    
        List<Opportunity> opplist1 = new  List<Opportunity>();
        List<Opportunity> opplist =[Select Id,Name,StageName,Accountid from Opportunity Where StageName != 'Closed Won' And Accountid IN:accid];
        System.debug(opplist);
        for(Opportunity opp:opplist){
            if(opp.StageName != 'Closed Won'){
               opp.StageName = 'Closed Won';
               opplist1.add(opp);
                System.debug(opplist1);
            }         
        }
        update opplist1;
        System.debug(opplist1);*/
    
    Set<id> Accids = new set<id>();
    if(trigger.isafter && (trigger.isinsert || trigger.isupdate)){
        for(Account acc:trigger.new){
            Accids.add(acc.id);
        }
    }
    List<Contact> conlist12 = new List<Contact>();
    List<Contact> conlist =[Select Id,LastName,AccountId,Account.Phone from Contact Where AccountId IN:Accids];
    for(Contact Con:conlist){
        Con.Phone =Con.Account.phone;
        conlist12.add(con);
        
    }
    update conlist12;
}