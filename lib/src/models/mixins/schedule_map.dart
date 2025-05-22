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

abstract class ListItem {
  const ListItem();
}

class EventItem extends ListItem {
  final int eventId;
  final bool isFirst;
  EventItem(this.eventId, this.isFirst);
}

class MonthItem extends ListItem {}

class EmptyItem extends ListItem {}

mixin ScheduleMap {
  /// A map of all the pageIndexes to the IndexItems.
  final indexedIndexItems = <int, IndexItem>{};

  /// Get the [IndexItem] for the given pageIndex.
  IndexItem indexItem(int pageIndex) => indexedIndexItems[pageIndex]!;

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
  final indexedItemIndexDateTime = <int, IndexItemDateTime>{};

  /// Get the [IndexItemDateTime] for the given pageIndex.
  IndexItemDateTime itemIndexDateTime(int pageIndex) => indexedItemIndexDateTime[pageIndex]!;

  /// Get the [DateTime] for the given pageIndex and itemIndex.
  ///
  /// [pageIndex] is the page index to get the date for.
  /// [itemIndex] is the item index to get the date for.
  DateTime? dateTimeFromIndexForPage(int pageIndex, int itemIndex) => itemIndexDateTime(pageIndex)[itemIndex];

  /// A map of all the pageIndexes to DateTimeItemIndices.
  final indexedDateTimeItemIndex = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex dateTimeItemIndex(int pageIndex) => indexedDateTimeItemIndex[pageIndex]!;

  int? indexFromDateTimeForPage(int pageIndex, DateTime date) {
    final dateTimeFirstItemIndex = dateTimeItemIndex(pageIndex);
    return dateTimeFirstItemIndex[date];
  }

  /// Find the index closest to the given date.
  int closestIndexForPage(int pageIndex, DateTime date) {
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
  final indexedMonthIndices = <int, DateTimeItemIndex>{};

  /// Get the [DateTimeItemIndex] for the given pageIndex.
  DateTimeItemIndex monthIndices(int pageIndex) => indexedMonthIndices[pageIndex]!;

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
    indexedIndexItems.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedItemIndexDateTime.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedDateTimeItemIndex.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
    indexedMonthIndices.addEntries(List.generate(numberOfPages, (index) => MapEntry(index, {})));
  }

  void clearPage(int pageIndex) {
    indexedIndexItems[pageIndex]?.clear();
    indexedItemIndexDateTime[pageIndex]?.clear();
    indexedDateTimeItemIndex[pageIndex]?.clear();
    indexedMonthIndices[pageIndex]?.clear();
  }
}