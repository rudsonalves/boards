import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '/core/abstracts/data_result.dart';
import '/data/models/bg_name.dart';
import '/data/models/boardgame.dart';
import '/core/get_it.dart';
import '/data/repository/firebase/common/fb_functions.dart';
import '/data/repository/interfaces/remote/i_boardgame_repository.dart';
import '/data/repository/interfaces/remote/i_bg_names_repository.dart';
import '/core/utils/utils.dart';

/// Class that holds the paths of the converted image and the downloaded local
/// image.
class ImageConversionResult {
  final String convertedImagePath;
  final String localPath;

  ImageConversionResult({
    required this.convertedImagePath,
    required this.localPath,
  });

  List<String> get attributes => [convertedImagePath, localPath];
}

class BoardgamesManager {
  final boardgameRepository = getIt<IBoardgameRepository>();
  late final IBgNamesRepository localBoardgameRepository;

  final List<BGNameModel> _bgList = [];

  List<BGNameModel> get bgList => _bgList;
  // List of names
  List<String> get bgNames => _bgList.map((bg) => bg.name!).toList();

  Future<void> initialize() async {
    localBoardgameRepository = await getIt.getAsync<IBgNamesRepository>();
    await _initializeBGNames();
  }

  /// Initializes the list of board game names by retrieving data from both
  /// the local SQLite database and the Parse server, updating and sorting the
  /// data as necessary.
  ///
  /// This method performs the following steps:
  /// 1. Loads the list of board game names from the local database, storing
  ///    them in the `_localBGsList` for quick access.
  /// 2. Retrieves the list of board game names from the Parse server, getting
  ///    the most up-to-date information available.
  /// 3. Updates the local database to add any new entries from the Parse server,
  ///    ensuring that local storage reflects the latest data.
  /// 4. Sorts `_localBGsList` alphabetically by name, allowing for an organized
  ///    display.
  ///
  /// Returns:
  /// - A [Future] that completes with a [DataResult<void>]:
  ///   - On success, a [DataResult.success] with no data.
  ///   - On failure, a [DataResult.failure] with a message detailing the error.
  ///
  /// Throws:
  /// - This method does not throw directly, but any error during processing is
  ///   caught and returned as a failure.
  Future<DataResult<void>> _initializeBGNames() async {
    try {
      // Retrieves the list of board game names from the local SQLite database.
      await _getLocalBgNames();

      // Retrieves the list of board game names from the local SQLite database.
      final newsBGNames = await _getDataBgNames();

      // Update local SQLite database
      await _updateLocalBgNames(newsBGNames);

      // Sort by names
      _sortingBGNames();
      return DataResult.success(null);
    } catch (err) {
      return _handleError('_initializeBGNames', err);
    }
  }

  /// Saves a [BoardgameModel] instance by performing image conversion,
  /// remote saving, and local database update.
  ///
  /// This method performs the following steps:
  /// 1. Converts the provided image of the board game using
  ///    [_getAndConvertImage].
  /// 2. Saves the updated [BoardgameModel] to the remote Parse server
  ///    repository. If this operation fails, an exception is thrown.
  /// 3. Deletes any temporary files created during the image conversion to free
  ///    up storage.
  /// 4. Updates the local SQLite database with the new board game data, using
  ///    the game's name and year for display.
  ///
  /// Parameters:
  /// - [bg]: The [BoardgameModel] instance to be saved, which contains the
  ///   game’s details, including its image path.
  ///
  /// Returns:
  /// - A [Future] that completes with a [DataResult<void>]:
  ///   - On success, a [DataResult.success] with no data.
  ///   - On failure, a [DataResult.failure] with a message detailing the error.
  ///
  /// Throws:
  /// - [Exception] if saving to the repository fails or if the new board game
  ///   data is null.
  /// - Any error occurring in the image processing or file deletion will also
  ///   be captured and returned as a failure via [_handleError].
  Future<DataResult<void>> save(BoardgameModel bg) async {
    try {
      // Step 1: Convert the image, updating the board game’s image path.
      final convertResult = await _getAndConvertImage(
        image: bg.image,
        name: bg.name,
        year: bg.publishYear,
        forceJpg: false,
      );
      bg.image = convertResult.convertedImagePath;

      // Step 2: Save the updated board game to the remote Parse server.
      final result = await boardgameRepository.add(bg);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      final newBg = result.data;

      // Validate that the new board game data is non-null.
      if (newBg == null) {
        throw Exception('new bg creating error');
      }

      // Step 3: Remove temporary files from image conversion.
      await _removeFiles(convertResult.attributes);

      // Step 4: Update the local database with the new board game name.
      final bgName = BGNameModel(
        id: newBg.id,
        name: '${newBg.name} (${newBg.publishYear})',
      );
      await _updadeLocalBGList(bgName);

      return DataResult.success(null);
    } catch (err) {
      return _handleError('save', err);
    }
  }

