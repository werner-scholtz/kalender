import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/typedefs.dart';

/// The [MultiDayTileConfiguration] class is passed to the [MultiDayTileBuilder].
///
/// It Stores tile specific information.
class MultiDayTileConfiguration {
  const MultiDayTileConfiguration({
    required this.tileType,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  final TileType tileType;
  final bool continuesBefore;
  final bool continuesAfter;
}
