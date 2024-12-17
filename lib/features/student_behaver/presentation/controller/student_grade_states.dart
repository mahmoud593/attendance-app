abstract class StudentGradeStates{}

class StudentGradeInitialState extends StudentGradeStates{}

class StudentGradePassiveState extends StudentGradeStates{}

class UploadGradeLoadingState extends StudentGradeStates{}
class UploadGradeSuccessState extends StudentGradeStates{}
class UploadGradeErrorState extends StudentGradeStates{}

class GetQrCodeSuccessState extends StudentGradeStates{}