import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'move_out_vertical_widget.dart';

class ClockWidget extends StatelessWidget {
  static const period = Duration(seconds: 1);
  static const hourFormat12 = 'hh';
  static const hourFormat24 = 'HH';
  static const minuteFormat = 'mm';
  static const secondFormat = 'ss';
  static const ampmFormat = 'a';

  final String separator;
  final TextStyle? style;
  final Curve curveIn;
  final Curve curveOut;
  final bool is24HourClockFormat;
  final DateTime dateTime;

  const ClockWidget(
      {required this.dateTime,
      this.curveIn = Curves.elasticInOut,
      this.curveOut = Curves.linear,
      this.style,
      this.separator = ':',
      this.is24HourClockFormat = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: StreamBuilder<DateTime>(
            initialData: dateTime,
            stream: Stream.periodic(period,
                    (seconds) => dateTime.add(Duration(seconds: seconds + 1)))
                .where((event) => event.minute == 0 && event.second == 0)
                .map((event) => event),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              final dt = snapshot.data ?? DateTime.now();
              return MoveOutVerticalWidget(
                  childIn: Center(
                    child: Text(
                        DateFormat(is24HourClockFormat
                                ? hourFormat24
                                : hourFormat12)
                            .format(dt),
                        style: style),
                  ),
                  curveIn: curveIn,
                  childOut: Center(
                    child: Text(
                        DateFormat(is24HourClockFormat
                                ? hourFormat24
                                : hourFormat12)
                            .format(dt.subtract(const Duration(hours: 1))),
                        style: style),
                  ),
                  curveOut: curveOut);
            },
          ),
        ),
        Text(separator, style: style),
        Expanded(
          child: StreamBuilder<DateTime>(
            initialData: dateTime,
            stream: Stream.periodic(period,
                    (seconds) => dateTime.add(Duration(seconds: seconds + 1)))
                .where((event) => event.second == 0)
                .map((event) => event),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              final dt = snapshot.data ?? DateTime.now();
              return MoveOutVerticalWidget(
                  childIn: Center(
                    child:
                        Text(DateFormat(minuteFormat).format(dt), style: style),
                  ),
                  curveIn: curveIn,
                  childOut: Center(
                    child: Text(
                        DateFormat(minuteFormat)
                            .format(dt.subtract(const Duration(minutes: 1))),
                        style: style),
                  ),
                  curveOut: curveOut);
            },
          ),
        ),
        Text(separator, style: style),
        Expanded(
          child: StreamBuilder<DateTime>(
            initialData: dateTime,
            stream: Stream.periodic(period,
                (seconds) => dateTime.add(Duration(seconds: seconds + 1))),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              final dt = snapshot.data ?? DateTime.now();
              return MoveOutVerticalWidget(
                  childIn: Center(
                    child:
                        Text(DateFormat(secondFormat).format(dt), style: style),
                  ),
                  curveIn: curveIn,
                  childOut: Center(
                    child: Text(
                        DateFormat(secondFormat)
                            .format(dt.subtract(const Duration(seconds: 1))),
                        style: style),
                  ),
                  curveOut: curveOut);
            },
          ),
        ),
        is24HourClockFormat
            ? const SizedBox()
            : Expanded(
                child: StreamBuilder<DateTime>(
                  initialData: dateTime,
                  stream: Stream.periodic(
                          period,
                          (seconds) =>
                              dateTime.add(Duration(seconds: seconds + 1)))
                      .where(
                          (event) => event.hour % 12 == 0 && event.second == 0)
                      .map((event) => event),
                  builder:
                      (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
                    final dt = snapshot.data ?? DateTime.now();
                    return MoveOutVerticalWidget(
                        childIn: Center(
                          child: Text(DateFormat(ampmFormat).format(dt),
                              style: style),
                        ),
                        curveIn: curveIn,
                        childOut: Center(
                          child: Text(
                              DateFormat(ampmFormat).format(
                                  dt.subtract(const Duration(seconds: 1))),
                              style: style),
                        ),
                        curveOut: curveOut);
                  },
                ),
              ),
      ],
    );
  }
}
