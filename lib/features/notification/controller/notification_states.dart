abstract class NotificationStates {}

class NotificationInitialState extends NotificationStates {}

class AddAttendenceNotificationSuccessState extends NotificationStates {}
class AddAttendenceNotificationErrorState extends NotificationStates {}

class GetAttendenceNotificationSuccessState extends NotificationStates {}
class GetAttendenceNotificationErrorState extends NotificationStates {}
class GetAttendenceNotificationLoadingState extends NotificationStates {}

class GetGeneralNotificationSuccessState extends NotificationStates {}
class GetGeneralNotificationErrorState extends NotificationStates {}
class GetGeneralNotificationLoadingState extends NotificationStates {}