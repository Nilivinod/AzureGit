/**
* @File Name : GetAccountData.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : January 23, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 23, 2025 |   | Initial Version
**/

public class GetAccountData {
	@AuraEnabled(cacheable='true')
	public static List<Account> allAccountData(){
     List<account> acclist = [select Id,Name,Phone,Rating from Account];
	 return acclist;
	}
}