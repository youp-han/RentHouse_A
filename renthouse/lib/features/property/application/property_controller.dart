import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/property/data/property_repository.dart';
import 'package:renthouse/features/property/domain/property.dart';

part 'property_controller.g.dart';

@riverpod
class PropertyListController extends _$PropertyListController {
  @override
  Future<List<Property>> build() async {
    return ref.watch(propertyRepositoryProvider).getProperties();
  }

  Future<void> refreshProperties() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(propertyRepositoryProvider).getProperties();
    });
  }
}