  /// Updates an existing [BoardgameModel] by processing its image, updating
  /// it in the remote Parse server, and synchronizing the local database if
  /// needed.
  ///
  /// This method performs the following steps:
  /// 1. Processes the board game image by converting it to a standard format if
  ///   necessary.
  ///    The updated image path is assigned to `bg.image`.
  /// 2. Updates the board game data in the Parse server. If this update fails,
  ///    an exception is thrown, ensuring the integrity of the data.
  /// 3. Checks if the local database requires updating with the latest board
  ///    game information.
  ///    If the name has changed, the local cache (`_localBGsList`) and the
  ///    SQLite database are updated
  ///    and sorted.
  ///
  /// Parameters:
  /// - [bg]: The [BoardgameModel] instance containing the board game data to
  ///   update.
  ///
  /// Returns:
  /// - A [Future] that completes with a [DataResult<void>]:
  ///   - On success, a [DataResult.success] with no data.
  ///   - On failure, a [DataResult.failure] with a message detailing the error.
  ///
  /// Throws:
  /// - This method does not directly throw; instead, it uses [_handleError]
  ///   to capture and return any encountered error as a failure in
  ///   [DataResult].
  Future<DataResult<void>> update(BoardgameModel bg) async {
    try {
      // Step 1: Process image, converting if necessary, and update `bg.image`
      // path
      await _processImageForUpdate(bg, false);

      // Step 2: Update the board game in the Parse server
      final newBg = await _updateBoardgameInServer(bg);

      // Step 3: Update the local database with new board game information if
      // needed
      await _updateLocalDatabaseIfNeeded(newBg);

      return DataResult.success(null);
    } catch (err) {
      return _handleError('update', err);
    }
  }

  Future<DataResult<void>> delete(String bgId) async {
    try {
      await boardgameRepository.delete(bgId);
      await localBoardgameRepository.delete(bgId);
      return DataResult.success(null);
    } catch (err) {
      return _handleError('delete', err);
    }
  }

  Future<DataResult<BoardgameModel?>> getBoardgameId(String bgId) async {
    return await boardgameRepository.get(bgId);
  }

  /// Processes the image for a board game update by converting it to a standard
  /// format if needed and updating the [BoardgameModel]'s image path.
  ///
  /// This method performs the following steps:
  /// 1. Calls [_getAndConvertImage] to check if the board game's image needs
  ///    conversion.
  ///    If necessary, the image is downloaded, converted to a JPEG, and stored
  ///    locally. The resulting path of the converted image is assigned to
  ///    `bg.image`.
  /// 2. Deletes any temporary files created during the conversion process to
  ///    free up storage and avoid leaving residual files on the device.
  ///
  /// Parameters:
  /// - [bg]: The [BoardgameModel] instance containing the image to be
  ///   processed.
  ///   The method updates the `image` property of this instance with the path
  ///   of the converted image if conversion occurs.
  ///
  /// Returns:
  /// - A [Future<void>] that completes once the image processing and file
  ///   cleanup have finished. No data is returned.
  ///
  /// Throws:
  /// - Any error occurring during the image conversion or file deletion will be
  ///   propagated to the calling method, which is responsible for handling
  ///   errors.
  Future<void> _processImageForUpdate(
    BoardgameModel bg, [
    bool forceJpg = true,
  ]) async {
    final convertResult = await _getAndConvertImage(
      image: bg.image,
      name: bg.name,
      year: bg.publishYear,
      forceJpg: forceJpg,
    );
    bg.image = convertResult.convertedImagePath;

    // Remove temporary files after conversion
    // await _removeFiles([convertResult.localPath]);
  }

