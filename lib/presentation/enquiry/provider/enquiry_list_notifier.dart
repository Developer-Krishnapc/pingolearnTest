import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/repository/enquiry_repo_impl.dart';
import '../../../domain/model/enquiry_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../../domain/model/predefined.dart';

final enquiryListNotifierProvider = StateNotifierProvider<EnquiryListNotifier,
    PaginationState<EnquiryListModel>>((ref) {
  return EnquiryListNotifier(ref);
});

class EnquiryListNotifier
    extends StateNotifier<PaginationState<EnquiryListModel>> {
  EnquiryListNotifier(this._ref)
      : super(PaginationState(data: const EnquiryListModel())) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  void init() {
    getStatusList();
    getEnquiryStats();
    nameCtrl.addListener(onSearch);
  }

  void onSearch() {
    debounce.run(() async {
      state = state.copyWith(
        data: state.data.copyWith(
          enquiryList: [],
        ),
        loading: true,
        error: '',
        loadMore: false,
        pageNumber: 1,
        pageSize: 10,
      );
      await Future.delayed(const Duration(milliseconds: 300));

      getEnquiryList();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    debounce.dispose();

    super.dispose();
  }

  Future<void> getEnquiryList() async {
    final data = await _ref.read(enquiryRepoProvider).getEnquiryList(
          pageNumber: state.pageNumber,
          pageSize: state.pageSize,
          location: locationCtrl.text,
          name: nameCtrl.text,
          statusId: state.data.selectedStatus?.predefinedId,
        );

    data.fold((l) {
      state = state.copyWith(loadMore: false, loading: false, error: l.message);
    }, (r) {
      state = state.copyWith(
        loadMore: r.length == state.pageSize,
        error: '',
        loading: false,
        pageNumber: state.pageNumber + 1,
        data: state.data.copyWith(
          enquiryList: [...state.data.enquiryList, ...r],
        ),
      );
    });
  }

  Future<void> getEnquiryStats() async {
    final data = await _ref.read(enquiryRepoProvider).enquiryStats();
    data.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(enquiryStats: r));
    });
  }

  Future<void> getStatusList() async {
    final data = await _ref
        .read(enquiryRepoProvider)
        .getPredefinedList(entityType: EntityType.enquiryStatus);
    data.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(statusList: r));
    });
  }

  Future<void> loadMore() async {
    if (state.loadMore) {
      await getEnquiryList();
    }
  }

  void updateSelectedStatus({Predefined? status}) {
    if (status != null)
      state = state.copyWith(
        data: state.data.copyWith(selectedStatus: status),
      );
  }

  void clearData() {
    state = state.copyWith(
      error: '',
      data: state.data.copyWith(
        selectedStatus: null,
      ),
    );
    nameCtrl.clear();
    locationCtrl.clear();
  }

  Future<String?> exportEnquiry({int? enquiryId}) async {
    String? response;
    final data = await _ref.read(enquiryRepoProvider).exportEnquiry(
          searchString: nameCtrl.text.trim(),
          statusId: state.data.selectedStatus?.predefinedId,
          location: locationCtrl.text,
          enquiryId: enquiryId,
        );

    await data.fold((l) {
      response = l.message;
    }, (r) async {
      final data = await AppUtils.attemptSaveFile('enquiry_data.xlsx', r, _ref);
      if (data == false) {
        response = 'File not downloaded';
      } else {
        AppUtils.openDefaultFileManager();
      }
    });
    return response;
  }

  void reset({bool? isFilterApplied}) {
    state = state.copyWith(
      data: state.data.copyWith(
        enquiryList: [],
        isFilterApplied: isFilterApplied ?? state.data.isFilterApplied,
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );
  }

  Future<void> applyFilter() async {
    reset(
      isFilterApplied: concatTextFilter().isNotEmpty == true ||
          state.data.selectedStatus != null,
    );
    await getEnquiryList();
  }

  Future<void> clearFilter() async {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedStatus: null,
        enquiryList: [],
        isFilterApplied: false,
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );
    nameCtrl.clear();
    locationCtrl.clear();

    await getEnquiryList();
  }

  String concatTextFilter() {
    return nameCtrl.text + locationCtrl.text;
  }
}
