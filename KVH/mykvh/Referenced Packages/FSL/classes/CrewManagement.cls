/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CrewManagement {
    @RemoteAction
    global static Map<String,List<SObject>> GetResourcesAndTerritories(List<Id> territoriesIds) {
        return null;
    }
    @RemoteAction
    global static Boolean deleteScm(Id scmId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getGanttData(String strStartDate, String strFinishDate, List<Id> territoriesIds) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<String>> getServiceAppointmentTooltipFieldset() {
        return null;
    }
    @RemoteAction
    global static List<Skill> getSkills() {
        return null;
    }
    @RemoteAction
    global static ServiceCrewMember saveChangesToScm(Id scmId, Id resourceId, Id crewId, String strStartDate, String strEndDate, Boolean isLeader) {
        return null;
    }
    @RemoteAction
    global static List<ServiceCrewMember> saveMultipleScms2(List<Id> resourceIds, Id crewId, String strStartDate, String strEndDate, Boolean isLeader) {
        return null;
    }
    @RemoteAction
    global static List<ServiceCrewMember> saveMultipleScms(List<Id> resourceIds, Id crewId, String strStartDate, String strEndDate) {
        return null;
    }
}
