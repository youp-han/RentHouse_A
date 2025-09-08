import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:renthouse/features/lease/data/lease_repository.dart';
import 'package:renthouse/features/lease/domain/lease.dart';

part 'lease_controller.g.dart';

@riverpod
class LeaseController extends _$LeaseController {
  @override
  Future<List<Lease>> build() async {
    return ref.watch(leaseRepositoryProvider).getLeases();
  }

  Future<void> addLease(Lease lease) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(leaseRepositoryProvider).createLease(lease);
      return ref.read(leaseRepositoryProvider).getLeases();
    });
  }

  Future<void> updateLease(Lease lease) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(leaseRepositoryProvider).updateLease(lease);
      return ref.read(leaseRepositoryProvider).getLeases();
    });
  }

  Future<void> deleteLease(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(leaseRepositoryProvider).deleteLease(id);
      return ref.read(leaseRepositoryProvider).getLeases();
    });
  }
}