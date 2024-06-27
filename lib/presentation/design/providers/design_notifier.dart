import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/model/collection_dropdown_model.dart';
import '../../../data/model/hanger_dropdown_model.dart';
import '../../../data/repository/design_repo_impl.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../domain/model/design_model.dart';
import '../../../domain/model/document_model.dart';
import '../../../domain/model/hanger_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../hanger/provider/hanger_notifier.dart';
import '../../profile/providers/user_notifier.dart';
import '../../shared/providers/router.dart';
import 'design_list_notifier.dart';

final designNotifierProvider =
    StateNotifierProvider<DesignNotifier, PaginationState<DesignModel>>((ref) {
  return DesignNotifier(ref);
});

class DesignNotifier extends StateNotifier<PaginationState<DesignModel>> {
  DesignNotifier(this._ref)
      : super(PaginationState(data: const DesignModel(), loading: false)) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final buyerRefNoCtrl = TextEditingController();
  final countCtrl = TextEditingController();

  final compositionCtrl = TextEditingController();
  final constructionCtrl = TextEditingController();
  final millRefNoCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final hangerSearchCtrl = TextEditingController();

  void init() {
    hangerSearchCtrl.addListener(onSearch);

    getCollectionList();
  }

  @override
  void dispose() {
    hangerSearchCtrl.dispose();

    buyerRefNoCtrl.dispose();
    countCtrl.dispose();
    compositionCtrl.dispose();
    constructionCtrl.dispose();
    millRefNoCtrl.dispose();
    widthCtrl.dispose();
    weightCtrl.dispose();

    super.dispose();
  }

