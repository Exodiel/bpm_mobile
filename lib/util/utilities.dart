import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(
  BuildContext context,
) async {
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Quiero un recordatorio cada:',
          textAlign: TextAlign.center,
        ),
        content: Wrap(
          alignment: WrapAlignment.center,
          spacing: 3,
          children: [
            for (int index = 0; index < weekdays.length; index++)
              ElevatedButton(
                onPressed: () {
                  selectedDay = index + 1;
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.teal,
                  ),
                ),
                child: Text(weekdays[index]),
              ),
          ],
        ),
      );
    },
  );

  if (selectedDay != null) {
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        now.add(
          const Duration(minutes: 1),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      return NotificationWeekAndTime(
        dayOfTheWeek: selectedDay!,
        timeOfDay: timeOfDay,
      );
    }
  }
  return null;
}

const String _url = 'http://192.168.1.9:8000';

String get url => _url;

String month(int month) {
  String format = "";
  switch (month) {
    case 1:
      format = "Enero";
      break;
    case 2:
      format = "Febrero";
      break;
    case 3:
      format = "Marzo";
      break;
    case 4:
      format = "Abril";
      break;
    case 5:
      format = "Mayo";
      break;
    case 6:
      format = "Junio";
      break;
    case 7:
      format = "Julio";
      break;
    case 8:
      format = "Agosto";
      break;
    case 9:
      format = "Septiembre";
      break;
    case 10:
      format = "Octubre";
      break;
    case 11:
      format = "Noviembre";
      break;
    case 12:
      format = "Diciembre";
      break;
    default:
  }

  return format;
}