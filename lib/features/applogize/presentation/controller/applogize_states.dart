abstract class ApplogizeStates{}

class ApplogizeInitialState extends ApplogizeStates{}

class ApplogizeLoadingState extends ApplogizeStates{}
class ApplogizeSuccessState extends ApplogizeStates{}
class ApplogizeErrorState extends ApplogizeStates{}

class GetAllApplogizeLoadingState extends ApplogizeStates{}
class GetAllApplogizeSuccessState extends ApplogizeStates{}

class ImagePickerSuccessState extends ApplogizeStates{}
class ImagePickerFailureState extends ApplogizeStates{}
class RemovePickedImageSuccessState extends ApplogizeStates{}

class UploadImageLoadingState extends ApplogizeStates{}
class UploadImageSuccessState extends ApplogizeStates{}
class UploadImageFailureState extends ApplogizeStates{}


