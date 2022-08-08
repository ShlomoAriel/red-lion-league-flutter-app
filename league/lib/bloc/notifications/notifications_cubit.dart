// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_state.dart';
// import 'dart:io' show Platform;
// import 'package:overlay_support/overlay_support.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState());
  var messaging;
  var notification;

  void init() async {
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
    //   notification = PushNotificationMessage(
    //     title: event.notification?.title ?? "NA",
    //     body: event.notification?.body ?? "NA",
    //   );
    //   showOverlayNotification((context) {
    //     return MessageNotification(
    //       notification: notification,
    //       onReplay: () {
    //         OverlaySupportEntry.of(context)?.dismiss(); //use OverlaySupportEntry to dismiss overlay
    //         toast('you checked this message');
    //       },
    //     );
    //   });
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    NotificationsState state = new NotificationsState();
    emit(state);
  }
}

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    required this.title,
    required this.body,
  });
}

class IosStyleToast extends StatelessWidget {
  IosStyleToast({required this.notification});
  late PushNotificationMessage notification;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(notification.title),
                    Text(notification.title),
                    Text(notification.body)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageNotification extends StatelessWidget {
  final VoidCallback onReplay;
  final PushNotificationMessage notification;

  const MessageNotification({Key? key, required this.onReplay, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(30, 30),
              child: ClipOval(child: Image.asset('assets/images/football.png'))),
          title: Text(notification.title),
          subtitle: Text(notification.body),
          trailing: IconButton(
              icon: Icon(Icons.arrow_circle_up_rounded),
              onPressed: () {
                ///TODO i'm not sure it should be use this widget' BuildContext to create a Dialog
                ///maybe i will give the answer in the future
                onReplay();
              }),
        ),
      ),
    );
  }
}