  /// Updates the provided [BoardgameModel] instance in the remote Parse server
  /// and retrieves the updated data.
  ///
  /// This method performs the following steps:
  /// 1. Calls [boardgameRepository.update] to send the updated board game data
  ///    to the Parse server.
  /// 2. Checks the result for any errors. If the update operation fails, an
  ///    exception with the error message is thrown to ensure reliable error
  ///    handling.
  /// 3. Verifies that the returned data (`newBg`) is not null, ensuring the
  ///    update was successful and that the new data was returned.
  ///
  /// Parameters:
  /// - [bg]: The [BoardgameModel] instance containing the data to update in the
  ///   server.
  ///
  /// Returns:
  /// - A [Future<BoardgameModel>] that completes with the updated
  ///   [BoardgameModel] data from the server if the operation is successful.
  ///
  /// Throws:
  /// - An [Exception] if the update operation fails or if the server returns
  ///   null data, indicating an issue with the update process.
  Future<BoardgameModel> _updateBoardgameInServer(BoardgameModel bg) async {
    final result = await boardgameRepository.update(bg);
    if (result.isFailure) throw Exception(result.error);

    final newBg = result.data;
    if (newBg == null) throw Exception('new bg creating error');
    return newBg;
  }

  /// Updates the local database and in-memory list with new board game
  /// information, if there are changes in the board game’s name.
  ///
  /// This method performs the following steps:
  /// 1. Searches for the board game in the in-memory list `_localBGsList` by
  ///    matching its ID with `newBg.id`. If the board game is not found, an
  ///    exception is thrown.
  /// 2. Compares the current name in the local database with the updated name
  ///    generated from `newBg`. If the names differ, updates the local
  ///    repository with the new name.
  /// 3. Updates `_localBGsList` to reflect the new name, ensuring the in-memory
  ///    data stays synchronized with the local database. Then, sorts the list
  ///    alphabetically.
  ///
  /// Parameters:
  /// - [newBg]: The updated [BoardgameModel] instance from the server,
  ///   containing the latest board game information.
  ///
  /// Returns:
  /// - A [Future<void>] that completes when the local database and in-memory
  ///   list have been updated and sorted, if needed.
  ///
  /// Throws:
  /// - An [Exception] if the board game ID cannot be found in `_localBGsList`,
  ///   indicating that the local data is out of sync.
  Future<void> _updateLocalDatabaseIfNeeded(BoardgameModel newBg) async {
    final bgName = _bgList.firstWhere((b) => b.id == newBg.id,
        orElse: () => BGNameModel());
    if (bgName.id == null) throw Exception('_localBGsList bgId not found.');

    final updatedName = '${newBg.name} (${newBg.publishYear})';
    if (bgName.name != updatedName) {
      bgName.name = updatedName;
      await localBoardgameRepository.update(bgName);

      // Update in-memory list and sort it
      final index = _bgList.indexWhere((b) => b.id == newBg.id);
      if (index == -1) throw Exception('_localBGsList index not found.');

      _bgList[index].name = bgName.name;
      _sortingBGNames();
    }
  }

  /// Handles errors by logging and wrapping them in a [DataResult] failure
  /// response.
  ///
  /// This method takes the name of the method where the error occurred and the
  /// actual error object.
  /// It logs a detailed error message and returns a failure wrapped in
  /// [DataResult].
  ///
  /// Parameters:
  /// - [method]: The name of the method where the error occurred.
  /// - [error]: The error object that describes what went wrong.
  ///
  /// Returns:
  /// A [DataResult.failure] with a [GenericFailure] that includes a detailed
  /// message.
  DataResult<T> _handleError<T>(String module, Object error) {
    final fullMessage = 'BoardgamesManager.$module: $error';
    log(fullMessage);
    return DataResult.failure(GenericFailure(message: fullMessage));
  }

  /// Updates the local SQLite database with new boardgame names.
  ///
  /// This method compares the provided list of boardgame names from the
  /// remote Parse server with the current list stored in the local SQLite
  /// database. If a boardgame is found in the remote list but is not present
  /// locally, it will be added to the local database.
  ///
  /// The method works by iterating over the list of [BGNameModel] objects
  /// and checking whether each one exists in the local cache (_bgsList).
  /// If it doesn't exist, it adds the boardgame to the local database
  /// and updates the in-memory list (_bgsList).
  ///
  /// Parameters:
  /// - [bgList]: A list of [BGNameModel] objects fetched from the Parse server
  ///   that needs to be synchronized with the local storage.
  ///
  /// Returns:
  /// - This method returns a [Future<void>] since it asynchronously performs
  ///   database operations.
  ///
  /// Throws:
  /// - Any error that occurs during the addition of new boardgames to the local
  ///   database will be propagated and needs to be handled by the caller.
  Future<void> _updateLocalBgNames(List<BGNameModel> bgList) async {
    // Retrieves bg ids from parse server bg list.
    final bgIds = _bgList.map((bg) => bg.id!).toList();

    // Iterates over each boardgame in the provided list from the server
    // and adds it to the local SQLite database if it's not already present.
    for (final bg in bgList) {
      if (!bgIds.contains(bg.id!)) {
        // Adds new boardgame to the local repository and updates the local
        // cache.
        final result = await localBoardgameRepository.add(bg);
        if (result.isFailure) {
          throw Exception(result.error);
        }

        final newBg = result.data!;
        _bgList.add(newBg);
        bgIds.add(newBg.id!);
      }
    }
  }

