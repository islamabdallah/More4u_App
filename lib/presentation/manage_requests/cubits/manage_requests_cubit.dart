import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';

import '../../../domain/entities/benefit_request.dart';
import '../../../domain/usecases/get_benefits_to_manage.dart';

part 'manage_requests_state.dart';

class ManageRequestsCubit extends Cubit<ManageRequestsState> {
  GetBenefitsToManageUsecase getBenefitsToManageUsecase;

  ManageRequestsCubit({required this.getBenefitsToManageUsecase})
      : super(ManageRequestsInitial());

  List<BenefitRequest> benefitRequests = [];

  getBenefitsToManage() async {
    emit(GetRequestsToManageLoadingState());

    final result = await getBenefitsToManageUsecase(employeeNumber: userData!.employeeNumber);

    result.fold((failure) {
      emit(GetRequestsToManageFailedState(failure.message));
    }, (benefitRequests) {
      this.benefitRequests = benefitRequests;
      emit(GetRequestsToManageSuccessState());
    });
  }

  //filtration
  int statusCurrentIndex = -1;
  int typeCurrentIndex = -1;

  selectStatus(int index){
    statusCurrentIndex = index;
    emit(ChangeFiltration());
  }

  selectType(int index){
    typeCurrentIndex = index;
    emit(ChangeFiltration());
  }

}
