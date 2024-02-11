// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/media_cubit.dart';
import 'package:league/navigation/app_router.dart';
import 'package:league/utils/main_theme.dart';
// import 'package:overlay_support/overlay_support.dart';

import 'bloc/notifications/notifications_cubit.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  runApp(ClientelingApp(
    appRouter: AppRouter(),
  ));
}

class ClientelingApp extends StatelessWidget {
  final AppRouter appRouter;

  const ClientelingApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext appContext) {
    // late FirebaseMessaging messaging;
    return StatefulWrapper(
      onInit: () {
        // messaging = FirebaseMessaging.instance;
        // messaging.getToken().then((value) {
        //   print("Token: ");
        //   print(value);
        // });
        // messaging.getAPNSToken().then((value) {
        //   print("APNS Token: ");
        //   print(value);
        // });

        // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        //   print("message recieved");
        //   print(event.notification!.body);
        // });
        // FirebaseMessaging.onMessageOpenedApp.listen((message) {
        //   print('Message clicked!');
        // });
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotificationsCubit>(
            create: (context) => NotificationsCubit()..init(),
          ),
          BlocProvider<LeagueCubit>(
            create: (context) => LeagueCubit()..init(),
          ),
          BlocProvider<MediaCubit>(
            create: (context) => MediaCubit()..init(),
          ),
        ],
        // child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Red Lion League',
          theme: mainTheme(),
          onGenerateRoute: appRouter.onGenerateRoute,
        ),
        // ),
      ),
    );
  }
}

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({required this.onInit, required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  // late FirebaseMessaging messaging;
  @override
  void initState() {
    // if(widget.onInit != null) {
    widget.onInit();
    // }
    super.initState();

    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   print("Token: ");
    //   print(value);
    // });
    // messaging.getAPNSToken().then((value) {
    //   print("APNS Token: ");
    //   print(value);
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             color: Colors.blue,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //         ));
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body)],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  // void showNotification() {
  //   setState(() {
  //     _counter++;
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing $_counter",
  //       "How you doin ?",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@mipmap/ic_launcher')));
  // }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
