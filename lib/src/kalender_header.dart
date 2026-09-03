import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

class KalenderHeader extends StatefulWidget {
  /// The callbacks used by the [KalenderBody].
  ///
  /// This provides a way to override the [KalenderCallbacks] passed to the [KalenderView].
  final KalenderCallbacks? callbacks;

  /// MultiDay

  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final MultiDayHeaderConfiguration? multiDayHeaderConfiguration;

  /// The tile components used by the [MultiDayHeader].
  final TileComponents? multiDayTileComponents;

  /// The interaction notifier used by the [MultiDayHeader].
  final KalenderInteraction? interaction;

  /// Month

  /// Creates a KalenderHeader widget.
  ///
  /// This creates the correct header based on the [ViewController] inside the [KalenderController]
  /// - [MultiDayHeader]
  /// - [MonthHeader]
  /// - [ScheduleHeader]
  ///
  const KalenderHeader({
    super.key,
    this.multiDayTileComponents,
    this.multiDayHeaderConfiguration,
    this.callbacks,
    this.interaction,
  });

  @override
  State<KalenderHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<KalenderHeader> {
  late KalenderCallbacks? _callbacks;
  late ValueNotifier<KalenderInteraction> _interaction;

  @override
  void initState() {
    super.initState();
    _callbacks = widget.callbacks;
    _interaction = ValueNotifier(widget.interaction ?? KalenderInteraction());
  }

  @override
  void didUpdateWidget(covariant KalenderHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.callbacks != widget.callbacks) {
      _callbacks = widget.callbacks;
    }
    if (oldWidget.interaction != widget.interaction) {
      _interaction.value = widget.interaction ?? KalenderInteraction();
    }
  }

  @override
  void dispose() {
    _interaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewController = context.calendarController.viewController;
    return Callbacks(
      callbacks: _callbacks ?? context.callbacks,
      child: switch (viewController) {
        MultiDayViewController() => Interaction(
            notifier: _interaction,
            child: TileComponentProvider(
              tileComponents: widget.multiDayTileComponents ?? TileComponents.defaultComponents(),
              child: MultiDayHeader(configuration: widget.multiDayHeaderConfiguration),
            ),
          ),
        MonthViewController() => const MonthHeader(),
        ScheduleViewController() => const ScheduleHeader(),
        _ => throw ErrorHint(
            'Unsupported ViewController type: ${viewController.runtimeType}. '
            'Make sure to use the correct KalenderHeader for the ViewController.',
          )
      },
    );
  }
}
