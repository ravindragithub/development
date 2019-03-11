public class HTS_terminal_templates_sync implements Queueable, Database.AllowsCallouts {
  public void execute(QueueableContext context) {
    HTS_terminal_templates util = new HTS_terminal_templates();
    //Adding a Text post...
    FeedItem post = new FeedItem();
    String results = util.synchronizeHTSTemplatesWithOSS(); //Now what do I do with the string?
    if(results.contains('ADDED: 0') && results.contains('MODIFIED: 0')){  //no action required, Private Post!
        list<CollaborationGroup> groups = [SELECT Id,Name FROM CollaborationGroup WHERE Name = 'Autonomous Jobs'];
        if(groups.size() != 1){
          post.ParentId = UserInfo.getUserId(); //eg. Opportunity id, custom object id..
          post.Body = results + '\t There is a problem with the Group named \"Autonomous Jobs\" ';
        } else {
          post.ParentId = groups[0].Id; //eg. Opportunity id, custom object id..
          post.Body = results;
        }
    } else {  //Something changed! Action required, Public Post
      post.ParentId = UserInfo.getUserId(); //eg. Opportunity id, custom object id..
      post.Body = results;
    }
    insert post;
  }
}