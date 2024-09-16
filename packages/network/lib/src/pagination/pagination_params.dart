import 'package:meta/meta.dart';

/// Base for different pagination strategy parameters.
///
/// This class serves as a common interface for various pagination strategies.
@immutable
sealed class PaginationStrategyParams {
  const PaginationStrategyParams({required this.limit});

  /// The maximum number of items to be returned in a single page.
  final int limit;
}

/// Represents parameters for cursor-based pagination strategy.
///
/// This strategy uses a cursor to keep track of the current position in the dataset.
@immutable
class CursorBasedStrategyParams extends PaginationStrategyParams {
  /// Creates a new instance of [CursorBasedStrategyParams].
  ///
  /// [limit] specifies the maximum number of items to be returned.
  /// [cursor] is an opaque string that points to a specific item in the dataset.
  /// If [cursor] is null, it typically indicates the start of the dataset.
  const CursorBasedStrategyParams({required super.limit, this.cursor});

  /// An string that points to a specific item id in the dataset.
  final String? cursor;
}

/// Represents parameters for offset-based pagination strategy.
///
/// This strategy uses an offset to skip a certain number of items in the dataset.
@immutable
class OffsetBasedStrategyParams extends PaginationStrategyParams {
  /// Creates a new instance of [OffsetBasedStrategyParams].
  ///
  /// [limit] specifies the maximum number of items to be returned.
  /// [offset] specifies the number of items to skip before starting to return results.
  /// If [offset] is null, it typically indicates the start of the dataset.
  const OffsetBasedStrategyParams({required super.limit, this.offset});

  /// The number of items to skip before starting to return results.
  final int? offset;
}

/// Represents a paginated response containing a list of items and pagination metadata.
@immutable
class PaginatedResponse<T> {
  /// Creates a new instance of [PaginatedResponse].
  ///
  /// [results] is the list of items returned in this page.
  /// [hasMore] indicates whether there are more items available in subsequent pages.
  /// [paginationParams] contains the parameters needed to fetch the next page.
  const PaginatedResponse({
    required this.results,
    required this.hasMore,
    required this.paginationParams,
  });

  /// The list of items returned in this page.
  final List<T> results;

  /// Indicates whether there are more items available in subsequent pages.
  final bool hasMore;

  /// The parameters needed to fetch the next page.
  ///
  /// This will be an instance of a subclass of [PaginationStrategyParams],
  /// containing the necessary information for the specific pagination strategy in use.
  final PaginationStrategyParams paginationParams;
}
