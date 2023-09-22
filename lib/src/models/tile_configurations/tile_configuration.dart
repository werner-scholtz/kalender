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

  final TileType tileType;
  final bool drawOutline;
  final bool continuesBefore;
  final bool continuesAfter;
}
