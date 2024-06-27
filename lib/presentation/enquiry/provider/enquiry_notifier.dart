import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/model/enquiry_item_body_model.dart';
import '../../../data/repository/design_repo_impl.dart';
import '../../../data/repository/enquiry_repo_impl.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../domain/model/design_model.dart';
import '../../../domain/model/enquiry_model.dart';
import '../../../domain/model/hanger_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../../domain/model/predefined.dart';
import '../../design/providers/design_list_notifier.dart';
import '../../routes/app_router.dart';
import '../../shared/providers/last_file_save_provider.dart';
import '../../shared/providers/router.dart';
import 'enquiry_list_notifier.dart';

final enquiryNotifierProvider =
    StateNotifierProvider<EnquiryNotifier, PaginationState<EnquiryModel>>(
        (ref) {
  return EnquiryNotifier(ref);
});

class EnquiryNotifier extends StateNotifier<PaginationState<EnquiryModel>> {
  EnquiryNotifier(this._ref)
      : super(PaginationState(data: const EnquiryModel(), loading: false)) {
    init();
  }

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final nameCtrl = TextEditingController();
  final addId = TextEditingController();
  final phoneCtrl = TextEditingController();

  final locationCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final descCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final manualAddKey = GlobalKey<FormState>();

  void init() {
    getStatusList();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    locationCtrl.dispose();
    emailCtrl.dispose();
    descCtrl.dispose();
    addId.dispose();

    debounce.dispose();
    super.dispose();
  }