  /// Downloads and converts an image, if necessary.
  ///
  /// [image] - URL or path of the image.
  /// [name] - Name associated with the image, used for naming.
  /// [year] - Year associated with the image, used for naming.
  ///
  /// Returns an [ImageConversionResult] containing the path to the converted
  /// image and the path to the locally downloaded image.
  Future<ImageConversionResult> _getAndConvertImage({
    required String image,
    required String name,
    required int year,
    bool forceJpg = true,
  }) async {
    // Image is already on the parse server
    if (FbFunctions.isFirebaseStorageUrl(image)) {
      return ImageConversionResult(convertedImagePath: image, localPath: '');
    }

    // If the image is on an external server, download a local copy
    final localImagePath =
        image.startsWith('http') ? await _downloadImage(image) : image;

    // Standardize image names
    final extension = forceJpg
        ? 'jpg'
        : image.split('.').last.toLowerCase() == 'png'
            ? 'png'
            : 'jpg';
    final imageName =
        '${Utils.normalizeFileName(name.replaceAll(' ', '_'))}_$year.$extension';

    // Convert image
    final convertedImagePath = await _convertImage(localImagePath, imageName);

    return ImageConversionResult(
      convertedImagePath: convertedImagePath,
      localPath: localImagePath,
    );
  }

  /// Adds a new board game name to the local SQLite database and updates the
  /// in-memory list.
  ///
  /// This private method first adds the new board game ([BGNameModel]) to the
  /// local storage by calling [localBoardgameRepository.add]. After adding to
  /// the local repository, it adds the board game name to the in-memory list
  /// (`_bgsList`) for immediate use in the application. Finally, it sorts the
  /// updated list by name to ensure consistency.
  ///
  /// Params:
  /// - [bgName]: The [BGNameModel] object representing the board game name to
  ///   be added.
  ///
  /// Returns:
  /// - A [Future] with no return value.
  Future<void> _updadeLocalBGList(BGNameModel bgName) async {
    await localBoardgameRepository.add(bgName);
    _bgList.add(bgName);
    _sortingBGNames();
  }

  /// Retrieves the list of board game names from the Database.
  ///
  /// This private method calls the [boardgameRepository.getNames] method
  /// to get a list of board game names from the Parse server.
  /// The result contains instances of [BGNameModel] if successful.
  ///
  /// Returns:
  /// - A [Future] containing a [DataResult] with a list of [BGNameModel]
  /// objects.
  Future<List<BGNameModel>> _getDataBgNames() async {
    final result = await boardgameRepository.getNames();
    if (result.isFailure) {
      throw Exception('_getParseBgNames: ${result.error}');
    }

    return result.data!;
  }

  /// Retrieves the list of board game names from the local SQLite database.
  ///
  /// This private method queries the [localBoardgameRepository.get] to get a
  /// list of board game names from the local storage.
  /// It clears the current list (`_bgsList`) and adds all the retrieved board
  /// games.
  /// If no records are found, it returns immediately.
  /// Once new records are added to the list, the method sorts the board games
  /// by name.
  ///
  /// Returns:
  /// - A [Future] with no return value.
  Future<void> _getLocalBgNames() async {
    final result = await localBoardgameRepository.getAll();
    if (result.isFailure) {
      throw Exception(result.error);
    }
    final bgs = result.data!;

    // Clear the current list of board game names.
    _bgList.clear();

    // If no board game names are found, simply return.
    if (bgs.isEmpty) return;

    // Add the retrieved names to the list and sort them.
    _bgList.addAll(bgs);
    _sortingBGNames();
  }

