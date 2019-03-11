global class Kencast_Licenses_Need_Warn_Schedulable implements Schedulable {

    Public void execute(SchedulableContext SC){
        
    	Kencast_Licenses_Needed_Warning KLNW = new Kencast_Licenses_Needed_Warning();

        KLNW.Schedule_Me();        
     }
}