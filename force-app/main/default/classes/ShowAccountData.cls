public class ShowAccountData {

    @AuraEnabled(Cacheable=true)
    public static List<Account>  accountList(){
        List<Account> acclist1 = [Select id,Name,Phone,Rating from Account];
       return acclist1;
       //add comment on git
    }
}