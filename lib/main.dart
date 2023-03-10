import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/infoapp.dart';
import 'routes.dart';
import 'theme.dart';
import 'accounts/screens/splash/splash_screen.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loader.dart';
import 'features/auth/controller/auth_controller.dart';
import 'notification/api/notification_api.dart';

//اشعارات في الخلفية
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//اشعارات في الخلفية
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });

  runApp(ProviderScope(child: MyApp()));
  //runApp(TestHome());
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  // فتح التطبيق عند النقر على اشعارات التطبيق
  void listenNotifications() => NotificationApi.onNotifications.stream.listen(
        (event) => onClickedNotification(event),
      );

  onClickedNotification(String? payload) {
    Navigator.of(context).pushNamed(go_main);
  }

  @override
  Widget build(BuildContext context) {
    // debugInvertOversizedImages = true;

    // , WidgetRef ref
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '$appName',
      theme: theme(),
      // حتى يدعم التطبيق اللغة العربية

      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("ar", "AE")],
      // home: SignInScreen(),
      routes: routes,
      // home: SplashScreen(),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              // if (alertsRow[colNameAlert].toString().trim().isEmpty)
              //   ref.watch(authControllerProvider).loadAlertUpdateApp();
              // if (alerptsRow[colNameAlert].toString().trim().isNotEmpty &&
              //     alertsRow[colIsClose] == true) {
              //   return UpdateAppScreen();
              // }
              // if (alertsRow[colNameAlert].toString().trim().isNotEmpty) {
              //   msgUpdateAppDialog(context);
              // }

              if (user == null) {
                return SplashScreen();
              }

              return SplashScreen();
            },
            error: (err, trace) {
              return SplashScreen();

              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),

      // home: TabsScreen(),
    );
  }
}


// pod repo update
// sudo gem install cocoapods
// pod setup