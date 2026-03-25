import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurrence.dart';
import 'package:recurrence/recurring_event.dart';

/// Result returned by [RecurrenceDialog].
sealed class RecurrenceDialogResult {}

/// User chose to create / update with this recurrence.
class RecurrenceDialogSave extends RecurrenceDialogResult {
  final Recurrence recurrence;
  RecurrenceDialogSave(this.recurrence);
}

/// User chose to delete the entire recurrence group.
class RecurrenceDialogDelete extends RecurrenceDialogResult {}

class RecurrenceDialog extends StatefulWidget {
  /// The event being created or edited.
  final CalendarEvent event;

  /// If non-null, we're editing an existing recurrence group.
  final RecurrenceGroup? existingGroup;

  const RecurrenceDialog(this.event, {this.existingGroup, super.key});

  bool get isEditing => existingGroup != null;

  @override
  State<RecurrenceDialog> createState() => _RecurrenceDialogState();
}

class _RecurrenceDialogState extends State<RecurrenceDialog> {
  late RecurrenceType type;

  /// The event's range in local time.
  late final localEventRange = widget.event.internalRange().forLocation();

  /// Whether the user is specifying an end date or a count.
  _EndMode endMode = _EndMode.count;

  /// Number of recurrences (used when endMode == count).
  late int _count;

