public class GetAllData {

    public Static wrapperclass getData(){
        return new wrapperclass();
    }
    public class wrapperclass {
        List<Account> acclist;
        List<Opportunity> opplist;
        List<Contact> conlist;
        public wrapperclass(){
            acclist = [Select Id,Name,Phone From Account];
            conlist = [Select Id,Name,Phone,Email From Contact];
            opplist = [Select Id,StageName,Name From Opportunity];
        }
    }
}