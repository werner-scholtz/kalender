import 'package:flutter/material.dart';

class SlotSizeTile extends StatelessWidget {
  const SlotSizeTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Duration value;
  final void Function(Duration value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('slotSize'),
      trailing: DropdownButton<Duration>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: Duration(minutes: 15),
            child: Text('15 min'),
          ),
          DropdownMenuItem(
            value: Duration(minutes: 30),
            child: Text('30 min'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class MultiDayTileHeight extends StatelessWidget {
  const MultiDayTileHeight({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('multidayTileHeight'),
      trailing: DropdownButton<double>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: 24.0,
            child: Text('24.0'),
          ),
          DropdownMenuItem(
            value: 48.0,
            child: Text('48.0'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class HourLineTimelineOverlap extends StatelessWidget {
  const HourLineTimelineOverlap({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('hourlineTimelineOverlap'),
      trailing: DropdownButton<double>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: 8.0,
            child: Text('8.0'),
          ),
          DropdownMenuItem(
            value: 56.0,
            child: Text('56.0'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class TimelineWidth extends StatelessWidget {
  const TimelineWidth({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('timelineWidth'),
      trailing: DropdownButton<double>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: 56.0,
            child: Text('56.0'),
          ),
          DropdownMenuItem(
            value: 104.0,
            child: Text('104.0'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class NumberOfDays extends StatelessWidget {
  const NumberOfDays({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('numberOfDays'),
      trailing: DropdownButton<int>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: 1,
            child: Text('1'),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text('2'),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text('3'),
          ),
          DropdownMenuItem(
            value: 4,
            child: Text('4'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class FirstDayOfWeek extends StatelessWidget {
  const FirstDayOfWeek({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('firstDayOfWeek'),
      trailing: DropdownButton<int>(
        value: value,
        items: const [
          DropdownMenuItem(
            value: 1,
            child: Text('Monday'),
          ),
          DropdownMenuItem(
            value: 2,
            child: Text('Tuesday'),
          ),
          DropdownMenuItem(
            value: 3,
            child: Text('Wednesday'),
          ),
          DropdownMenuItem(
            value: 4,
            child: Text('Thursday'),
          ),
          DropdownMenuItem(
            value: 5,
            child: Text('Friday'),
          ),
          DropdownMenuItem(
            value: 6,
            child: Text('Saturday'),
          ),
          DropdownMenuItem(
            value: 7,
            child: Text('Sunday'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class VerticalStepDuration extends StatelessWidget {
  const VerticalStepDuration({
    super.key,
    required this.verticalStepDuration,
    required this.onChanged,
  });

  final Duration verticalStepDuration;
  final void Function(Duration verticalSnapRange) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('verticalStepDuration'),
      trailing: DropdownButton<Duration>(
        value: verticalStepDuration,
        items: const [
          DropdownMenuItem(
            value: Duration(minutes: 15),
            child: Text('15 min'),
          ),
          DropdownMenuItem(
            value: Duration(minutes: 10),
            child: Text('10 min'),
          ),
          DropdownMenuItem(
            value: Duration(minutes: 1),
            child: Text('1 min'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class VerticalSnapRange extends StatelessWidget {
  const VerticalSnapRange({
    super.key,
    required this.verticalSnapRange,
    required this.onChanged,
  });

  final Duration verticalSnapRange;
  final void Function(Duration verticalSnapRange) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('verticalSnapRange'),
      trailing: DropdownButton<Duration>(
        value: verticalSnapRange,
        items: const [
          DropdownMenuItem(
            value: Duration(minutes: 15),
            child: Text('15 min'),
          ),
          DropdownMenuItem(
            value: Duration(minutes: 10),
            child: Text('10 min'),
          ),
          DropdownMenuItem(
            value: Duration(minutes: 5),
            child: Text('5 min'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}