  /// End date (used when endMode == endDate).
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingGroup?.recurrence;
    if (existing != null) {
      type = existing.type;
      _count = existing.number;
      // Compute the implied end date from the existing recurrence.
      if (existing.type != RecurrenceType.none && existing.number > 0) {
        final lastRange = existing.type.generateDateTimeRanges(existing.first, existing.number).last;
        _endDate = lastRange.end;
      } else {
        _endDate = localEventRange.start.add(const Duration(days: 30));
      }
    } else {
      type = RecurrenceType.none;
      _count = 5;
      _endDate = localEventRange.start.add(const Duration(days: 30));
    }
  }

  /// Computed recurrence count based on current mode.
  int get _recurrenceCount {
    if (type == RecurrenceType.none) return 1;
    if (endMode == _EndMode.count) return _count;
    final recurrenceRange = DateTimeRange(
      start: localEventRange.start,
      end: _endDate.copyWith(hour: 23, minute: 59, second: 59),
    );
    return type.numberFromDateTimeRange(
      type.firstRecurrence(localEventRange, recurrenceRange),
      recurrenceRange,
    );
  }

  /// Build the [Recurrence] from current state.
  Recurrence _buildRecurrence() {
    if (endMode == _EndMode.count) {
      return Recurrence(
        first: localEventRange,
        number: type == RecurrenceType.none ? 1 : _count,
        type: type,
      );
    } else {
      return Recurrence.fromDateTimeRange(
        eventRange: localEventRange,
        recurrenceRange: DateTimeRange(
          start: localEventRange.start,
          end: _endDate.copyWith(hour: 23, minute: 59, second: 59),
        ),
        type: type,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AlertDialog(
      title: Row(
        spacing: 12,
        children: [
          Icon(Icons.event_repeat, color: colors.primary),
          Expanded(child: Text(widget.isEditing ? 'Edit Event' : 'New Event')),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event time summary card.
            Card(
              color: colors.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text('Event Time', style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.schedule, size: 16, color: colors.onSurfaceVariant),
                        Text(
                          '${_formatTime(localEventRange.start)} – ${_formatTime(localEventRange.end)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: colors.onSurfaceVariant),
                        Text(
                          _formatFullDate(localEventRange.start),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.timelapse, size: 16, color: colors.onSurfaceVariant),
                        Text(
                          _formatDuration(localEventRange.duration),
                          style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Show group info when editing.
            if (widget.isEditing && widget.existingGroup!.hasMultiple) ...[
              const SizedBox(height: 8),
              Card(
                color: colors.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: colors.onTertiaryContainer),
                      Expanded(
                        child: Text(
                          'Part of a group with ${widget.existingGroup!.eventIds.length} events. '
                          'Changes apply to all events in this group.',
                          style: theme.textTheme.bodySmall?.copyWith(color: colors.onTertiaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Recurrence type selector.
            Text('Repeat', style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
            const SizedBox(height: 4),
            SegmentedButton<RecurrenceType>(
              segments: const [
                ButtonSegment(value: RecurrenceType.none, label: Text('Once'), icon: Icon(Icons.looks_one)),
                ButtonSegment(value: RecurrenceType.daily, label: Text('Daily'), icon: Icon(Icons.today)),
                ButtonSegment(value: RecurrenceType.weekly, label: Text('Weekly'), icon: Icon(Icons.view_week)),
              ],
              selected: {type},
              onSelectionChanged: (selected) => setState(() => type = selected.first),
            ),

            // Ends-by controls (shown when recurring).
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: type != RecurrenceType.none
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // End mode toggle.
                          Text('Ends', style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
                          const SizedBox(height: 4),
                          SegmentedButton<_EndMode>(
                            segments: const [
                              ButtonSegment(
                                value: _EndMode.count,
                                label: Text('After'),
                                icon: Icon(Icons.tag),
                              ),
                              ButtonSegment(
                                value: _EndMode.endDate,
                                label: Text('On date'),
                                icon: Icon(Icons.event),
                              ),
                            ],
                            selected: {endMode},
                            onSelectionChanged: (selected) => setState(() => endMode = selected.first),
                          ),
                          const SizedBox(height: 12),

                          // Count or date picker based on mode.
                          if (endMode == _EndMode.count)
                            Row(
                              spacing: 8,
                              children: [
                                IconButton.outlined(
                                  onPressed: _count > 1 ? () => setState(() => _count--) : null,
                                  icon: const Icon(Icons.remove),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '$_count ${_count == 1 ? 'occurrence' : 'occurrences'}',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                IconButton.outlined(
                                  onPressed: _count < 365 ? () => setState(() => _count++) : null,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            )
                          else
                            OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: _pickEndDate,
                              label: Text(localizations.formatMediumDate(_endDate)),
                            ),

                          const SizedBox(height: 8),
                          // Preview info.
                          Builder(
                            builder: (context) {
                              final existingCount = widget.existingGroup?.eventIds.length ?? 0;
                              final diff = _recurrenceCount - existingCount;
                              final String message;
                              final IconData icon;
                              if (!widget.isEditing) {
                                message = '$_recurrenceCount ${_recurrenceCount == 1 ? 'occurrence' : 'occurrences'} will be created';
                                icon = Icons.repeat;
                              } else if (diff > 0) {
                                message = '$diff new ${diff == 1 ? 'occurrence' : 'occurrences'} will be added';
                                icon = Icons.add_circle_outline;
                              } else if (diff < 0) {
                                message = '${diff.abs()} ${diff.abs() == 1 ? 'occurrence' : 'occurrences'} will be removed';
                                icon = Icons.remove_circle_outline;
                              } else {
                                message = 'No change in occurrences';
                                icon = Icons.check_circle_outline;
                              }
                              return Card(
                                color: colors.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Icon(icon, size: 18, color: colors.onPrimaryContainer),
                                      Expanded(
                                        child: Text(
                                          message,
                                          style: theme.textTheme.bodySmall?.copyWith(color: colors.onPrimaryContainer),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (widget.isEditing)
          TextButton.icon(
            icon: Icon(Icons.delete_outline, color: colors.error),
            onPressed: () => Navigator.pop(context, RecurrenceDialogDelete()),
            label: Text('Delete', style: TextStyle(color: colors.error)),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              icon: Icon(type == RecurrenceType.none ? Icons.check : Icons.repeat),
              onPressed: () {
                final recurrence = _buildRecurrence();
                Navigator.pop(context, RecurrenceDialogSave(recurrence));
              },
              label: Text(
                widget.isEditing
                    ? 'Save'
                    : type == RecurrenceType.none
                        ? 'Create'
                        : 'Create $_recurrenceCount',
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _pickEndDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: localEventRange.start,
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (result == null) return;
    setState(() => _endDate = result);
  }

  String _formatTime(DateTime date) {
    return MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(date));
  }

  String _formatFullDate(DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (minutes == 0) return '$hours hr';
    return '$hours hr $minutes min';
  }
}

enum _EndMode { count, endDate }
