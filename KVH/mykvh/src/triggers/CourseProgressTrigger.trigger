trigger CourseProgressTrigger on skilljar__Course_Progress__c (after update) {
    CourseProgressTriggerHandler.updateCSNLevel(trigger.newmap,trigger.oldmap);
}