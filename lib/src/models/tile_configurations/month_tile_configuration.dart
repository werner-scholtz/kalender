import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/typedefs.dart';

/// The [MonthTileConfiguration] class is passed to the [MonthTileBuilder].
///
/// It Stores tile specific information.
class MonthTileConfiguration {
  const MonthTileConfiguration({
    required this.tileType,
    required this.date,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  final TileType tileType;
  final DateTime date;
  final bool continuesBefore;
  final bool continuesAfter;
}
