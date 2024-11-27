import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import '/core/models/mechanic.dart';
import '/get_it.dart';
import '/data_managers/mechanics_manager.dart';
import 'check_store.dart';

class CheckController {
  late final CheckStore store;
  final mechManager = getIt<MechanicsManager>();

  List<MechanicModel> get mechanics => mechManager.mechanics;

  Future<void> init(CheckStore store) async {
    this.store = store;
  }

  Future<void> checkMechanics() async {
    final List<CheckMechList> checkList = [];
    store.resetCount(mechManager.mechanics.length);
    try {
      store.setStateLoading();
      for (final mech in mechanics) {
        final result = await mechManager.get(mech.id!);
        store.incrementCount();
        if (result.isFailure || result.data == null) {
          checkList.add(CheckMechList(mech, false));
          continue;
        }
        final psMech = result.data!;
        checkList.add(CheckMechList(mech, psMech.name == mech.name));
      }
      store.setCheckList(checkList);
      store.setStateSuccess();
    } catch (err) {
      store.setError('Error: $err');
    }
  }

  Future<void> resetMechanics() async {
    try {
      store.setStateLoading();
      await mechManager.resetLocalDatabase();
      // await _loadCSVMechs();
      // Read all Mechanics from Server
      final resultMechs = await mechManager.getMechanics();
      if (resultMechs.isFailure) {
        throw Exception(resultMechs);
      }

      // Save all mechanics in local database
      final mechs = resultMechs.data!;
      store.resetCount(mechs.length);
      for (final mech in mechs) {
        final result = await mechManager.addLocalDatabase(mech);
        if (result.isFailure) {
          throw Exception(result.error);
        }
        store.incrementCount();
      }
      store.setStateSuccess();
    } catch (err) {
      store.setError('Error: $err');
    }
  }

  Future<void> loadCSVMechs() async {
    try {
      store.setStateLoading();
      // Select csv file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        // get selected file
        File file = File(result.files.single.path!);

        // read file
        final content = await file.readAsString();

        // convert CSV content to a MechanicModel list
        List<List<dynamic>> rows = const CsvToListConverter(
          fieldDelimiter: ',',
          textDelimiter: '"',
          eol: '\n',
        ).convert(content);

        final List<MechanicModel> mechs = rows
            .map((row) => MechanicModel(name: row[1], description: row[2]))
            .toList();

        // remove header line
        mechs.removeAt(0);
        store.resetCount(mechs.length);
        for (final mech in mechs) {
          log(mech.toString());
          await mechManager.add(mech);
          store.incrementCount();
        }
      }
      store.setStateSuccess();
    } catch (err) {
      log(err.toString());
      store.setError('Teve algum problema no servidor. Tente mais tarde.');
    }
  }
}