  /// Deletes all files at the specified paths.
  ///
  /// This method iterates through each provided path and deletes the
  /// corresponding file if the path is not empty.
  /// If a path is empty, it is skipped.
  ///
  /// [paths] - A list of file paths to be deleted. Each file at the specified
  /// path will be deleted if it exists.
  /// Errors during file deletion will propagate up and should be handled by the
  /// caller.
  Future<void> _removeFiles(List<String> paths) async {
    for (final path in paths) {
      // If the path is empty, skip to the next iteration
      if (path.isEmpty) continue;

      // Attempt to delete the file at the specified path
      if (!path.startsWith('http')) {
        await File(path).delete();
      }
    }
  }

  /// Converts an image file to a JPEG format with specific dimensions and
  /// quality.
  ///
  /// This function reads an image from the provided [imagePath], resizes it to
  /// a fixed size of 800x800 pixels, encodes it as a JPEG with a specified
  /// quality, and then saves the converted image in the application's document
  /// directory.
  ///
  /// - [imagePath]: The path to the original image file.
  /// - [imageName]: The name to use for the converted image file.
  ///
  /// Returns a [String] representing the path to the newly converted JPEG
  /// image.
  ///
  /// Throws:
  /// - [Exception] if the image cannot be decoded, or if any other error occurs
  ///   during processing.
  Future<String> _convertImage(String imagePath, String imageName) async {
    try {
      // Attempt to decode the image from the provided file path.
      final image = img.decodeImage(File(imagePath).readAsBytesSync());
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize the image to have a width and height of 600 pixels.
      final resizedImage = img.copyResize(image, width: 600, height: 600);

      // Get the path to the application's documents directory.
      final directory = await getApplicationDocumentsDirectory();

      // Generate the new file path where the converted image will be saved.
      final newPath = join(directory.path, imageName);

      final extension = imageName.split('.').last;
      if (extension == 'jpg') {
        // Write the resized image to the new file path in JPEG format with a
        // quality of 75.
        File(newPath).writeAsBytesSync(
          img.encodeJpg(resizedImage, quality: 75),
        );
      } else {
        // Write the resized image to the new file path in PNG format with a
        // level of 6.
        File(newPath).writeAsBytesSync(
          img.encodePng(resizedImage, level: 6),
        );
      }

      return newPath;
    } catch (err) {
      throw Exception('Error converting image: $err');
    }
  }

  /// Downloads an image from a given URL and saves it to the device's document
  /// directory.
  ///
  /// This function fetches an image from the provided [url] and saves it in the
  /// application’s document directory. If the download fails, an exception is
  /// thrown.
  ///
  /// - [url]: The URL from where the image will be downloaded.
  ///
  /// Returns a [String] representing the path where the downloaded image has
  /// been saved.
  ///
  /// Throws:
  /// - [Exception] if the HTTP request fails, or if any other error occurs
  ///   during the process.
  Future<String> _downloadImage(String url) async {
    try {
      // Send an HTTP GET request to the provided URL to fetch the image.
      final response = await http.get(Uri.parse(url));

      // Check if the HTTP request was successful (status code 200).
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Get the application's documents directory where the image will be
      // saved.
      final directory = await getApplicationDocumentsDirectory();

      // Create a complete path for the new image file using the original image
      // filename
      final path = join(directory.path, basename(url));

      // Create a file object for the specified path.
      final file = File(path);

      // Write the bytes of the image (received in the response) to the file.
      await file.writeAsBytes(response.bodyBytes);

      return file.path;
    } catch (err) {
      throw Exception('Error downloading image: $err');
    }
  }

  /// Sorts the list of board games (`_bgsList`) based on the alphabetical order
  /// of the board game names present in `bgNames`.
  ///
  /// This method will:
  /// 1. Sort the list of board game names alphabetically.
  /// 2. Rearrange the `_bgsList` to match the sorted order of `bgNames`.
  ///
  /// The purpose is to keep `_bgsList` in sync with an alphabetically sorted
  /// version of the board game names, maintaining the order consistency.
  void _sortingBGNames() {
    // Return if the list has 1 or fewer elements
    if (_bgList.length < 2) return;

    // Step 1: Make a copy of the `bgNames` list and sort it alphabetically.
    List<String> names = List.from(bgNames);
    names.sort(); // Sorts the names in alphabetical order

    // Step 2: Create a sorted list of `_localBGsList` elements based on the
    // sorted names
    final sortedList = names
        .map(
          (name) => _bgList.firstWhere((item) => item.name == name),
        )
        .toList();

    // Step 3: Replace `_localBGsList` with the newly sorted list
    _bgList
      ..clear()
      ..addAll(sortedList);
  }
}
