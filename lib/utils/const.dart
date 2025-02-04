import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

const THEME_COLOR = Colors.purple;

const contact_email = 'roydeveloper01@gmail.com';

const BANNER_AD_UNIT = "ca-app-pub-3940256099942544/9214589741";
const INTERSTITIAL_AD_UNIT = "ca-app-pub-3940256099942544/1033173712";

const PRIVACY_POLICY = "https://roywebtech.in/privacy-plicy.html";

String checkDevice() {
  // Get the operating system as a string.
  return Platform.operatingSystem;
}

void showMessage(String title, String message) {
  Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
}

void gotoNextPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void gotoNextPageAndFinish(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

// Dynamic text size function based on device type
double getTextSize(BuildContext context, double baseSize) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth < 600 ? baseSize : baseSize * 1.25; // Scale up for tablets
}

bool isMobile(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth < 600 ? true : false; // Scale up for tablets
}

final List<String> categories = [
  'India News',
  'Kolkata',
  'States',
  'World News',
  'Sports',
  'Astrology',
  'Blog',
];

List<String> getCategoryList() {
  return categories;
}

List<String> getRssUrlList(categoryName) {
  final Map<String, List<String>> rssUrlsByCategory = {
    categories[0]: [
      /*India News*/
      'https://bengali.abplive.com/news/india/feed',
    ],
    categories[1]: [
      /*Kolkata*/
      'https://bengali.abplive.com/news/kolkata/feed',
    ],
    categories[2]: [
      /*States*/
      'https://bengali.abplive.com/states/feed',
      'https://bengali.abplive.com/district/feed',
    ],
    categories[3]: [
      /*World News*/
      'https://bengali.abplive.com/news/world/feed',
    ],
    categories[4]: [
      /*Sports*/
      'https://bengali.abplive.com/sports/feed',
    ],
    categories[5]: [
      /*Astrology*/
      'https://bengali.abplive.com/astro/feed',
    ],
    categories[6]: [
      /*Blog*/
      'https://bengali.abplive.com/blog/feed',
    ],
  };

  // If categoryName is empty, return all URLs combined
  if (categoryName.isEmpty) {
    // Flatten all the lists into a single list and return
    return rssUrlsByCategory.values.expand((x) => x).toList();
  }

  // If categoryName is not empty, return the URLs for that specific category
  return rssUrlsByCategory[categoryName] ?? [];
}
/*
Future<void> showNoInternetDialog(BuildContext context) async {
  bool isWebBrowser = isWeb();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button! for dialog dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connected'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Use this fetchers need internet connection.'),
              Text('Go to settings and turn on your internet'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(isWebBrowser ? 'ok' : 'Settings'),
            onPressed: () {
              if (isWebBrowser) {
                Navigator.of(context).pop();
              } else if (checkDevice() == ANDROID) {
                // Navigator.of(context).pop();
                AppSettings.openAppSettings(type: AppSettingsType.dataRoaming);
              } else if (checkDevice() == IOS) {
                // Navigator.of(context).pop();
                AppSettings.openAppSettings();
              }
            },
          ),
        ],
      );
    },
  );
}*/
