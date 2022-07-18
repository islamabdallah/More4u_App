import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/usecases/get_my_benefits.dart';

import '../../../domain/entities/gift.dart';
import '../../../domain/usecases/get_my_gifts.dart';

part 'my_gifts_state.dart';

class MyGiftsCubit extends Cubit<MyGiftsState> {
  static MyGiftsCubit get(context) => BlocProvider.of(context);
  final GetMyGiftsUsecase getMyGiftsUsecase;

  MyGiftsCubit({
    required this.getMyGiftsUsecase,
  }) : super(MyGiftsInitial());

  List<Gift> myGifts = [];

  getMyGifts({required int requestNumber}) async {
    emit(GetMyGiftsLoadingState());
    final result =
        await getMyGiftsUsecase(employeeNumber: userData!.employeeNumber,requestNumber: requestNumber);

    result.fold((failure) {
      emit(GetMyGiftsErrorState(failure.message));
    }, (myGifts) {
      this.myGifts = myGifts;
      emit(GetMyGiftsSuccessState());
    });
  }
}
