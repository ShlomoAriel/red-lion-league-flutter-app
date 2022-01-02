class NotificationsState {
  Notification? notification;

  NotificationsState({this.notification});
}

class Notification {
  Notification(this.id, this.title, this.body);
  String id;
  String title;
  String body;
}
