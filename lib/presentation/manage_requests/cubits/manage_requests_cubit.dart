import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'manage_requests_state.dart';

class ManageRequestsCubit extends Cubit<ManageRequestsState> {
  ManageRequestsCubit() : super(ManageRequestsInitial());
}
