import 'package:shared_preferences/shared_preferences.dart';


class UserDataFromStorage {

  static late bool firstTime;
  static late bool userIsGuest;
  static late bool userIsLogin;
  static late bool themeIsDarkMode;
  static late bool onBoardingIsOpen;
  static late String userPhoneTypeFromStorage;
  static String languageCodeFromStorage='ar';
  static String languageNameFromStorage="langArabic";

  static late String fullNameFromStorage;
  static late String emailFromStorage;
  static late String phoneNumberFromStorage;
  static late String countryFromStorage;
  static late String mainGroupFromStorage;
  static late String subGroupFromStorage;
  static late String userNameFromStorage;
  static late String organizationIdFromStorage;
  static late String folderNumFromStorage;
  static late String cityFromStorage;
  static late String uIdFromStorage;
  static late double balanceFromStorage;
  static late double cReductionFromStorage;
  static late double detectionFromStorage;
  static late double suspendedBalanceFromStorage;


  static setFirstTimeApp(bool value) {
    firstTime=value;
    _setData();
  }


  static setOnBoardingOpened(bool value) {
    onBoardingIsOpen=value;
    _setData();
  }


  static setUserIsGuest(bool block) {
    userIsGuest = block;
    _setData();
  }static setUserIsLogin(bool block) {
    userIsLogin = block;
    _setData();
  }
  static setThemeIsDarkMode(bool darkMode) {
    themeIsDarkMode = darkMode;
    _setData();
  }

  static  setPhoneType(String value)  {
    userPhoneTypeFromStorage=value;
    _setData();
  }
  static  setAppLanguageCode(String value)  {
    languageCodeFromStorage=value;
    _setData();
  }


  static  setFullName(String value)  {
    fullNameFromStorage=value;
    _setData();
  }

  static  setEmail(String value)  {
    emailFromStorage=value;
    _setData();
  }


  static  setPhoneNumber(String value)  {
    phoneNumberFromStorage=value;
    _setData();
  }
  static  setCountry(String value)  {
    countryFromStorage=value;
    _setData();
  }
  static  setMainGroup(String value)  {
    mainGroupFromStorage=value;
    _setData();
  }
  static  setSubGroup(String value)  {
    subGroupFromStorage=value;
    _setData();
  }
  static  setUserName(String value)  {
    userNameFromStorage=value;
    _setData();
  }

  static  setOrganizationId(String value)  {
    organizationIdFromStorage=value;
    _setData();
  }

  static setBalance(double value)  {
    balanceFromStorage=value;
    _setData();
  }

  static setCReduction(double value)  {
    cReductionFromStorage=value;
    _setData();
  }

  static setDetection(double value)  {
    detectionFromStorage=value;
    _setData();
  }

  static setSuspendedBalance(double value)  {
    suspendedBalanceFromStorage=value;
    _setData();
  }


  static  setFolderNum(String value)  {
    folderNumFromStorage=value;
    _setData();
  }
  static  setCity(String value)  {
    cityFromStorage=value;
    _setData();
  }

  static  setUid(String value)  {
    uIdFromStorage=value;
    _setData();
  }

  /// this function to remove all storage
  static removeAllDataFromStorage() async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.clear();
  }
  /// this function to remove any data from local storage by key
  static removeDataFromStorage(String key) async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.remove(key);
  }


  //#region private
  static void _setData()async {

    final prefs= await SharedPreferences.getInstance();
    prefs.setBool("userIsGuest",userIsGuest);
    prefs.setBool("userIsLogin",userIsLogin);
    prefs.setBool("firstTime",firstTime);
    prefs.setBool("themeIsDarkMode",themeIsDarkMode);
    prefs.setBool("onBoardingIsOpen",onBoardingIsOpen);
    prefs.setString("languageCodeFromStorage",languageCodeFromStorage);
    prefs.setString("languageNameFromStorage",languageNameFromStorage);

    prefs.setString("fullNameFromStorage",fullNameFromStorage);
    prefs.setString("emailFromStorage",emailFromStorage);
    prefs.setString("phoneNumberFromStorage",phoneNumberFromStorage);
    prefs.setString("countryFromStorage",countryFromStorage);
    prefs.setString("mainGroupFromStorage",mainGroupFromStorage);
    prefs.setString("subGroupFromStorage",subGroupFromStorage);
    prefs.setString("userNameFromStorage",userNameFromStorage);
    prefs.setString("organizationIdFromStorage",organizationIdFromStorage);
    prefs.setString("folderNumFromStorage",folderNumFromStorage);
    prefs.setString("cityFromStorage",cityFromStorage);
    prefs.setString("uIdFromStorage",uIdFromStorage);
    prefs.setDouble("cReductionFromStorage",cReductionFromStorage);
    prefs.setDouble("balanceFromStorage",balanceFromStorage);
    prefs.setDouble("detectionFromStorage",detectionFromStorage);
    prefs.setDouble("suspendedBalanceFromStorage",suspendedBalanceFromStorage);

  }


  static   getData() async {

    final prefs = await SharedPreferences.getInstance();
    userIsGuest = prefs.getBool("userIsGuest")?? true;
    userIsLogin = prefs.getBool("userIsLogin")?? false;
    firstTime = prefs.getBool("firstTime")?? true;
    themeIsDarkMode = prefs.getBool("themeIsDarkMode")?? false;
    onBoardingIsOpen = prefs.getBool("onBoardingIsOpen")?? false;
    languageCodeFromStorage = prefs.getString("languageCodeFromStorage")??'ar';
    languageNameFromStorage = prefs.getString("languageNameFromStorage")??'langArabic';
    userPhoneTypeFromStorage = prefs.getString("userPhoneTypeFromStorage")??'';

    fullNameFromStorage = prefs.getString("fullNameFromStorage")??'';
    emailFromStorage = prefs.getString("emailFromStorage")??'';
    phoneNumberFromStorage = prefs.getString("phoneNumberFromStorage")??'';
    countryFromStorage = prefs.getString("countryFromStorage")??'';
    mainGroupFromStorage = prefs.getString("mainGroupFromStorage")??'';
    subGroupFromStorage = prefs.getString("subGroupFromStorage")??'';
    userNameFromStorage = prefs.getString("userNameFromStorage")??'';
    organizationIdFromStorage = prefs.getString("organizationIdFromStorage")??'';
    folderNumFromStorage = prefs.getString("folderNumFromStorage")??'';
    cityFromStorage = prefs.getString("cityFromStorage")??'';
    uIdFromStorage = prefs.getString("uIdFromStorage")??'';
    cReductionFromStorage = prefs.getDouble("cReductionFromStorage")??0.0;
    balanceFromStorage = prefs.getDouble("balanceFromStorage")??0.0;
    detectionFromStorage = prefs.getDouble("detectionFromStorage")??0.0;
    suspendedBalanceFromStorage = prefs.getDouble("suspendedBalanceFromStorage")??0.0;
  }

//#endregion

}
