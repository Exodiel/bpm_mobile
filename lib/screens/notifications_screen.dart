import 'package:bpm_mobile/models/notification.dart';
import 'package:bpm_mobile/screens/screens.dart';
import 'package:bpm_mobile/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationsService>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.arrowCircleLeft),
        ),
      ),
      body: FutureBuilder(
        future: notificationService.getNotifications(),
        builder: (_, AsyncSnapshot<List<NotificationModel>> snapshot) {
          final notifications = snapshot.data;
          if (snapshot.hasData) {
            if (notifications != null) {
              print(notifications.length);
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (__, index) {
                  return Card(
                    child: ListTile(
                      title: Text(notifications[index].title),
                      leading: const Icon(FontAwesomeIcons.solidBell),
                      subtitle: Text(notifications[index].topic),
                      trailing: Text(
                        timeago.format(
                          DateTime.parse(notifications[index].body),
                          locale: 'es',
                        ),
                      ),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.all(20),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