  Future<void> getHangerList() async {
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
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
          selectedHanger: null,
        ),
      );
      buyerRefNoCtrl.clear();
      compositionCtrl.clear();
      countCtrl.clear();
      widthCtrl.clear();
      weightCtrl.clear();
      constructionCtrl.clear();
    });
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
          selectedHanger: null,
          hangerList: [],
        ),
      );
    });
  }

  Future<void> updateSelectedHanger({
    required HangerDropdownModel hangerItem,
  }) async {
    state = state.copyWith(
      data: state.data.copyWith(selectedHanger: hangerItem),
    );
    final data = await _ref
        .read(hangerRepoProvider)
        .getHangerById(hangerId: hangerItem.id);
    data.fold((l) => null, (r) {
      buyerRefNoCtrl.text = r.buyerRefNo;
      compositionCtrl.text = r.composition;
      countCtrl.text = r.count;
      widthCtrl.text = r.width.toString();
      weightCtrl.text = r.gsm.toString();
      constructionCtrl.text = r.construction;
    });
  }

  Future<void> updateSelectedCollection({
    required CollectionDropdownModel collectionItem,
  }) async {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedCollection: collectionItem,
        hangerList: [],
        selectedHanger: null,
      ),
    );
    hangerSearchCtrl.clear();
    await getHangerList();
  }

  void removeSelectedCollection() {
    state = state.copyWith(
      data: state.data.copyWith(selectedCollection: null),
    );
  }

  void removeSelectedHanger() {
    state = state.copyWith(
      data: state.data.copyWith(selectedHanger: null),
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
        selectedHanger: null,
        selectedImageListLength: 0,
        selectedCollection: null,
      ),
    );

    buyerRefNoCtrl.clear();
    countCtrl.clear();
    compositionCtrl.clear();
    constructionCtrl.clear();
    millRefNoCtrl.clear();
    widthCtrl.clear();
    weightCtrl.clear();
  }

  Future<bool> addDesign() async {
    bool isUpdated = false;

    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');
      final data = await _ref.read(designRepoProvider).addDesign(
            buyerRefNo: buyerRefNoCtrl.text,
            composition: compositionCtrl.text,
            construction: constructionCtrl.text,
            hangerId: state.data.selectedHanger?.id ?? 0,
            count: countCtrl.text,
            millRefNo: millRefNoCtrl.text,
            weight: weightCtrl.text.isEmpty ? null : int.parse(weightCtrl.text),
            width: widthCtrl.text.isEmpty ? null : int.parse(widthCtrl.text),
            selectedImageLIst:
                state.data.selectedImageList.map((e) => e.url).toList(),
          );
      await data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) async {
        isUpdated = true;
        final designListNotifier =
            _ref.read(designListNotifierProvider.notifier);
        designListNotifier.reset();

        _ref.read(routerProvider).pop();
        await designListNotifier.getDesignList();
        await designListNotifier.getStatsData();
        clearData();
      });
    }
    return isUpdated;
  }

  Future<bool?> updateDesign({required int id, int? hangerId}) async {
    bool? isUpdated;
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');
      final data = await _ref.read(designRepoProvider).updateDesign(
            buyerRefNo: buyerRefNoCtrl.text.trim(),
            composition: compositionCtrl.text.trim(),
            construction: constructionCtrl.text.trim(),
            count: countCtrl.text.trim(),
            designId: id,
            hangerId: state.data.selectedHanger?.id,
            millRefNo: millRefNoCtrl.text.trim(),
            weight: weightCtrl.text.trim(),
            width: widthCtrl.text.trim(),
            selectedImageLIst: state.data.selectedImageList
                .where((element) => element.id == -1)
                .map((e) => e.url)
                .toList(),
          );

      await data.fold((l) {
        isUpdated = false;
        state = state.copyWith(loading: false, error: l.message);
      }, (r) async {
        isUpdated = true;
        final notifier = _ref.read(designListNotifierProvider.notifier);
        notifier.reset();
        clearData();
        _ref.read(routerProvider).pop();
        await notifier.getDesignList();
        if (hangerId != null) {
          await _ref
              .read(hangerNotifierProvider.notifier)
              .setHanger(hangerId: hangerId);
        }
      });
    }
    return isUpdated;
  }

  Future<bool> removeDesignImage({
    required int documentId,
    required int modelId,
  }) async {
    bool isRemoved = false;
    state = state.copyWith(loading: true, error: '');
    final data = await _ref.read(designRepoProvider).removeDesignImage(
          designId: modelId,
          documentId: documentId,
        );
    await data.fold((l) {
      state = state.copyWith(loading: false, error: l.message);
    }, (r) async {
      isRemoved = true;
      state = state.copyWith(loading: false, error: '');
      _ref.read(designListNotifierProvider.notifier).reset();
      _ref.read(designListNotifierProvider.notifier).getDesignList();
    });
    return isRemoved;
  }

  Future<void> setDesign({
    required int designId,
    bool fillData = false,
  }) async {
    state = state.copyWith(loading: true, error: '');
    final data =
        await _ref.read(designRepoProvider).getDesignById(designId: designId);
    await data.fold((l) {
      state = state.copyWith(error: l.message, loading: false);
    }, (r) async {
      if (r.collectionId != -1) {
        await getCollectionList();
      }
      if (fillData) {
        millRefNoCtrl.text = r.millRefNo;
        buyerRefNoCtrl.text = r.buyerRefNo;
        compositionCtrl.text = r.composition;
        countCtrl.text = r.count;
        widthCtrl.text = r.width.toString();
        weightCtrl.text = r.gsm.toString();
        constructionCtrl.text = r.construction;
      }
      state = state.copyWith(
        loading: false,
        error: '',
        data: state.data.copyWith(
          selectedDesign: r,
          selectedCollection: r.collectionId != -1
              ? CollectionDropdownModel(
                  id: r.collectionId,
                  name: r.collectionName,
                )
              : null,
          selectedHanger: fillData
              ? HangerDropdownModel(id: r.hangerId, name: r.hanger?.name ?? '')
              : null,
        ),
      );
    });
  }

  Future<void> setDesignFromHangerData({required HangerItem hangerData}) async {
    if (hangerData.collection != null && hangerData.collection?.id != -1) {
      await updateSelectedCollection(
        collectionItem: CollectionDropdownModel(
          id: hangerData.collection?.id ?? -1,
          name: hangerData.collection?.name ?? '',
        ),
      );

      final selectedHanger = state.data.hangerList.firstWhere(
        (element) => element.id == hangerData.id,
        orElse: () => const HangerDropdownModel(),
      );
      if (selectedHanger.id != -1) {
        await updateSelectedHanger(hangerItem: selectedHanger);
      }
    }
  }

  Future<String?> deleteDesign({required int designId, int? hangerId}) async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final data =
        await _ref.read(designRepoProvider).deleteDesign(designId: designId);
    await data.fold((l) {
      response = l.message;
      state = state.copyWith(loading: false, error: l.message);
    }, (r) async {
      state = state.copyWith(loading: false, error: '');
      final notifier = _ref.read(designListNotifierProvider.notifier);
      notifier.reset();
      notifier.getDesignList();
      notifier.getStatsData();

      if (hangerId != null) {
        await _ref
            .read(hangerNotifierProvider.notifier)
            .setHanger(hangerId: hangerId);
      }
    });
    return response;
  }

  void onSearch() {
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
