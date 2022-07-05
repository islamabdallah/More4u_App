import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';

import '../../../domain/entities/benefit_request.dart';
import '../../../domain/entities/filtered_search.dart';
import '../../../domain/usecases/get_benefits_to_manage.dart';

part 'manage_requests_state.dart';

class ManageRequestsCubit extends Cubit<ManageRequestsState> {
  GetBenefitsToManageUsecase getBenefitsToManageUsecase;

  ManageRequestsCubit({required this.getBenefitsToManageUsecase})
      : super(ManageRequestsInitial());

  List<BenefitRequest> benefitRequests = [];

  getBenefitsToManage({FilteredSearch? search}) async {
    emit(GetRequestsToManageLoadingState());

    final result = await getBenefitsToManageUsecase(
        employeeNumber: userData!.employeeNumber, search: search);

    result.fold((failure) {
      emit(GetRequestsToManageFailedState(failure.message));
    }, (benefitRequests) {
      this.benefitRequests = benefitRequests;
      emit(GetRequestsToManageSuccessState());
    });
  }

  //Search and Filtration

  TextEditingController employeeNumberSearch = TextEditingController();
  TextEditingController fromText = TextEditingController()..addListener(() { });
  TextEditingController toText = TextEditingController();
  int statusCurrentIndex = -1;
  int typeCurrentIndex = -1;

  DateTime? fromDate;
  DateTime? toDate;

  selectStatus(int index) {
    statusCurrentIndex = index;
    emit(ChangeFiltration());
  }

  selectType(int index) {
    typeCurrentIndex = index;
    emit(ChangeFiltration());
  }

  changeFromDate(DateTime? date) {
    fromDate = date;

    if (fromDate == null) {
      fromDate = null;
      toDate = null;
      fromText.clear();
      toText.clear();
    } else{
      if(toDate==null){}
      if(toDate==null||toDate?.compareTo(fromDate!) == -1){
        toDate = fromDate;
        toText.text=fromText.text;
      }
    }
    emit(ChangeFiltration());
  }

  changeToDate(DateTime? date) {
    toDate = date;
    emit(ChangeFiltration());
  }

  search() {
    var search = FilteredSearch(
        selectedRequestStatus: statusCurrentIndex,
        selectedBenefitType: typeCurrentIndex,
        employeeNumberSearch: int.parse(employeeNumberSearch.text.isEmpty
            ? '0'
            : employeeNumberSearch.text),
        selectedDepartmentId: -1,
        selectedTimingId: -1);
    getBenefitsToManage(search: search);
  }
}