  Future<void> getStatusList() async {
    final data = await _ref
        .read(enquiryRepoProvider)
        .getPredefinedList(entityType: EntityType.enquiryStatus);
    data.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(statusList: r));
    });
  }

  void updateSelectedStatus({Predefined? status}) {
    if (status != null)
      state = state.copyWith(
        data: state.data.copyWith(selectedStatus: status),
      );
  }

  void updateSelectedEnquiryItemStatus({Predefined? status}) {
    if (status != null)
      state = state.copyWith(
        data: state.data.copyWith(enquiryItemSelectedStatus: status),
      );
  }

  Future<void> addEnquiryItem({
    HangerItem? hangerItem,
    DesignItem? designItem,
  }) async {
    EnquiryItem enquiryItem = EnquiryItem(
      uniqueId: hangerItem != null
          ? (EntityType.hangerModule + hangerItem.id.toString())
          : (EntityType.designModule + (designItem?.id).toString()),
      hanger: hangerItem,
      design: designItem,
      status: state.data.statusList
          .firstWhere((element) => element.code == 'PENDING'),
    );
    if (state.data.enquiryItem.enquiryId != -1) {
      state = state.copyWith(loading: true, error: '');
      final enquiryItemModel = EnquiryBodyModel(
        id: hangerItem != null ? hangerItem.id : (designItem?.id ?? 0),
        statusId: enquiryItem.status?.predefinedId ?? 0,
      );
      final res = await _ref.read(enquiryRepoProvider).createEnquiryItem(
            enquiryId: state.data.enquiryItem.enquiryId,
            hangerList: hangerItem != null ? [enquiryItemModel] : [],
            designList: designItem != null ? [enquiryItemModel] : [],
          );

      res.fold((l) => state = state.copyWith(loading: false, error: l.message),
          (r) {
        enquiryItem = enquiryItem.copyWith(
          isLocallyAdded: false,
          enquiryItemId: r.enquiryItemId.isEmpty ? -1 : r.enquiryItemId.first,
        );
        state = state.copyWith(loading: false, error: '');
      });
    }

    state = state.copyWith(
      data: state.data.copyWith(
        enquiryItemList: [...state.data.enquiryItemList, enquiryItem],
      ),
    );
  }

  Future<bool> addEnquiry() async {
    bool response = false;
    if (formKey.currentState?.validate() == true) {
      final List<EnquiryBodyModel> designIds = [];
      final List<EnquiryBodyModel> hangerIds = [];
      state = state.copyWith(loading: true, error: '');
      for (int i = 0; i < state.data.enquiryItemList.length; i++) {
        if (state.data.enquiryItemList[i].hanger != null) {
          hangerIds.add(
            EnquiryBodyModel(
              id: state.data.enquiryItemList[i].hanger!.id,
              statusId: state.data.enquiryItemList[i].status!.predefinedId,
            ),
          );
          continue;
        } else {
          designIds.add(
            EnquiryBodyModel(
              id: state.data.enquiryItemList[i].design!.id,
              statusId: state.data.enquiryItemList[i].status!.predefinedId,
            ),
          );
          continue;
        }
      }
      final data = await _ref.read(enquiryRepoProvider).addEnquiry(
            userName: nameCtrl.text,
            phone: phoneCtrl.text,
            location: locationCtrl.text,
            email: emailCtrl.text,
            description: descCtrl.text,
            statusId: state.data.selectedStatus?.predefinedId ?? 0,
            designIds: designIds,
            hangerIds: hangerIds,
          );

      data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) {
        response = true;
        state = state.copyWith(loading: false, error: '');
        final notifier = _ref.read(enquiryListNotifierProvider.notifier);

        notifier.reset();
        notifier.getEnquiryStats();
        notifier.getEnquiryList();
      });
    }

    return response;
  }

  Future<String?> deleteEnquiry({required int enquiryId}) async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final data = await _ref
        .read(enquiryRepoProvider)
        .deleteEnquiry(enquiryId: enquiryId);
    data.fold((l) {
      response = l.message;
      state = state.copyWith(loading: false, error: l.message);
    }, (r) {
      state = state.copyWith(loading: false, error: '');
      final notifier = _ref.read(enquiryListNotifierProvider.notifier);
      notifier.reset();
      notifier.getEnquiryList();
      notifier.getEnquiryStats();
      _ref.read(designListNotifierProvider.notifier).getStatsData();
    });
    return response;
  }

  Future<String?> onScan({required String moduleType, required int id}) async {
    String? response;
    if (checkUniqueIdExist(moduleType: moduleType, id: id)) {
      return '${moduleType == EntityType.hangerModule ? 'Hanger' : 'Design'} is already added in enquiry item';
    }
    if (moduleType == EntityType.hangerModule) {
      final hangerData =
          await _ref.read(hangerRepoProvider).getHangerById(hangerId: id);

      hangerData.fold((l) {
        response = l.message;
      }, (r) {
        addEnquiryItem(hangerItem: r);
      });
    } else {
      final designData =
          await _ref.read(designRepoProvider).getDesignById(designId: id);
      designData.fold((l) {
        response = l.message;
      }, (r) {
        addEnquiryItem(designItem: r);
      });
    }
    return response;
  }

  bool checkUniqueIdExist({required String moduleType, required int id}) {
    final uniqueIdList =
        state.data.enquiryItemList.map((e) => e.uniqueId).toList();
    if (uniqueIdList.contains(moduleType + id.toString())) {
      return true;
    }
    return false;
  }

  void setEnquiryItem({required EnquiryItem data}) {
    final status = state.data.statusList.firstWhere(
      (element) => element.predefinedId == data.statusId,
      orElse: () => const Predefined(),
    );
    nameCtrl.text = data.name;
    phoneCtrl.text = data.phone;
    locationCtrl.text = data.location;
    emailCtrl.text = data.email;
    descCtrl.text = data.description;
    state = state.copyWith(
      data: state.data.copyWith(
        enquiryItem: data,
        selectedStatus: status.predefinedId == -1 ? null : status,
      ),
    );
  }

  void clearData() {
    state = state.copyWith(
      data: state.data.copyWith(
        selectedStatus: null,
        enquiryItemList: [],
      ),
      loading: false,
      error: '',
    );
    nameCtrl.clear();
    phoneCtrl.clear();
    locationCtrl.clear();
    emailCtrl.clear();
    descCtrl.clear();
  }

  Future<void> getEnquiryItemList({required int enquiryId}) async {
    final data = await _ref
        .read(enquiryRepoProvider)
        .getEnquiryItemList(enquiryId: enquiryId);
    data.fold((l) => null, (r) {
      state = state.copyWith(
        data: state.data.copyWith(
          enquiryItemList: r
              .map(
                (e) => e.copyWith(
                  uniqueId: (e.hanger != null
                          ? EntityType.hangerModule
                          : EntityType.designModule) +
                      (e.hanger?.id ?? e.design?.id).toString(),
                  hanger: e.hanger?.id == -1 ? null : e.hanger,
                  design: e.design?.id == -1 ? null : e.design,
                  isLocallyAdded: false,
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Future<void> removeEnquiryItemId({required String uniqueId}) async {
    final List<EnquiryItem> listData = List.from(state.data.enquiryItemList);
    final element =
        listData.where((element) => element.uniqueId == uniqueId).first;
    listData.removeWhere((element) => element.uniqueId == uniqueId);
    if (!element.isLocallyAdded) {
      final serverItemsLen =
          listData.map((e) => e.isLocallyAdded == false).length;
      if (serverItemsLen == 0) {
        state = state.copyWith(
          loading: false,
          error: 'At least one enquiry should be available.',
        );
        return;
      }
      state = state.copyWith(loading: true, error: '');
      final data = await _ref
          .read(enquiryRepoProvider)
          .deleteEnquiryItem(enquiryItemId: element.enquiryItemId);
      data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) {
        state = state.copyWith(
          loading: false,
          error: '',
          data: state.data.copyWith(enquiryItemList: listData),
        );
      });
    } else {
      state = state.copyWith(
        data: state.data.copyWith(enquiryItemList: listData),
      );
    }
  }

  Future<void> editEnquiryItemStatus({
    required String uniqueId,
  }) async {
    final status = state.data.enquiryItemSelectedStatus ?? const Predefined();
    final List<EnquiryItem> listData = List.from(state.data.enquiryItemList);
    final index =
        listData.indexWhere((element) => element.uniqueId == uniqueId);
    final element = listData
        .where((element) => element.uniqueId == uniqueId)
        .first
        .copyWith(status: status);

    listData.replaceRange(index, index + 1, [element]);

    if (!element.isLocallyAdded) {
      state = state.copyWith(loading: true, error: '');
      final data = await _ref.read(enquiryRepoProvider).updateEnquiryItemStatus(
            enquiryItemId: element.enquiryItemId,
            statusId: status.predefinedId,
          );
      data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) {
        state = state.copyWith(
          loading: false,
          error: '',
          data: state.data.copyWith(enquiryItemList: listData),
        );
      });
    } else {
      state = state.copyWith(
        data: state.data.copyWith(enquiryItemList: listData),
      );
    }
  }

  Future<bool> updateEnquiry({required int id}) async {
    bool response = false;

    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');

      final data = await _ref.read(enquiryRepoProvider).updateEnquiry(
            statusId: (state.data.enquiryItem.statusId ==
                    state.data.selectedStatus?.predefinedId)
                ? null
                : state.data.selectedStatus?.predefinedId ?? 0,
            enquiryId: id,
            designList: [],
            hangerList: [],
            emailId: emailCtrl.text,
            description: descCtrl.text,
            phone: phoneCtrl.text,
            location: locationCtrl.text,
            userName: nameCtrl.text,
          );
      data.fold((l) {
        state = state.copyWith(loading: false, error: l.message);
      }, (r) {
        response = true;
        final notifier = _ref.read(enquiryListNotifierProvider.notifier);
        notifier.reset();
        notifier.getEnquiryStats();
        notifier.getEnquiryList();
        state = state.copyWith(loading: false, error: '');
      });
    }
    return response;
  }

  Future<String?> exportEnquiryPdf({required int enquiryId}) async {
    String? response;
    final data = await _ref
        .read(enquiryRepoProvider)
        .exportEnquiryPdf(enquiryId: enquiryId);

    await data.fold((l) {
      response = l.message;
    }, (r) async {
      final data =
          await AppUtils.attemptSaveFile('enquiry_$enquiryId.pdf', r, _ref);
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
