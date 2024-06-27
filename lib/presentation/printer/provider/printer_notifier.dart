import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/repository/design_repo_impl.dart';
import '../../../data/repository/hanger_repo_impl.dart';
import '../../../data/repository/printer_repo_impl.dart';
import '../../../data/source/local/shar_pref.dart';
import '../../../domain/model/design_model.dart';
import '../../../domain/model/hanger_model.dart';
import '../../../domain/model/load_error_state.dart';
import '../../../domain/model/print_model.dart';
import '../../design/providers/design_list_notifier.dart';
import '../../hanger/provider/hanger_list_notifier.dart';
import '../../profile/providers/user_notifier.dart';
import '../../shared/providers/app_content.dart';

final printerNotifierProvider =
    StateNotifierProvider<PrinterNotifier, LoadErrorState<PrintModel>>((ref) {
  return PrinterNotifier(ref);
});

class PrinterNotifier extends StateNotifier<LoadErrorState<PrintModel>> {
  PrinterNotifier(this._ref)
      : super(LoadErrorState(data: const PrintModel(), loading: false));

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

  final nameCtrl = TextEditingController();
  final ipCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCtrl.dispose();
    ipCtrl.dispose();

    super.dispose();
  }

  Future<int?> sendPrintRequest() async {
    state = state.copyWith(
      loading: true,
      error: '',
      data: state.data.copyWith(currentItemSent: 0),
    );
    final zplCommandTemplate =
        _ref.read(appContentProvider.select((value) => value));

    if (state.data.hangerList.isNotEmpty) {
      final hangerTemplate = zplCommandTemplate.hangerLabelTemplate;

      for (HangerItem hangerItem in state.data.hangerList) {
        bool getByIdRes = true;

        final hangerData = await _ref
            .read(hangerRepoProvider)
            .getHangerById(hangerId: hangerItem.id);
        hangerData.fold((l) {
          getByIdRes = false;
          state = state.copyWith(loading: false, error: l.message);
        }, (r) {
          hangerItem = r;
        });

        if (getByIdRes == false) {
          break;
        }

        final zplCommand =
            hangerTemplate.replaceAllMapped(RegExp(r'{_(.*?)_}'), (match) {
          final key = match.group(1);
          switch (key) {
            case 'id':
              return hangerItem.id.toString();
            case 'h_name':
              return hangerItem.name;
            case 'h_code':
              return hangerItem.code;
            case 'c_name':
              return hangerItem.collection?.name ?? '';
            case 'mill_no':
              return hangerItem.millRefNo;
            case 'buy_ref':
              return hangerItem.buyerRefNo;
            case 'comp':
              return hangerItem.composition;
            case 'weight':
              return hangerItem.gsm.toString();
            case 'count':
              return hangerItem.count;
            case 'cons':
              return hangerItem.construction;
            case 'width':
              return hangerItem.width.toString();
            default:
              return '';
          }
        });

        bool response = true;
        final data = await _ref
            .read(
              printerRepoProvider(
                'http://${ipCtrl.text.trim()}:8181',
              ),
            )
            .printLabel(
              printerName: nameCtrl.text.trim(),
              zplCommand: zplCommand.replaceAll(r'\', ''),
            );

        await data.fold((l) {
          response = false;
          state = state.copyWith(loading: false, error: l.message);
        }, (r) async {
          state = state.copyWith(
            data: state.data
                .copyWith(currentItemSent: state.data.currentItemSent + 1),
          );

          _ref
              .read(sharedPrefProvider)
              .savePrinterIP(ipAddress: ipCtrl.text.trim());

          _ref
              .read(sharedPrefProvider)
              .savePrinterName(printerName: nameCtrl.text.trim());

          await Future.delayed(const Duration(milliseconds: 200));
        });

        if (response == false) {
          break;
        }
      }
    } else {
      final designTemplate = zplCommandTemplate.designLabelTemplate;
      for (DesignItem designItem in state.data.designList) {
        bool getByIdRes = true;

        final designData = await _ref
            .read(designRepoProvider)
            .getDesignById(designId: designItem.id);
        designData.fold((l) {
          getByIdRes = false;
          state = state.copyWith(loading: false, error: l.message);
        }, (r) {
          designItem = r;
        });

        if (getByIdRes == false) {
          break;
        }

        final zplCommand =
            designTemplate.replaceAllMapped(RegExp(r'{_(.*?)_}'), (match) {
          final key = match.group(1);
          switch (key) {
            case 'id':
              return designItem.id.toString();
            case 'd_name':
              return designItem.name;
            case 'h_name':
              return designItem.hanger?.name ?? '';
            case 'mill_no':
              return designItem.millRefNo;
            case 'buy_ref':
              return designItem.buyerRefNo;
            case 'comp':
              return designItem.composition;
            case 'weight':
              return designItem.gsm.toString();
            case 'count':
              return designItem.count;
            case 'cons':
              return designItem.construction;
            case 'width':
              return designItem.width.toString();
            default:
              return '';
          }
        });

        bool response = true;
        final data = await _ref
            .read(
              printerRepoProvider(
                'http://${ipCtrl.text.trim()}:8181',
              ),
            )
            .printLabel(
              printerName: nameCtrl.text.trim(),
              zplCommand: zplCommand.replaceAll(r'\', ''),
            );

        await data.fold((l) {
          response = false;
          state = state.copyWith(loading: false, error: l.message);
        }, (r) async {
          state = state.copyWith(
            data: state.data
                .copyWith(currentItemSent: state.data.currentItemSent + 1),
          );
          _ref
              .read(sharedPrefProvider)
              .savePrinterIP(ipAddress: ipCtrl.text.trim());

          _ref
              .read(sharedPrefProvider)
              .savePrinterName(printerName: nameCtrl.text.trim());

          await Future.delayed(const Duration(milliseconds: 200));
        });

        if (response == false) {
          break;
        }
      }
    }
    state = state.copyWith(loading: false);
    return state.data.currentItemSent;
  }

  Future<void> loadPreviousPrinterIP() async {
    final prevPrinterIP = await _ref.read(sharedPrefProvider).getPrinterIP();
    final prevPrinterName =
        await _ref.read(sharedPrefProvider).getPrinterName();

    if (prevPrinterIP != null) {
      ipCtrl.text = prevPrinterIP;
    }

    if (prevPrinterName != null) {
      nameCtrl.text = prevPrinterName;
    }
  }

  void clearData() {
    state = state.copyWith(
      data: const PrintModel(),
      error: '',
      loading: false,
    );
    ipCtrl.clear();
    nameCtrl.clear();
  }

  Future<void> getHangers({int? id}) async {
    // If Id is null then get all the list
    if (id == null) {
      state = state.copyWith(
        data: state.data.copyWith(itemLoader: true),
        error: '',
      );

      final hangerListState = _ref.read(hangerListNotifierProvider);
      final notifier = _ref.read(hangerListNotifierProvider.notifier);
      final isStaff =
          _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
              EntityType.staffRole;

      final data = await _ref.read(hangerRepoProvider).getHangerList(
            pageNumber: 1,
            pageSize: 9999999,
            isStaff: isStaff,
            searchString: notifier.searchCtrl.text.trim(),
            buyRefNo: notifier.buyerRefNoCtrl.text,
            collectionId: hangerListState.data.selectedCollection?.id,
            composition: notifier.compositionCtrl.text,
            construction: notifier.constructionCtrl.text,
            count: notifier.countCtrl.text,
            gsm: notifier.weightCtrl.text,
            millRefNo: notifier.millRefNoCtrl.text,
            width: notifier.widthCtrl.text,
          );

      data.fold((l) {
        state = state.copyWith(
          data: state.data.copyWith(itemLoader: false),
          error: l.message,
        );
      }, (r) {
        state = state.copyWith(
          data: state.data.copyWith(
            hangerList: r,
            totalItems: r.length,
            moduleType: 'Hanger',
            itemLoader: false,
          ),
          error: '',
        );
      });
    }
    // Else call the hanger by id
    else {
      state = state.copyWith(
        data: state.data.copyWith(itemLoader: true),
        error: '',
      );

      final data =
          await _ref.read(hangerRepoProvider).getHangerById(hangerId: id);
      data.fold((l) {
        state = state.copyWith(
          data: state.data.copyWith(itemLoader: false),
          error: l.message,
        );
      }, (r) {
        state = state.copyWith(
          data: state.data.copyWith(
            hangerList: [r],
            totalItems: 1,
            moduleType: 'Hanger',
            itemLoader: false,
          ),
          error: '',
        );
      });
    }
  }

  Future<void> getDesigns({int? id}) async {
    // If Id is null then get all the list
    if (id == null) {
      state = state.copyWith(
        data: state.data.copyWith(itemLoader: true),
        error: '',
      );

      final designListState = _ref.read(designListNotifierProvider);
      final notifier = _ref.read(designListNotifierProvider.notifier);
      final isStaff =
          _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
              EntityType.staffRole;
      final data = await _ref.read(designRepoProvider).getDesignList(
            pageNumber: 1,
            pageSize: 9999999,
            isStaff: isStaff,
            searchString: notifier.searchCtrl.text.trim(),
            buyRefNo: notifier.buyerRefNoCtrl.text,
            hangerId: designListState.data.selectedHanger?.id,
            composition: notifier.compositionCtrl.text,
            construction: notifier.constructionCtrl.text,
            count: notifier.countCtrl.text,
            gsm: notifier.weightCtrl.text,
            millRefNo: notifier.millRefNoCtrl.text,
            width: notifier.widthCtrl.text,
          );

      data.fold((l) {
        state = state.copyWith(
          data: state.data.copyWith(itemLoader: false),
          error: l.message,
        );
      }, (r) {
        state = state.copyWith(
          data: state.data.copyWith(
            designList: r,
            totalItems: r.length,
            moduleType: 'Design',
            itemLoader: false,
          ),
          error: '',
        );
      });
    }
    // Else call the sample by id
    else {
      state = state.copyWith(
        data: state.data.copyWith(itemLoader: false),
        error: '',
      );

      final data =
          await _ref.read(designRepoProvider).getDesignById(designId: id);
      data.fold((l) {
        state = state.copyWith(
          data: state.data.copyWith(itemLoader: false),
          error: l.message,
        );
      }, (r) {
        state = state.copyWith(
          data: state.data.copyWith(
            designList: [r],
            totalItems: 1,
            moduleType: 'Design',
            itemLoader: false,
          ),
          error: '',
        );
      });
    }
  }

  Future<void> getDesignByHangerId({required int hangerId}) async {
    state = state.copyWith(
      data: state.data.copyWith(itemLoader: true),
      error: '',
    );
    final isStaff =
        _ref.read(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;
    final data = await _ref.read(designRepoProvider).getDesignList(
          pageNumber: 1,
          pageSize: 9999999,
          isStaff: isStaff,
          hangerId: hangerId,
        );
    data.fold((l) {
      state = state.copyWith(
        data: state.data.copyWith(itemLoader: false),
        error: l.message,
      );
    }, (r) {
      state = state.copyWith(
        data: state.data.copyWith(
          designList: r,
          totalItems: r.length,
          moduleType: 'Design',
          itemLoader: false,
        ),
        error: '',
      );
    });
  }
}
