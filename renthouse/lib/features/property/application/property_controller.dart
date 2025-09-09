import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/property.dart';

enum PropertyListState {
  loading,
  success,
  error,
}

class PropertyListController extends StateNotifier<PropertyListState> {
  final PropertyRepository _propertyRepository;
  List<Property> properties = [];
  String? errorMessage;

  PropertyListController(this._propertyRepository) : super(PropertyListState.loading) {
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    state = PropertyListState.loading;
    try {
      properties = await _propertyRepository.getProperties();
      state = PropertyListState.success;
    } catch (e) {
      errorMessage = e.toString();
      state = PropertyListState.error;
    }
  }

  Future<void> refreshProperties() => _loadProperties();
}

final propertyListControllerProvider = StateNotifierProvider<PropertyListController, PropertyListState>((ref) {
  return PropertyListController(
    ref.watch(propertyRepositoryProvider),
  );
});
