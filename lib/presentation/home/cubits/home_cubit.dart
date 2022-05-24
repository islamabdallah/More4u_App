import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/entities/benefit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(context) => BlocProvider.of(context);

  List<Benefit> benefitModels = [];
  List<Benefit>? availableBenefitModels = [];

  HomeCubit() : super(HomeInitial());
}
