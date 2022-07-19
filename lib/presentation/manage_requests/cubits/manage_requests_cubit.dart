import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/manage_requests_response.dart';
import 'package:more4u/domain/entities/profile_and_documents.dart';

import '../../../domain/entities/benefit_request.dart';
import '../../../domain/entities/filtered_search.dart';
import '../../../domain/usecases/add_response.dart';
import '../../../domain/usecases/get_benefits_to_manage.dart';
import '../../../domain/usecases/get_request_Profile_and_documents.dart';

part 'manage_requests_state.dart';

class ManageRequestsCubit extends Cubit<ManageRequestsState> {
  GetBenefitsToManageUsecase getBenefitsToManageUsecase;
  AddRequestResponseUsecase addRequestResponseUsecase;
  GetRequestProfileAndDocumentsUsecase getRequestProfileAndDocumentsUsecase;

  ManageRequestsCubit(
      {required this.getBenefitsToManageUsecase,
      required this.addRequestResponseUsecase,
      required this.getRequestProfileAndDocumentsUsecase,
      })
      : super(ManageRequestsInitial());

  List<BenefitRequest> benefitRequests = [];
  List<Department>? departments;
  bool isBottomSheetOpened = false;

  getBenefitsToManage({FilteredSearch? search,int? requestNumber=-1}) async {
    emit(GetRequestsToManageLoadingState());
    final result = await getBenefitsToManageUsecase(
        employeeNumber: userData!.employeeNumber, search: search,requestNumber: requestNumber);

    result.fold((failure) {
      emit(GetRequestsToManageErrorState(failure.message));
    }, (manageRequestsResponse) {
      benefitRequests = manageRequestsResponse.requests??[];
      departments = manageRequestsResponse.departments;
      print(departments);
      emit(GetRequestsToManageSuccessState());
    });
  }

  ProfileAndDocuments? profileAndDocuments;
  getRequestProfileAndDocuments(int requestNumber) async {
    profileAndDocuments=null;
    emit(GetRequestProfileAndDocumentsLoadingState());
    final result = await getRequestProfileAndDocumentsUsecase(
        employeeNumber: userData!.employeeNumber, requestNumber: requestNumber);

    result.fold((failure) {
      emit(GetRequestProfileAndDocumentsErrorState(failure.message));
    }, (profileAndDocuments) {
      this.profileAndDocuments = profileAndDocuments;
      emit(GetRequestProfileAndDocumentsSuccessState());

      print(profileAndDocuments.profilePicture?.length);
    });
  }

  removeRequest(int requestNumber) {
    benefitRequests
        .removeWhere((element) => element.requestNumber == requestNumber);
    emit(RemoveRequestSuccessState());
  }

  Future<bool?> acceptOrRejectRequest(
      int requestNumber, int status, String message) async {
    emit(AddRequestResponseLoadingState());
    final result = await addRequestResponseUsecase(
        employeeNumber: userData!.employeeNumber,
        status: status,
        requestNumber: requestNumber,
        message: message);

    bool? isSuccess;
    result.fold((failure) {
      isSuccess = false;
      emit(AddRequestResponseErrorState(failure.message));
    }, (message) {
      isSuccess = true;
      emit(AddRequestResponseSuccessState(message));
      return true;
    });

    print(isSuccess);
    return isSuccess;
  }

  //Search and Filtration

  TextEditingController employeeNumberSearch = TextEditingController();
  TextEditingController fromText = TextEditingController()..addListener(() {});
  TextEditingController toText = TextEditingController();
  int actionCurrentIndex = -1;
  int typeCurrentIndex = -1;
  int departmentCurrentIndex = -1;
  Department? selectedDepartment = Department(name: 'Any', id: -1);
  bool hasWarning = false;

  DateTime? fromDate;
  DateTime? toDate;

  selectAction(int index) {
    actionCurrentIndex = index;
    emit(ChangeFiltration());
  }

  selectType(int index) {
    typeCurrentIndex = index;
    emit(ChangeFiltration());
  }
  selectDepartment(Department department) {
    selectedDepartment=department;
    departmentCurrentIndex = department.id!;
    emit(ChangeFiltration());
  }

  changeFromDate(DateTime? date) {
    fromDate = date;

    if (fromDate == null) {
      fromDate = null;
      toDate = null;
      fromText.clear();
      toText.clear();
    } else {
      if (toDate == null) {}
      if (toDate == null || toDate?.compareTo(fromDate!) == -1) {
        toDate = fromDate;
        toText.text = fromText.text;
      }
    }
    emit(ChangeFiltration());
  }

  changeContainWarning(bool value) {
    hasWarning = value;
    emit(ChangeFiltration());
  }

  changeToDate(DateTime? date) {
    toDate = date;
    emit(ChangeFiltration());
  }

  search() {
    var search = FilteredSearch(
        selectedRequestStatus: actionCurrentIndex,
        selectedBenefitType: typeCurrentIndex,
        employeeNumberSearch: int.parse(employeeNumberSearch.text.isEmpty
            ? '-1'
            : employeeNumberSearch.text),
        selectedDepartmentId: departmentCurrentIndex,
        selectedTimingId: -1,
        hasWarningMessage: hasWarning,
        searchDateFrom: fromText.text.isEmpty ? "0001-01-01" : fromText.text,
        searchDateTo: toText.text.isEmpty ? "0001-01-01" : toText.text);
    getBenefitsToManage(search: search);
  }
}
