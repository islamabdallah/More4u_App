import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/benefit_request.dart';
import '../../../domain/usecases/get_my_benefit_requests.dart';

part 'my_benefit_requests_state.dart';

class MyBenefitRequestsCubit extends Cubit<MyBenefitRequestsState> {
  final GetMyBenefitRequestsUsecase getMyBenefitRequestsUsecase;

  MyBenefitRequestsCubit({required this.getMyBenefitRequestsUsecase})
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
}
