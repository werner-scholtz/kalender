import 'package:kalender/kalender_extensions.dart';

/// A map of all the items in the list.
/// [ListItem] is the type of the item.
///   * [EventItem] is the type of the event item.
///   * [MonthItem] is the type of the month item.
///   * [EmptyItem] is the type of the empty item.
typedef IndexItem = Map<int, ListItem>;

/// A map of all the item indices to the date time.
/// [int] is the index of the item.
/// [DateTime] is the date time of the item.
typedef IndexItemDateTime = Map<int, DateTime>;

/// A map of all the date times to the item index.
/// [DateTime] is the date time of the item.
/// [int] is the index of the item.
typedef DateTimeItemIndex = Map<DateTime, int>;

/// A abstract class that represents a list item.
abstract class ListItem {}

/// A class that represents an event item.
class EventItem extends ListItem {
  final String eventId;
  final bool isFirst;
  EventItem(this.eventId, this.isFirst);
}

/// A class that represents a month item.
class MonthItem extends ListItem {}

/// A class that represents an empty item.
class EmptyItem extends ListItem {}

/// A mixin that manages mappings between page indices, list items, and their associated dates
/// for paginated or scrollable calendar views.
///
/// This mixin provides utility methods and data structures to efficiently map between:
/// - Page indices and their items
/// - Item indices and their associated dates
/// - Dates and their corresponding item indices
/// - Month boundaries within pages
///
/// It is intended for use in calendar or schedule views that need to quickly look up
/// items or dates for a given page, index, or month.
///
/// Example usage:
///   - Always populate the maps for a given number of pages with [populateMaps] before using them.
///   - Add items to a page with [addItemForPage].
///   - Query for item indices, dates, or month boundaries as needed.
mixin ScheduleMap {
  Location? get location;

  /// A map of all the pageIndexes to the IndexItems.
  final _indexedIndexItems = <int, IndexItem>{};

  /// Get the [IndexItem] for the given pageIndex.
  IndexItem indexItem(int pageIndex) {
    final indexItem = _indexedIndexItems[pageIndex];
    if (indexItem == null) throw Exception('Index item for page $pageIndex not found.');
    return indexItem;
  }

  /// Get the number of items for the given pageIndex.
  int itemCountForPage(int pageIndex) => indexItem(pageIndex).length;

  /// Add an item to the map.
  ///
  /// [pageIndex] is the page index to add the item to.
  /// [item] is the item to add.
  /// [date] is the date to add.
  /// [isFirst] is whether the item is the first item of the date.
  void addItemForPage({required ListItem item, required DateTime date, required int pageIndex, bool isFirst = false}) {
    final itemsForPage = indexItem(pageIndex);
    final index = itemsForPage.length;
    itemsForPage[index] = item;

    final itemDateTimeForPage = itemIndexDateTime(pageIndex);
    itemDateTimeForPage[index] = date;

    if (isFirst) dateTimeItemIndex(pageIndex)[date] = index;
    if (item is MonthItem) monthIndices(pageIndex)[date.startOfMonth] = index;
  }

  /// A map of all the pageIndexes to IndexItemDateTimes.
  final _indexedItemIndexDateTime = <int, IndexItemDateTime>{};

  /// Get the [IndexItemDateTime] for the given pageIndex.
  IndexItemDateTime itemIndexDateTime(int pageIndex) {
    final itemIndexDateTime = _indexedItemIndexDateTime[pageIndex];
    if (itemIndexDateTime == null) throw Exception('Item index date time for page $pageIndex not found.');
    return itemIndexDateTime;
  }

  /// Get the [DateTime] for the given pageIndex and itemIndex.
  ///
  /// [pageIndex] is the page index to get the date for.
  /// [itemIndex] is the item index to get the date for.
  DateTime? dateTimeFromIndexForPage(int pageIndex, int itemIndex) => itemIndexDateTime(pageIndex)[itemIndex];

  /// A map of all the pageIndexes to DateTimeItemIndices.
  final _indexedDateTimeItemIndex = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex dateTimeItemIndex(int pageIndex) {
    final dateTimeItemIndex = _indexedDateTimeItemIndex[pageIndex];
    if (dateTimeItemIndex == null) throw Exception('Date time item index for page $pageIndex not found.');
    return dateTimeItemIndex;
  }

  int? indexFromDateTimeForPage(int pageIndex, DateTime date) {
    date = date.forLocation(location: location).asUtc.startOfDay;
    final dateTimeFirstItemIndex = dateTimeItemIndex(pageIndex);
    return dateTimeFirstItemIndex[date];
  }

  /// Find the index closest to the given date.
  int closestIndexForPage(int pageIndex, DateTime date) {
    date = date.forLocation(location: location).asUtc.startOfDay;
    final dateTimeFirstItemIndex = dateTimeItemIndex(pageIndex);
    if (dateTimeFirstItemIndex.isEmpty) return 0;

    final itemIndexDateTimeForPage = itemIndexDateTime(pageIndex);
    final lastDate = dateTimeFirstItemIndex.keys.last;
    final firstDate = dateTimeFirstItemIndex.keys.first;
    if (date.isAfter(lastDate)) {
      return itemIndexDateTimeForPage.keys.last;
    } else if (date.isBefore(firstDate)) {
      return itemIndexDateTimeForPage.keys.first;
    } else {
      // If the date is in between, we need to find the closest index.
      return itemIndexDateTimeForPage.entries.reduce((a, b) => (a.value.isBefore(b.value) ? a : b)).key;
    }
  }

  /// A map of all the pageIndexes to MonthIndices.
  final _indexedMonthIndices = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex monthIndices(int pageIndex) {
    final monthIndices = _indexedMonthIndices[pageIndex];
    if (monthIndices == null) throw Exception('Month indices for page $pageIndex not found.');
    return monthIndices;
  }

  /// Get the month index for the given pageIndex and date.
  int? monthIndexFromDateTime(int pageIndex, DateTime date) {
    final monthIndicesForPage = monthIndices(pageIndex);
    return monthIndicesForPage[date.startOfMonth];
  }

  /// Get the month index for the given pageIndex and date.
  int closestMonthIndex(int pageIndex, DateTime date) {
    final monthIndicesForPage = monthIndices(pageIndex);
    if (monthIndicesForPage.isEmpty) return 0;

    final lastDate = monthIndicesForPage.keys.last;
    final firstDate = monthIndicesForPage.keys.first;
    if (date.isAfter(lastDate)) {
      return monthIndicesForPage.values.last;
    } else if (date.isBefore(firstDate)) {
      return monthIndicesForPage.values.first;
    } else {
      // If the date is in between, we need to find the closest index.
      return monthIndicesForPage.entries.reduce((a, b) => (a.key.isBefore(b.key) ? a : b)).value;
    }
  }

  /// Populate the maps with the given number of pages.
  void populateMaps(int numberOfPages) {
    _indexedIndexItems.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    _indexedItemIndexDateTime.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    _indexedDateTimeItemIndex.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    _indexedMonthIndices.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
  }

  void clearPage(int pageIndex) {
    _indexedIndexItems[pageIndex]?.clear();
    _indexedItemIndexDateTime[pageIndex]?.clear();
    _indexedDateTimeItemIndex[pageIndex]?.clear();
    _indexedMonthIndices[pageIndex]?.clear();
  }
}
