abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class ImagePickerSuccessState extends HomeStates {}
class ImagePickerFailureState extends HomeStates {}


class FingureSettingsSuccessState extends HomeStates {}
class FingureSettingsFailureState extends HomeStates {}
class FingureSettingsLoadingState extends HomeStates {}

class RecordDailyEarlyAttendenceSuccessState extends HomeStates {}
class RecordDailyEarlyAttendenceFailureState extends HomeStates {}
class RecordDailyEarlyAttendenceLoadingState extends HomeStates {}

class RecordDailyLateAttendenceLoadingState extends HomeStates {}
class RecordDailyLateAttendenceSuccessState extends HomeStates {}
class RecordDailyLateAttendenceFailureState extends HomeStates {}

class CheckDailyEarlyAttendenceLoadingState extends HomeStates {}
class CheckDailyEarlyAttendenceSuccessState extends HomeStates {}

class CheckDailyLateAttendenceLoadingState extends HomeStates {}
class CheckDailyLateAttendenceSuccessState extends HomeStates {}

class GetEducationalMembersLoadingState extends HomeStates {}
class GetEducationalMembersSuccessState extends HomeStates {}
class GetEducationalMembersFailureState extends HomeStates {}

class RecordEducationalAttendenceLoadingState extends HomeStates {}
class RecordEducationalAttendenceSuccessState extends HomeStates {}



