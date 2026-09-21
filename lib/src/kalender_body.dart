// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// The calendar body, is a generic widget that creates the relevant widget based on the [ViewController].
///
/// {@category Views}
class KalenderBody extends StatefulWidget {
  /// The callbacks used by the [KalenderBody].
  ///
  /// This provides a way to override the [KalenderCallbacks] passed to the [KalenderView].
  final KalenderCallbacks? callbacks;

  /// The tile components used by the [MultiDayBody].
  final TileComponents? multiDayTileComponents;

  /// The [MultiDayBodyConfiguration] that will be used by the [MultiDayBody].
  final MultiDayBodyConfiguration? multiDayBodyConfiguration;

  /// The tile components used by the [MonthBody].
  final TileComponents? monthTileComponents;

  /// The [MonthBodyConfiguration] that will be used by the [MonthBody].
  final MonthBodyConfiguration? monthBodyConfiguration;

  /// The tile components used by the [ScheduleBody].
  final ScheduleTileComponents? scheduleTileComponents;

  /// The configuration used by the schedule body.
  final ScheduleBodyConfiguration? scheduleBodyConfiguration;

  /// The [KalenderInteraction] that will be used by the [KalenderBody].
  final KalenderInteraction? interaction;

  /// The snapping that will be used by the [KalenderBody].
  final KalenderSnapping? snapping;

  const KalenderBody({
    super.key,
    this.callbacks,
    this.interaction,
    this.snapping,
    this.multiDayTileComponents,
    this.multiDayBodyConfiguration,
    this.monthTileComponents,
    this.monthBodyConfiguration,
    this.scheduleTileComponents,
    this.scheduleBodyConfiguration,
  });

  @override
  State<KalenderBody> createState() => _KalenderBodyState();
}

class _KalenderBodyState extends State<KalenderBody> {
  late ValueNotifier<KalenderInteraction> _interaction;
  late ValueNotifier<KalenderSnapping> _snapping;

  @override
  void initState() {
    super.initState();
    _interaction = ValueNotifier(widget.interaction ?? KalenderInteraction());
    _snapping = ValueNotifier(widget.snapping ?? const KalenderSnapping());
  }

  @override
  void didUpdateWidget(covariant KalenderBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interaction != widget.interaction) {
      _interaction.value = widget.interaction ?? KalenderInteraction();
    }
    if (oldWidget.snapping != widget.snapping) {
      _snapping.value = widget.snapping ?? const KalenderSnapping();
    }
  }

  @override
  void dispose() {
    _interaction.dispose();
    _snapping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewController = context.kalenderController.viewController;
    return Callbacks(
      callbacks: widget.callbacks ?? context.callbacks,
      child: Interaction(
        notifier: _interaction,
        child: switch (viewController) {
          MultiDayViewController() => TileComponentProvider(
            tileComponents: widget.multiDayTileComponents ?? TileComponents.defaultComponents(),
            child: HeightPerMinute(
              notifier: viewController.heightPerMinute,
              child: Snapping(
                notifier: _snapping,
                child: MultiDayBody(configuration: widget.multiDayBodyConfiguration),
              ),
            ),
          ),
          MonthViewController() => TileComponentProvider(
            tileComponents: widget.monthTileComponents ?? TileComponents.defaultComponents(),
            child: MonthBody(configuration: widget.monthBodyConfiguration),
          ),
          ScheduleViewController() => TileComponentProvider(
            tileComponents: widget.scheduleTileComponents ?? ScheduleTileComponents.defaultComponents(),
            child: ScheduleBody(configuration: widget.scheduleBodyConfiguration),
          ),
          _ => throw ErrorHint(
            'Unsupported ViewController type: ${viewController.runtimeType}. '
            'Make sure to use the correct KalenderBody for the ViewController.',
          ),
        },
      ),
    );
  }
}
