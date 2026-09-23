// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// Installs the providers a header or body of a view reads.
///
/// [callbacks] and [interaction] override the ones of the enclosing [KalenderView] when set. [snapping] is installed
/// only when [installSnapping] is true, and [heightPerMinute] only when it is set.
class ViewProviders extends StatefulWidget {
  const ViewProviders({
    super.key,
    required this.tileComponents,
    required this.child,
    this.callbacks,
    this.interaction,
    this.snapping,
    this.installSnapping = false,
    this.heightPerMinute,
  });

  final TileComponents tileComponents;
  final KalenderCallbacks? callbacks;
  final KalenderInteraction? interaction;
  final KalenderSnapping? snapping;
  final bool installSnapping;
  final ValueNotifier<double>? heightPerMinute;
  final Widget child;

  @override
  State<ViewProviders> createState() => _ViewProvidersState();
}

class _ViewProvidersState extends State<ViewProviders> {
  late final ValueNotifier<KalenderInteraction> _interaction;
  late final _snapping = ValueNotifier(widget.snapping ?? const KalenderSnapping());
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final interaction = widget.interaction ?? context.interaction;
    if (!_initialized) {
      _interaction = ValueNotifier(interaction);
      _initialized = true;
    } else {
      _interaction.value = interaction;
    }
  }

  @override
  void didUpdateWidget(covariant ViewProviders oldWidget) {
    super.didUpdateWidget(oldWidget);
    _interaction.value = widget.interaction ?? context.interaction;
    if (oldWidget.snapping != widget.snapping) _snapping.value = widget.snapping ?? const KalenderSnapping();
  }

  @override
  void dispose() {
    _interaction.dispose();
    _snapping.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child;
    if (widget.heightPerMinute case final heightPerMinute?) {
      child = HeightPerMinute(notifier: heightPerMinute, child: child);
    }
    if (widget.installSnapping) child = Snapping(notifier: _snapping, child: child);
    return Callbacks(
      callbacks: widget.callbacks ?? context.callbacks,
      child: Interaction(
        notifier: _interaction,
        child: TileComponentProvider(tileComponents: widget.tileComponents, child: child),
      ),
    );
  }
}
