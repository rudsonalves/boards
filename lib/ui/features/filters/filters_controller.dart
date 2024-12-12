import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../data/models/ad.dart';
import '../../../data/models/city.dart';
import '../../../data/models/filter.dart';
import '../../../data/models/state.dart';
import '../../components/form_controllers/currency_text_controller.dart';
import '../../../core/get_it.dart';
import '../../../logic/managers/mechanics_manager.dart';
import '../../../data/repository/gov_apis/ibge_repository.dart';
import 'filters_states.dart';

class FiltersController extends ChangeNotifier {
  FiltersState _state = FiltersStateInitial();
  final MechanicsManager mechManager = getIt<MechanicsManager>();

  FiltersState get state => _state;

  final List<StateBrModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<StateBrModel> get stateList => _stateList;
  List<String> get stateNames => _stateList.map((e) => e.nome).toList();
  List<CityModel> get cityList => _cityList;
  List<String> get cityNames => _cityList.map((e) => e.nome).toList();

  StateBrModel? _selectedState;
  CityModel? _selectedCity;

  StateBrModel? get selectedState => _selectedState;
  CityModel? get selectesCity => _selectedCity;

  final List<String> _selectedMechIds = [];
  List<String> get selectedMechIds => _selectedMechIds;

  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final mechsController = TextEditingController();
  final minPriceController = CurrencyTextController(decimalDigits: 0);
  final maxPriceController = CurrencyTextController(decimalDigits: 0);

  final _filter = FilterModel();
  SortOrder get sortBy => _filter.sortBy;
  ProductCondition get advertiser => _filter.condition;
  set sortBy(SortOrder sortBy) => _filter.sortBy = sortBy;
  set advertiser(ProductCondition advertiser) => _filter.condition = advertiser;

  final stateFocus = FocusNode();
  final cityFocus = FocusNode();
  final orderByFocus = FocusNode();

  @override
  void dispose() {
    stateController.dispose();
    cityController.dispose();
    mechsController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();

    stateFocus.dispose();
    cityFocus.dispose();
    orderByFocus.dispose();

    super.dispose();
  }

  Future<void> init(FilterModel? filter) async {
    await _startResources();
    if (filter != null) setInitialValues(filter);
  }

  void setInitialValues(FilterModel filter) {
    final minPrice = filter.minPrice;
    final maxPrice = filter.maxPrice;
    minPriceController.text = minPrice > 0 ? minPrice.toString().trim() : '';
    maxPriceController.text = maxPrice > 0 ? maxPrice.toString().trim() : '';
    stateController.text = filter.state;
    cityController.text = filter.city;
    _filter.sortBy = filter.sortBy;
    _filter.condition = filter.condition;
    _selectedMechIds.clear();
    _selectedMechIds.addAll(filter.mechanicsId);

    if (filter.state.isNotEmpty) {
      submitState(filter.state);
    }
    if (filter.city.isNotEmpty) {
      submitCity(filter.city);
    }
  }

  FilterModel? get filter => FilterModel(
        state: stateController.text.trim(),
        city: cityController.text.trim(),
        sortBy: _filter.sortBy,
        condition: _filter.condition,
        mechanicsId: selectedMechIds,
        minPrice: minPriceController.currencyValue.toInt(),
        maxPrice: maxPriceController.currencyValue.toInt(),
      );

  void mechUpdateNames(List<String> mechPsIds) {
    _selectedMechIds.clear();
    _selectedMechIds.addAll(mechPsIds);
    final mechNames = mechManager.namesFromMechIdList(_selectedMechIds);
    mechsController.text = _joinMechNames(mechNames);
  }

  String _joinMechNames(List<String> mechNames) {
    final buffer = StringBuffer();
    for (int i = 0; i < mechNames.length; i++) {
      buffer.write(mechNames[i]);
      if (i != mechNames.length - 1) {
        buffer.write(', ');
      }
    }
    return buffer.toString().trim();
  }

  void submitState(String stateName) {
    if (stateName.isEmpty) {
      _selectedState = null;
      return;
    }

    try {
      final selected = _stateList.firstWhere((s) => s.nome == stateName);
      selectState(selected);
    } catch (err) {
      _selectedState = null;
    }
  }

  void submitCity(String cityName) {
    if (cityName.isEmpty) {
      _selectedCity = null;
      return;
    }

    try {
      _selectedCity = _cityList.firstWhere((c) => c.nome == cityName);
    } catch (err) {
      _selectedCity = null;
    }
  }

  void _changeState(FiltersState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> selectState(StateBrModel? value) async {
    if (value == null) return;
    try {
      _changeState(FiltersStateLoading());
      _selectedState = value;
      await _getCity();
      _changeState(FiltersStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(FiltersStateError());
    }
  }

  void selectCity(String? value) {
    if (value != null) {
      _selectedCity = _cityList.firstWhere((city) => city.nome == value);
    }
  }

  Future<void> _startResources() async {
    try {
      _changeState(FiltersStateLoading());
      _stateList.clear();
      _stateList.addAll(await IbgeRepository.getStateList());
      _changeState(FiltersStateSuccess());
    } catch (err) {
      log(err.toString());
      _changeState(FiltersStateError());
    }
  }

  Future<void> _getCity() async {
    if (_selectedState == null) return;
    _selectedCity = null;
    _cityList.clear();
    _cityList.addAll(
      await IbgeRepository.getCityListFromApi(_selectedState!),
    );
  }
}
