import '/core/abstracts/data_result.dart';
import '/core/models/bg_name.dart';
import '/core/models/boardgame.dart';

class BoardgameRepositoryException implements Exception {
  final String message;
  BoardgameRepositoryException(this.message);

  @override
  String toString() => 'BoardgameRepositoryException: $message';
}

/// Interface for the repository responsible for managing board games.
///
/// The `IBoardgameRepository` class defines the set of operations for creating,
/// updating, retrieving, and managing board game data. These methods allow
/// interaction with the backend data store, including saving new board games,
/// updating existing ones, retrieving a specific board game by its ID, and
/// obtaining a list of all board game names.
///
/// This interface aims to provide a standardized way for interacting with
/// board game data, promoting separation of concerns and enhancing testability
/// of the application components.
abstract class IBoardgameRepository {
  /// Saves a board game to the data store.
  ///
  /// This method is responsible for creating a new `BoardgameModel` in the data
  /// store. It handles user authentication, setting default permissions, and
  /// saving associated assets such as images.
  ///
  /// [bg] - The `BoardgameModel` containing the details of the board game to
  /// be saved.
  ///
  /// Returns:
  /// - A `DataResult<BoardgameModel?>` containing the saved `BoardgameModel`
  /// or an appropriate error message.
  ///
  /// Throws:
  /// - `BoardgameRepositoryException` if the save operation fails, providing
  /// details of the issue.
  Future<DataResult<BoardgameModel?>> save(BoardgameModel bg);

  /// Updates an existing board game in the data store.
  ///
  /// This method is responsible for updating an existing `BoardgameModel` in
  /// the data store. It updates the relevant fields of the board game,
  /// including its image and/ ownership details.
  ///
  /// [bg] - The `BoardgameModel` containing the updated details of the board
  /// game to be saved.
  ///
  /// Returns:
  /// - A `DataResult<BoardgameModel?>` containing the updated `BoardgameModel`
  /// or an appropriate error message.
  ///
  /// Throws:
  /// - `BoardgameRepositoryException` if the update operation fails, providing
  /// details of the issue.
  Future<DataResult<BoardgameModel?>> update(BoardgameModel bg);

  /// Retrieves a board game from the data store by its ID.
  ///
  /// This method is responsible for fetching a `BoardgameModel` from the data
  /// store using its unique identifier. It executes a query to locate the board
  /// game and returns the corresponding model if found.
  ///
  /// [bgId] - The unique identifier (`String`) of the board game to be retrieved.
  ///
  /// Returns:
  /// - A `DataResult<BoardgameModel?>` containing the board game model if found
  /// or an appropriate error message.
  ///
  /// Throws:
  /// - `BoardgameRepositoryException` if the board game cannot be found or if
  /// there is an error during the retrieval.
  Future<DataResult<BoardgameModel?>> getById(String bgId);

  /// Retrieves a list of board game names from the data store.
  ///
  /// This method is used to fetch basic information about board games,
  /// specifically their names and year of publication. This is useful for
  /// displaying a list of available board games without requiring all the
  /// detailed information of each one.
  ///
  /// Returns:
  /// - A `DataResult<List<BGNameModel>>` containing a list of `BGNameModel`
  /// objects, each representing the name and year of publication of a board
  /// game, or an appropriate error message.
  ///
  /// Throws:
  /// - `BoardgameRepositoryException` if the query operation fails, providing
  /// details of the issue.
  Future<DataResult<List<BGNameModel>>> getNames();

  Future<DataResult<void>> delete(String bgId);
}
