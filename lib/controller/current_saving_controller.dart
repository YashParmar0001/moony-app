import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:moony_app/model/category_icon.dart';
import 'package:moony_app/model/saving.dart';
import 'package:moony_app/service/sqlite_service.dart';

class CurrentSavingController extends GetxController {
  final _title = ''.obs;
  final _amount = 0.obs;
  final _dueDate = Rx<DateTime?>(null);
  final _icon = Rx<CategoryIcon?>(null);

  final _titleError = Rx<String?>(null);
  final _amountError = Rx<String?>(null);

  String? get titleError => _titleError.value;

  String? get amountError => _amountError.value;

  String get title => _title.value;

  int get amount => _amount.value;

  DateTime? get dueDate => _dueDate.value;

  CategoryIcon? get icon => _icon.value;

  set title(String value) {
    _title.value = value;
  }

  set amount(int value) {
    _amount.value = value;
  }

  set dueDate(DateTime? value) {
    _dueDate.value = value;
  }

  set icon(CategoryIcon? value) {
    _icon.value = value;
  }

  Future<String?> addSaving() async {
    if (!validateTitle()) return 'Please fill all the details first';
    if (!validateAmount()) return 'Please fill all the details first';
    if (dueDate == null) return 'Please select date first';
    if (icon == null) return 'Please select icon first';

    final saving = Saving(
      id: 0,
      desiredAmount: amount,
      title: title,
      date: dueDate!,
      icon: icon!,
      history: [],
    );
    dev.log('Adding saving: $saving', name: 'Saving');
    final service = Get.find<SqliteService>();

    try {
      final response = await service.addSaving(saving);
      if (response == 0) {
        return 'Something went wrong!';
      } else {
        // reset();
        return null;
      }
    } catch (_) {
      return 'Something went wrong!';
    }
  }

  bool validateTitle() {
    if (title.isEmpty) {
      _titleError.value = 'Title cannot be empty!';
      return false;
    } else {
      _titleError.value = null;
      return true;
    }
  }

  bool validateAmount() {
    if (amount == 0) {
      _amountError.value = 'Amount cannot be empty or 0!';
      return false;
    } else {
      _amountError.value = null;
      return true;
    }
  }

  bool validate() {
    if (!validateTitle()) return false;
    if (!validateAmount()) return false;

    return true;
  }
}
