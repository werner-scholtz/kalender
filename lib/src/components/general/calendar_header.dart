// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:kalender/src/models/view_configurations/view_configuration.dart';

// class CalendarViewHeader<T extends Object?> extends StatelessWidget {
//   const CalendarViewHeader({
//     super.key,
//     required this.visibleDateTimeRange,
//     required this.currentPageConfiguration,
//     required this.pageConfigurations,
//     required this.onContentChanged,
//     required this.onDateSelectorPressed,
//     required this.onLeftArrowPressed,
//     required this.onRightArrowPressed,
//   });

//   final DateTimeRange visibleDateTimeRange;
//   final ViewConfiguration currentPageConfiguration;
//   final List<ViewConfiguration> pageConfigurations;

//   final Function(ViewConfiguration pageView) onContentChanged;
//   final VoidCallback onLeftArrowPressed;
//   final VoidCallback onRightArrowPressed;
//   final VoidCallback onDateSelectorPressed;

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobileDevice =
//         false; //CalendarInternals.of<T>(context).configuration.isMobileDevice;
//     return Row(
//       children: <Widget>[
//         Builder(
//           builder: (BuildContext context) {
//             DateFormat format = DateFormat('yyyy MMM');
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: isMobileDevice ? 4 : 8),
//               child: Text(
//                 '${format.format(visibleDateTimeRange.start)} - ${format.format(visibleDateTimeRange.end)}',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             );
//             // if (currentPageConfiguration.viewType == ViewType.schedule) {

//             // } else {
//             //   return Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 8),
//             //     child: Text(
//             //       DateFormat('yyyy MMMM').format(visibleDateTimeRange.start
//             //           .add(visibleDateTimeRange.end.difference(visibleDateTimeRange.start) ~/ 2)),
//             //       style: Theme.of(context).textTheme.titleMedium,
//             //     ),
//             //   );
//             // }
//           },
//         ),
//         IconButton.filledTonal(
//           onPressed: onDateSelectorPressed,
//           icon: const Icon(Icons.edit_calendar),
//         ),
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: isMobileDevice ? 0 : 2),
//                 child: IconButton.filledTonal(
//                   onPressed: onLeftArrowPressed,
//                   icon: const Icon(Icons.chevron_left),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: isMobileDevice ? 0 : 2),
//                 child: IconButton.filledTonal(
//                   onPressed: onRightArrowPressed,
//                   icon: const Icon(Icons.chevron_right),
//                 ),
//               ),
//               DropdownMenu<ViewConfiguration>(
//                 width: isMobileDevice ? 80 : 150,
//                 initialSelection: currentPageConfiguration,
//                 dropdownMenuEntries: pageConfigurations
//                     .map(
//                       (ViewConfiguration e) => DropdownMenuEntry<ViewConfiguration>(
//                         value: e,
//                         label: e.name,
//                       ),
//                     )
//                     .toList(),
//                 enableSearch: false,
//                 onSelected: (ViewConfiguration? value) {
//                   if (value == null) return;
//                   onContentChanged(value);
//                 },
//                 inputDecorationTheme: const InputDecorationTheme(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                   border: OutlineInputBorder(gapPadding: 16),
//                   constraints: BoxConstraints(maxHeight: 42, minHeight: 38),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
