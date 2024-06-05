import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageController extends GetxController {
  //TODO: Implement LanguageController

  var locale=Locale('hi', 'IN');
  final String LANGUAGE_CODE_KEY = 'languageCode';
  final String COUNTRY_CODE_KEY = 'countryCode';

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale(); // Load the saved locale when the controller is initialized
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _loadSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(LANGUAGE_CODE_KEY);
    String? countryCode = prefs.getString(COUNTRY_CODE_KEY);
    if (languageCode != null && countryCode != null) {
      changeLocal(languageCode, countryCode);
    }
  }

  Future<void> changeLocal(String langCode, String countryCode) async {
    locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE_KEY, langCode);
    await prefs.setString(COUNTRY_CODE_KEY, countryCode);
  }
}