import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/model/collection_dropdown_model.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../domain/model/document_model.dart';
import '../../../domain/model/hanger_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../design/providers/design_list_notifier.dart';
import '../../design/providers/design_notifier.dart';
import '../../profile/providers/user_notifier.dart';
import '../../shared/providers/router.dart';
import 'hanger_list_notifier.dart';

final hangerNotifierProvider =
    StateNotifierProvider<HangerNotifier, PaginationState<HangerModel>>((ref) {
  return HangerNotifier(ref);
});

class HangerNotifier extends StateNotifier<PaginationState<HangerModel>> {
  HangerNotifier(this._ref)
      : super(PaginationState(data: const HangerModel(), loading: false)) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  final buyerRefNoCtrl = TextEditingController();
  final countCtrl = TextEditingController();

  final compositionCtrl = TextEditingController();
  final constructionCtrl = TextEditingController();
  final millRefNoCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void init() {
    getCollectionList();
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

    super.dispose();
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
  }

  Future<void> addSelectedImage(List<DocumentModel> images) async {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedImageList: images,
        selectedImageListLength: images.length,
      ),
    );
  }

  void clearData() {
    state = state.copyWith(
      error: '',
      loading: false,
      data: state.data.copyWith(
        selectedImageList: [],
        selectedCollection: null,
        selectedImageListLength: 0,
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

  Future<bool> addHanger() async {
    bool response = false;
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');
      final data = await _ref.read(hangerRepoProvider).addHanger(
            buyerRefNo: buyerRefNoCtrl.text,
            composition: compositionCtrl.text,
            construction: constructionCtrl.text,
            collectionId: state.data.selectedCollection?.id ?? 0,
            count: countCtrl.text,
            hangerCode: codeCtrl.text,
            hangerName: nameCtrl.text,
            millRefNo: millRefNoCtrl.text,
            weight: weightCtrl.text.isEmpty ? null : int.parse(weightCtrl.text),
            width: widthCtrl.text.isEmpty ? null : int.parse(widthCtrl.text),
            selectedImageLIst:
                state.data.selectedImageList.map((e) => e.url).toList(),
          );
      await data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) async {
        response = true;
        final hangerListNotifier =
            _ref.read(hangerListNotifierProvider.notifier);
        hangerListNotifier.reset();

        _ref.read(routerProvider).pop();
        await hangerListNotifier.getHangerList();
        _ref.read(designListNotifierProvider.notifier).getStatsData();

        _ref.read(designNotifierProvider.notifier).getCollectionList();

        _ref.read(designListNotifierProvider.notifier).getCollectionList();
        _ref.read(designListNotifierProvider.notifier).removeSelectedHanger();
        clearData();
      });
    }
    return response;
  }

  Future<bool?> updateHanger({required int id}) async {
    bool? isUpdated;
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');
      final data = await _ref.read(hangerRepoProvider).updateHanger(
            hangerName: (state.data.selectedHanger.name == nameCtrl.text.trim())
                ? null
                : nameCtrl.text.trim(),
            buyerRefNo: buyerRefNoCtrl.text.trim(),
            composition: compositionCtrl.text.trim(),
            construction: constructionCtrl.text.trim(),
            count: countCtrl.text.trim(),
            hangerCode: (state.data.selectedHanger.code == codeCtrl.text.trim())
                ? null
                : codeCtrl.text.trim(),
            hangerId: id,
            millRefNo: millRefNoCtrl.text.trim(),
            weight: weightCtrl.text.trim(),
            width: widthCtrl.text.trim(),
            selectedImageLIst: state.data.selectedImageList
                .where((element) => element.id == -1)
                .map((e) => e.url)
                .toList(),
            collectionId: state.data.selectedCollection?.id,
          );

      await data.fold((l) {
        isUpdated = false;
        state = state.copyWith(loading: false, error: l.message);
      }, (r) async {
        isUpdated = true;
        final notifier = _ref.read(hangerListNotifierProvider.notifier);
        notifier.reset();
        clearData();

        notifier.getHangerList();

        _ref.read(designNotifierProvider.notifier).getCollectionList();

        _ref.read(designListNotifierProvider.notifier).getCollectionList();
        _ref.read(designListNotifierProvider.notifier).removeSelectedHanger();
      });
    }
    return isUpdated;
  }

  Future<bool> removeHangerImage({
    required int documentId,
    required int modelId,
  }) async {
    bool isRemoved = false;
    state = state.copyWith(loading: true, error: '');
    final data = await _ref.read(hangerRepoProvider).removeHangerImage(
          hangerId: modelId,
          documentId: documentId,
        );
    await data.fold((l) {
      state = state.copyWith(loading: false, error: l.message);
    }, (r) async {
      isRemoved = true;
      state = state.copyWith(loading: false, error: '');
      final notifier = _ref.read(hangerListNotifierProvider.notifier);
      notifier.reset();
      clearData();

      notifier.getHangerList();
    });
    return isRemoved;
  }

  Future<HangerItem?> setHanger({
    required int hangerId,
    bool fillData = false,
  }) async {
    HangerItem? response;
    state = state.copyWith(loading: true, error: '');
    final data =
        await _ref.read(hangerRepoProvider).getHangerById(hangerId: hangerId);
    await data.fold((l) {
      state = state.copyWith(error: l.message, loading: false);
    }, (r) async {
      response = r;
      if (fillData) {
        nameCtrl.text = r.name;
        millRefNoCtrl.text = r.millRefNo;
        buyerRefNoCtrl.text = r.buyerRefNo;
        compositionCtrl.text = r.composition;
        countCtrl.text = r.count;
        widthCtrl.text = r.width == 0 ? '' : r.width.toString();
        weightCtrl.text = r.gsm == 0 ? '' : r.gsm.toString();
        constructionCtrl.text = r.construction;
        codeCtrl.text = r.code;
      }
      if (r.collection != null) {
        await getCollectionList();
      }
      state = state.copyWith(
        loading: false,
        error: '',
        data: state.data.copyWith(
          selectedHanger: r,
          selectedCollection: (r.collection != null && r.collection?.id != -1)
              ? fillData
                  ? CollectionDropdownModel(
                      id: r.collection?.id ?? -1,
                      name: r.collection?.name ?? '',
                    )
                  : null
              : null,
        ),
      );
    });
    return response;
  }

  Future<String?> deleteHanger({required int hangerId}) async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final data =
        await _ref.read(hangerRepoProvider).deleteHanger(hangerId: hangerId);
    data.fold((l) {
      response = l.message;
      state = state.copyWith(loading: false, error: l.message);
    }, (r) {
      state = state.copyWith(loading: false, error: '');
      final notifier = _ref.read(hangerListNotifierProvider.notifier);
      notifier.reset();
      notifier.getHangerList();
      _ref.read(designListNotifierProvider.notifier).getStatsData();

      _ref.read(designNotifierProvider.notifier).removeSelectedHanger();

      _ref.read(designListNotifierProvider.notifier).removeSelectedHanger();
    });
    return response;
  }
}
