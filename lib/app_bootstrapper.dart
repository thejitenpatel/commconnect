import 'package:clock/clock.dart';
import 'package:commconnect/src/core/local/key_value_storage_base.dart';
import 'package:commconnect/src/core/local/path_provider_service.dart';
import 'package:commconnect/src/features/auth/domain/register_detail_model.dart';
import 'package:commconnect/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppBootstrapper {
  const AppBootstrapper._();

  /// Initializer for important and asyncronous app services
  /// Should be called in main after `WidgetsBinding.FlutterInitialized()`.
  ///
  /// [mainAppWidget] is the first widget that loads on app startup.
  /// [runApp] is the main app binding method that launches our [mainAppWidget].
  static Future<void> init({
    required Widget mainAppWidget,
    required void Function(Widget) runApp,
  }) async {
    // For preparing the key-value mem cache
    await KeyValueStorageBase.init();

    // For preparing to read application directory paths
    await PathProviderService.init();

    // Initialize the local storage
    await Hive.initFlutter();
    await Hive.openBox('commConnect');

    // Register The Register Hive Model
    Hive.registerAdapter(RegisterDetailModelAdapter());

    // For prettyifying console debug messages
    debugPrint = _prettifyDebugPrint;

    // registerErrorHandlers();

    // For restricting the app to portrait mode only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Running the app. The app will start from here.
    runApp(mainAppWidget);
  }

  static void _prettifyDebugPrint(String? message, {int? wrapWidth}) {
    final date = clock.now();
    var msg = '${date.year}/${date.month}/${date.day}';
    msg += ' ${date.hour}:${date.minute}:${date.second}';
    msg += ' $message';
    debugPrintSynchronously(msg, wrapWidth: wrapWidth);
  }

  static void registerErrorHandlers() {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
    };
    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint(error.toString());
      return true;
    };
    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
