import 'package:commconnect/app_bootstrapper.dart';
import 'package:commconnect/firebase_options.dart';
import 'package:commconnect/src/config/theme/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer(
    overrides: [],
  );
  await AppBootstrapper.init(
    mainAppWidget: UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
    runApp: runApp,
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = "Community Connect";
    const showDebugBanner = false;
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: showDebugBanner,
      title: title,
      theme: AppThemes.mainTheme,
    );

    // final app = platformIsIOS
    //     ? Theme(
    //         data: AppThemes.mainTheme,
    //         child: CupertinoApp.router(
    //           routerConfig: goRouter,
    //           debugShowCheckedModeBanner: showDebugBanner,
    //           title: title,
    //         ),
    //       )
    //     : MaterialApp.router(
    //         routerConfig: goRouter,
    //         debugShowCheckedModeBanner: showDebugBanner,
    //         title: title,
    //         theme: AppThemes.mainTheme,
    //       );

    // return app;
  }
}
