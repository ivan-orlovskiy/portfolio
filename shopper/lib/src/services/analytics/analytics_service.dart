import 'dart:io';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shopper/src/common/constants/sdks.dart';

class AnalyticsService {
  static late final Mixpanel _mixpanel;

  AnalyticsService._internal();

  static Future<void> initialize() async {
    _mixpanel = await Mixpanel.init(Sdks.mixpanelProjectToken,
        trackAutomaticEvents: false);
  }

  static void appInstallation() {
    _mixpanel.track(
      AppEvents.installation.name,
      properties: {'OS': Platform.operatingSystem},
    );
  }

  static void signUp() {
    _mixpanel.track(
      AppEvents.signUp.name,
    );
  }

  static void emailAdded(String email) {
    _mixpanel.track(
      AppEvents.emailAdded.name,
      properties: {'email': email},
    );
  }

  static void error(String errorCode, Map<String, String> payload) {
    _mixpanel.track(
      AppEvents.error.name,
      properties: {
        'errorCode': errorCode,
        'payload': payload,
      },
    );
  }
}

enum AppEvents {
  installation,
  signUp,
  emailAdded,
  error,
}
