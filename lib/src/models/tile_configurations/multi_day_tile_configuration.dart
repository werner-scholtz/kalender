import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [MultiDayTileConfiguration] class is passed to the [MultiDayTileBuilder].
///
/// It Stores tile specific information.
class MultiDayTileConfiguration {
  const MultiDayTileConfiguration({
    required this.tileType,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  /// The type of the tile.
  final TileType tileType;

  /// Whether the tile continues before the visible date range.
  final bool continuesBefore;

  /// Whether the tile continues after the visible date range.
  final bool continuesAfter;
}
