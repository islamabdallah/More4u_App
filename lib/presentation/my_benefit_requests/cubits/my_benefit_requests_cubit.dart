import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/usecases/cancel_request.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/benefit_request.dart';
import '../../../domain/usecases/get_my_benefit_requests.dart';

part 'my_benefit_requests_state.dart';

class MyBenefitRequestsCubit extends Cubit<MyBenefitRequestsState> {
  final GetMyBenefitRequestsUsecase getMyBenefitRequestsUsecase;
  final CancelRequestsUsecase cancelRequestsUsecase;

  MyBenefitRequestsCubit(
      {required this.getMyBenefitRequestsUsecase,
      required this.cancelRequestsUsecase})
      : super(MyBenefitRequestsInitial());

  List<BenefitRequest> myBenefitRequests = [];

  getMyBenefitRequests(int benefitId) async {
    emit(MyBenefitRequestsLoadingState());
    final result = await getMyBenefitRequestsUsecase(
        employeeNumber: userData!.employeeNumber, benefitId: benefitId);

    result.fold((failure) {
      emit(MyBenefitRequestsErrorState(failure.message));
    }, (myBenefitRequests) {
      this.myBenefitRequests = myBenefitRequests;
      emit(MyBenefitRequestsSuccessState());
    });
  }

  cancelRequest(int benefitId, int requestNumber) async {
    emit(CancelRequestLoadingState());
    final result = await cancelRequestsUsecase(
        employeeNumber: userData!.employeeNumber,
        benefitId: benefitId,
        requestNumber: requestNumber);

    result.fold((failure) {
      emit(CancelRequestErrorState(failure.message));
    }, (message) {
      emit(CancelRequestSuccessState(message));
    });
  }

  var myChildSize = Size.zero;

  setChildSized(Size size) {
    myChildSize = size;
    Future.delayed(Duration.zero, () => emit(ChangeSizeState()));
  }
}
