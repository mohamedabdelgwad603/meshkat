import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/services/notifications/local_notifications_service.dart';

// Receives Firebase Cloud Messaging messages and keeps the device subscribed to the right topics.
class PushNotificationsService {
  final FirebaseMessaging _messaging;
  final LocalNotificationsService _local;

  // Topic every device joins, plus one topic per app language.
  static const String allTopic = 'all';
  static const List<String> languageTopics = ['ar', 'en'];

  // Creates the service with the messaging instance and the local notifications used in the foreground.
  PushNotificationsService(this._messaging, this._local);

  // Registers the device, shows messages while the app is open and joins the shared topic.
  Future<void> init() async {
    await _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    if (defaultTargetPlatform == TargetPlatform.android) FirebaseMessaging.onMessage.listen(_showInForeground);
    if (kDebugMode) _messaging.onRegistered.listen((id) => debugPrint('FCM installation id: $id'));
    await _register();
    await _subscribe(allTopic);
  }

  // Subscribes to the topic of the given language and leaves the other language topics.
  Future<void> syncLanguage(String languageCode) async {
    for (final topic in languageTopics) {
      topic == languageCode ? await _subscribe(topic) : await _unsubscribe(topic);
    }
  }

  // Shows an incoming message as a local notification, since Android hides them while the app is open.
  void _showInForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.showNow(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
    );
  }

  // Joins a topic, ignoring failures such as a missing APNs token on the simulator.
  Future<void> _subscribe(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      debugPrint('PushNotificationsService: could not subscribe to $topic: $e');
    }
  }

  // Leaves a topic, ignoring failures.
  Future<void> _unsubscribe(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      debugPrint('PushNotificationsService: could not unsubscribe from $topic: $e');
    }
  }

  // Registers this device with Firebase Cloud Messaging, ignoring failures such as having no network.
  Future<void> _register() async {
    try {
      await _messaging.register();
    } catch (e) {
      debugPrint('PushNotificationsService: could not register: $e');
    }
  }
}
