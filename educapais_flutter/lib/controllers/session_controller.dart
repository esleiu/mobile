import 'package:flutter/foundation.dart';

import '../models/school_data.dart';
import '../services/data_repository.dart';

class SessionController extends ChangeNotifier {
  SessionController({required DataRepository repository})
    : _repository = repository;

  static const validEmail = 'pai@email.com';
  static const validPassword = '123456';

  final DataRepository _repository;

  bool _isBusy = false;
  bool _isLoggedIn = false;
  bool _needsChildSelection = false;
  String? _errorMessage;
  EducaPaisData? _data;
  DataOrigin? _origin;
  DateTime? _lastUpdatedAt;
  int _selectedChildIndex = 0;
  int _selectedTabIndex = 0;

  bool get isBusy => _isBusy;
  bool get isLoggedIn => _isLoggedIn;
  bool get needsChildSelection => _needsChildSelection;
  String? get errorMessage => _errorMessage;
  EducaPaisData? get data => _data;
  DataOrigin? get origin => _origin;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  int get selectedChildIndex => _selectedChildIndex;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isOfflineData => _origin == DataOrigin.cache;

  Responsavel? get responsavel => _data?.responsavel;
  List<Filho> get filhos => _data?.filhos ?? const [];
  Filho? get selectedFilho {
    if (_data == null || _data!.filhos.isEmpty) {
      return null;
    }
    if (_selectedChildIndex < 0 ||
        _selectedChildIndex >= _data!.filhos.length) {
      return _data!.filhos.first;
    }
    return _data!.filhos[_selectedChildIndex];
  }

  Future<bool> login({required String email, required String password}) async {
    if (_isBusy) {
      return false;
    }

    if (email.trim().toLowerCase() != validEmail ||
        password.trim() != validPassword) {
      _errorMessage = 'Credenciais invalidas. Use pai@email.com e 123456.';
      notifyListeners();
      return false;
    }

    _setBusy(true);
    try {
      final result = await _repository.loadData();
      _data = result.data;
      _origin = result.origin;
      _lastUpdatedAt = result.cacheDate;
      _isLoggedIn = true;
      _needsChildSelection = true;
      _selectedTabIndex = 0;
      _selectedChildIndex = 0;
      _errorMessage = null;
      return true;
    } catch (_) {
      _errorMessage =
          'Nao foi possivel carregar os dados. Conecte-se para carregar ao menos uma vez.';
      return false;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> refreshData() async {
    if (_isBusy || !_isLoggedIn) {
      return;
    }
    _setBusy(true);
    try {
      final result = await _repository.loadData();
      _data = result.data;
      _origin = result.origin;
      _lastUpdatedAt = result.cacheDate;
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'Falha ao atualizar. Exibindo ultimo cache disponivel.';
    } finally {
      _setBusy(false);
    }
  }

  void selectChild(int index) {
    if (index < 0 || index >= filhos.length) {
      return;
    }
    _selectedChildIndex = index;
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void confirmChildSelection() {
    _needsChildSelection = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _needsChildSelection = false;
    _selectedTabIndex = 0;
    _errorMessage = null;
    notifyListeners();
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }
}
