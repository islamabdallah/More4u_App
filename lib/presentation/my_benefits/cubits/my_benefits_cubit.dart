import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:more4u/domain/usecases/get_my_benefits.dart';

part 'my_benefits_state.dart';

class MyBenefitsCubit extends Cubit<MyBenefitsState> {
  static MyBenefitsCubit get(context) => BlocProvider.of(context);
  final GetMyBenefitsUsecase getMyBenefitsUsecase;

  MyBenefitsCubit({required this.getMyBenefitsUsecase})
      : super(MyBenefitsInitial());

  List<Benefit> myAllBenefits = [];
  List<Benefit> myPendingBenefits = [];
  List<Benefit> myInProgressBenefits = [];

  getMyBenefits() async {
    emit(GetMyBenefitsLoadingState());
    // final result = await getMyBenefitsUsecase(employeeNumber: userData!.employeeNumber);
    final result = await getMyBenefitsUsecase(employeeNumber: 5);

    result.fold((failure) {
      emit(GetMyBenefitsErrorState(failure.message));
    }, (myBenefits) {
      myAllBenefits = myBenefits;
      for (Benefit benefit in myAllBenefits) {
        if (benefit.lastStatus == 'Pending') {
          myPendingBenefits.add(benefit);
        } else if (benefit.lastStatus == 'InProgress') {
          myInProgressBenefits.add(benefit);
        }
      }
      emit(GetMyBenefitsSuccessState());
    });
  }
}
