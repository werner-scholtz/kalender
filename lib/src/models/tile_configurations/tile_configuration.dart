import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [TileConfiguration] class is passed to the [TileBuilder].
///
/// It Stores tile specific information.
class TileConfiguration {
  const TileConfiguration({
    required this.tileType,
    required this.drawOutline,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  /// The type of the tile.
  final TileType tileType;

  /// Whether the tile should draw an outline.
  final bool drawOutline;

  /// Whether the tile continues before the visible date range.
  final bool continuesBefore;

  /// Whether the tile continues after the visible date range.
  final bool continuesAfter;
}
