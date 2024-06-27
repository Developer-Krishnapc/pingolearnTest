import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/model/collection_dropdown_model.dart';
import '../../../data/model/hanger_dropdown_model.dart';
import '../../../data/repository/design_repo_impl.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../domain/model/design_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../profile/providers/user_notifier.dart';

final designListNotifierProvider =
    StateNotifierProvider<DesignListNotifier, PaginationState<DesignListModel>>(
        (ref) {
  return DesignListNotifier(ref);
});

class DesignListNotifier
    extends StateNotifier<PaginationState<DesignListModel>> {
  DesignListNotifier(this._ref)
      : super(PaginationState(data: const DesignListModel())) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final codeCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  final buyerRefNoCtrl = TextEditingController();
  final countCtrl = TextEditingController();

  final compositionCtrl = TextEditingController();
  final constructionCtrl = TextEditingController();
  final millRefNoCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final hangerSearchCtrl = TextEditingController();

  void init() {
    getCollectionList();
    getStatsData();
    searchCtrl.addListener(onSearch);
    hangerSearchCtrl.addListener(onHangerSearch);
  }

  void onSearch() {
    debounce.run(() async {
      state = state.copyWith(
        data: state.data.copyWith(
          designItemList: [],
        ),
        loading: true,
        error: '',
        loadMore: false,
        pageNumber: 1,
        pageSize: 10,
      );
      await Future.delayed(const Duration(milliseconds: 300));

      getDesignList();
    });
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    hangerSearchCtrl.dispose();
    buyerRefNoCtrl.dispose();
    countCtrl.dispose();
    compositionCtrl.dispose();
    constructionCtrl.dispose();
    millRefNoCtrl.dispose();
    widthCtrl.dispose();
    weightCtrl.dispose();
    searchCtrl.removeListener(onSearch);

    super.dispose();
  }

  Future<void> getDesignList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref.read(designRepoProvider).getDesignList(
          pageNumber: state.pageNumber,
          pageSize: state.pageSize,
          isStaff: isStaff,
          searchString: searchCtrl.text.trim(),
          buyRefNo: buyerRefNoCtrl.text,
          hangerId: state.data.selectedHanger?.id,
          composition: compositionCtrl.text,
          construction: constructionCtrl.text,
          count: countCtrl.text,
          gsm: weightCtrl.text,
          millRefNo: millRefNoCtrl.text,
          width: widthCtrl.text,
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
          designItemList: [...state.data.designItemList, ...r],
        ),
      );
    });
  }

  Future<void> getHangerList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref.read(designRepoProvider).hangerDropdownList(
          isStaff: isStaff,
          onSearch: '',
          collectionId: state.data.selectedCollection?.id,
        );
    data.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(hangerList: r));
    });
  }

  Future<void> loadMore() async {
    if (state.loadMore) {
      await getDesignList();
    }
  }

  void updateSelectedHanger({required HangerDropdownModel hangerItem}) {
    state = state.copyWith(
      data: state.data.copyWith(selectedHanger: hangerItem),
    );
  }

  void removeSelectedHanger() {
    state = state.copyWith(
      data: state.data.copyWith(selectedHanger: null),
    );
    applyFilter();
  }

  void removeSelectedCollection() {
    state = state.copyWith(
      data: state.data.copyWith(selectedCollection: null),
    );
  }

  void clearData() {
    state = state.copyWith(
      error: '',
      data: state.data.copyWith(
        selectedHanger: null,
        selectedCollection: null,
      ),
    );

    codeCtrl.clear();
    buyerRefNoCtrl.clear();
    countCtrl.clear();
    compositionCtrl.clear();
    constructionCtrl.clear();
    millRefNoCtrl.clear();
    widthCtrl.clear();
    weightCtrl.clear();
  }

  void reset({bool? isFilterApplied}) {
    state = state.copyWith(
      data: state.data.copyWith(
        designItemList: [],
        isFilterApplied: isFilterApplied ?? state.data.isFilterApplied,
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );
  }

  Future<void> getCollectionList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref
        .read(hangerRepoProvider)
        .collectionDropdownList(isStaff: isStaff);
    data.fold((l) {
      state = state.copyWith(
        error: l.message,
      );
    }, (r) {
      state = state.copyWith(
        error: '',
        data: state.data.copyWith(
          collectionList: r,
          selectedCollection: null,
          hangerList: [],
          selectedHanger: null,
        ),
      );
    });
  }

  void updateSelectedCollection({
    required CollectionDropdownModel collectionItem,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedCollection: collectionItem,
        hangerList: [],
        selectedHanger: null,
      ),
    );
    hangerSearchCtrl.clear();
    getHangerList();
  }

  Future<void> applyFilter() async {
    reset(
      isFilterApplied: concatTextFilter().isNotEmpty == true ||
          state.data.selectedHanger != null,
    );
    await getDesignList();
  }

  Future<void> clearFilter() async {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedHanger: null,
        designItemList: [],
        isFilterApplied: false,
        selectedCollection: null,
        hangerList: [],
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );

    codeCtrl.clear();
    buyerRefNoCtrl.clear();
    countCtrl.clear();
    compositionCtrl.clear();
    constructionCtrl.clear();
    millRefNoCtrl.clear();
    widthCtrl.clear();
    weightCtrl.clear();

    await getDesignList();
  }

  String concatTextFilter() {
    return buyerRefNoCtrl.text +
        countCtrl.text +
        compositionCtrl.text +
        constructionCtrl.text +
        millRefNoCtrl.text +
        widthCtrl.text +
        weightCtrl.text;
  }

  Future<String?> exportDesign() async {
    String? response;
    final data = await _ref.read(designRepoProvider).exportDesign(
          searchString: searchCtrl.text.trim(),
          buyRefNo: buyerRefNoCtrl.text,
          hangerId: state.data.selectedHanger?.id,
          composition: compositionCtrl.text,
          construction: constructionCtrl.text,
          count: countCtrl.text,
          gsm: weightCtrl.text,
          millRefNo: millRefNoCtrl.text,
          width: widthCtrl.text,
        );

    data.fold((l) {
      print('l');
      response = l.message;
    }, (r) async {
      final data = await AppUtils.attemptSaveFile('design_data.xlsx', r, _ref);
      if (data != true) {
        response = 'File Not Downloaded';
      } else {
        AppUtils.openDefaultFileManager();
      }
    });
    return response;
  }

  Future<String?> exportDesignByHangerId({required int hangerId}) async {
    String? response;
    final data = await _ref.read(designRepoProvider).exportDesign(
          hangerId: hangerId,
        );

    data.fold((l) {
      response = l.message;
    }, (r) async {
      final data =
          await AppUtils.attemptSaveFile('hanger_design_list.xlsx', r, _ref);
      if (data != true) {
        response = 'File Not Downloaded';
      } else {
        AppUtils.openDefaultFileManager();
      }
    });
    return response;
  }

  Future<void> getStatsData() async {
    final data = await _ref.read(designRepoProvider).getHomeStats();
    data.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(stats: r));
    });
  }

  void onHangerSearch() {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    debounce.run(() async {
      state = state.copyWith(
        data: state.data.copyWith(
          dropdownSearchLoading: true,
          hangerList: [],
        ),
        error: '',
      );
      await Future.delayed(const Duration(milliseconds: 300));

      final data = await _ref.read(designRepoProvider).hangerDropdownList(
            isStaff: isStaff,
            onSearch: hangerSearchCtrl.text.trim(),
            collectionId: state.data.selectedCollection?.id,
          );
      data.fold((l) {
        state = state.copyWith(
          error: l.message,
          data: state.data.copyWith(dropdownSearchLoading: false),
        );
      }, (r) {
        state = state.copyWith(
          data: state.data.copyWith(
            hangerList: r,
            dropdownSearchLoading: false,
          ),
        );
      });
    });
  }
}
