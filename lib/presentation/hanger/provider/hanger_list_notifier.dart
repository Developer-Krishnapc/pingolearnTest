import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/model/collection_dropdown_model.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../domain/model/hanger_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../profile/providers/user_notifier.dart';
import '../../routes/app_router.dart';
import '../../shared/providers/last_file_save_provider.dart';
import '../../shared/providers/router.dart';

final hangerListNotifierProvider =
    StateNotifierProvider<HangerListNotifier, PaginationState<HangerListModel>>(
        (ref) {
  return HangerListNotifier(ref);
});

class HangerListNotifier
    extends StateNotifier<PaginationState<HangerListModel>> {
  HangerListNotifier(this._ref)
      : super(PaginationState(data: const HangerListModel())) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  final buyerRefNoCtrl = TextEditingController();
  final countCtrl = TextEditingController();

  final compositionCtrl = TextEditingController();
  final constructionCtrl = TextEditingController();
  final millRefNoCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  void init() {
    getCollectionList();
    searchCtrl.addListener(onSearch);
  }

  void onSearch() {
    debounce.run(() async {
      state = state.copyWith(
        data: state.data.copyWith(
          hangerItemList: [],
        ),
        loading: true,
        error: '',
        loadMore: false,
        pageNumber: 1,
        pageSize: 10,
      );
      await Future.delayed(const Duration(milliseconds: 300));

      getHangerList();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
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

  Future<void> getHangerList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref.read(hangerRepoProvider).getHangerList(
          pageNumber: state.pageNumber,
          pageSize: state.pageSize,
          isStaff: isStaff,
          searchString: searchCtrl.text.trim(),
          buyRefNo: buyerRefNoCtrl.text,
          collectionId: state.data.selectedCollection?.id,
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
          hangerItemList: [...state.data.hangerItemList, ...r],
        ),
      );
    });
  }

  Future<void> getCollectionList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref
        .read(hangerRepoProvider)
        .collectionDropdownList(isStaff: isStaff);
    data.fold((l) {}, (r) {
      state = state.copyWith(
        data: state.data.copyWith(collectionList: r, selectedCollection: null),
      );
    });
  }

  Future<void> loadMore() async {
    if (state.loadMore) {
      await getHangerList();
    }
  }

  void updateSelectedCollection({
    required CollectionDropdownModel collectionItem,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(selectedCollection: collectionItem),
    );
  }

  void removeSelectedCollection() {
    state = state.copyWith(
      data: state.data.copyWith(selectedCollection: null),
    );
    applyFilter();
  }

  void clearData() {
    state = state.copyWith(
      error: '',
      data: state.data.copyWith(
        selectedCollection: null,
      ),
    );
    nameCtrl.clear();
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
        hangerItemList: [],
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
          state.data.selectedCollection != null,
    );
    await getHangerList();
  }

  Future<void> clearFilter() async {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedCollection: null,
        hangerItemList: [],
        isFilterApplied: false,
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );
    nameCtrl.clear();
    codeCtrl.clear();
    buyerRefNoCtrl.clear();
    countCtrl.clear();
    compositionCtrl.clear();
    constructionCtrl.clear();
    millRefNoCtrl.clear();
    widthCtrl.clear();
    weightCtrl.clear();

    await getHangerList();
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

  Future<String?> exportHanger() async {
    String? response;
    final data = await _ref.read(hangerRepoProvider).exportHanger(
          searchString: searchCtrl.text.trim(),
          buyRefNo: buyerRefNoCtrl.text,
          collectionId: state.data.selectedCollection?.id,
          composition: compositionCtrl.text,
          construction: constructionCtrl.text,
          count: countCtrl.text,
          gsm: weightCtrl.text,
          millRefNo: millRefNoCtrl.text,
          width: widthCtrl.text,
        );

    await data.fold((l) {
      print('l');
      response = l.message;
    }, (r) async {
      final data = await AppUtils.attemptSaveFile('hanger_data.xlsx', r, _ref);
      if (data == false) {
        response = 'File not downloaded';
      } else {
        AppUtils.openDefaultFileManager();
      }
    });
    return response;
  }

  Future<String?> exportHangerPdf({int? hangerId}) async {
    String? response;
    final data = await _ref.read(hangerRepoProvider).exportHangerPDF(
          hangerId: hangerId,
          searchString: searchCtrl.text.trim(),
          buyRefNo: buyerRefNoCtrl.text,
          collectionId: state.data.selectedCollection?.id,
          composition: compositionCtrl.text,
          construction: constructionCtrl.text,
          count: countCtrl.text,
          gsm: weightCtrl.text,
          millRefNo: millRefNoCtrl.text,
          width: widthCtrl.text,
        );

    await data.fold((l) {
      response = l.message;
    }, (r) async {
      final data =
          await AppUtils.attemptSaveFile('hanger_$hangerId.pdf', r, _ref);
      if (data == false) {
        response = 'File not downloaded';
      } else {
        final filePath = _ref.read(lastFileSaveProvider);
        _ref.read(routerProvider).push(
              PdfViewRoute(
                filePath: filePath,
                fileName: filePath.split('/').last,
              ),
            );
      }
    });
    return response;
  }
}
