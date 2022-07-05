import 'package:more4u/data/datasources/remote_data_source.dart';
import 'package:more4u/data/repositories/benefit_repository_impl.dart';
import 'package:more4u/data/repositories/login_repository_impl.dart';
import 'package:more4u/data/repositories/redeem_repository_impl.dart';
import 'package:more4u/domain/repositories/benefit_repository.dart';
import 'package:more4u/domain/usecases/get_participants.dart';
import 'package:more4u/presentation/Login/cubits/login_cubit.dart';
import 'package:more4u/presentation/benefit_details/cubits/benefit_details_cubit.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/manage_requests/cubits/manage_requests_cubit.dart';
import 'package:more4u/presentation/notification/cubits/notification_cubit.dart';

import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local_data_source.dart';
import 'domain/repositories/login_repository.dart';
import 'domain/repositories/redeem_repository.dart';
import 'domain/usecases/add_response.dart';
import 'domain/usecases/cancel_request.dart';
import 'domain/usecases/get_benefit_details.dart';
import 'domain/usecases/get_benefits_to_manage.dart';
import 'domain/usecases/get_my_benefit_requests.dart';
import 'domain/usecases/get_my_benefits.dart';
import 'domain/usecases/get_notifications.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/redeem_card.dart';
import 'presentation/benefit_redeem/cubits/redeem_cubit.dart';
import 'presentation/my_benefit_requests/cubits/my_benefit_requests_cubit.dart';
import 'presentation/my_benefits/cubits/my_benefits_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Cubits
  sl.registerFactory(() => LoginCubit(loginUser: sl()));
  sl.registerFactory(() => HomeCubit(loginUser: sl()));
  sl.registerFactory(() => BenefitDetailsCubit(getBenefitDetailsUsecase: sl()));
  sl.registerFactory(
      () => RedeemCubit(getParticipantsUsecase: sl(), redeemCardUsecase: sl()));
  sl.registerFactory(() => MyBenefitsCubit(getMyBenefitsUsecase: sl()));
  sl.registerFactory(() => MyBenefitRequestsCubit(
      getMyBenefitRequestsUsecase: sl(), cancelRequestsUsecase: sl()));
  sl.registerFactory(() => ManageRequestsCubit(
      getBenefitsToManageUsecase: sl(), addRequestResponseUsecase: sl()));
  sl.registerFactory(() => NotificationCubit(getNotificationsUsecase: sl()));
// Usecases

  sl.registerLazySingleton(() => LoginUserUsecase(sl()));
  sl.registerLazySingleton(() => GetBenefitDetailsUsecase(sl()));
  sl.registerLazySingleton(() => GetParticipantsUsecase(sl()));
  sl.registerLazySingleton(() => GetMyBenefitsUsecase(sl()));
  sl.registerLazySingleton(() => GetMyBenefitRequestsUsecase(sl()));
  sl.registerLazySingleton(() => CancelRequestsUsecase(sl()));
  sl.registerLazySingleton(() => AddRequestResponseUsecase(sl()));
  sl.registerLazySingleton(() => GetBenefitsToManageUsecase(sl()));
  sl.registerLazySingleton(() => RedeemCardUsecase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUsecase(sl()));

// Repository

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
      localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<BenefitRepository>(
      () => BenefitRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<RedeemRepository>(
      () => RedeemRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

// Datasources

  //todo uncomment this when api is published
  // sl.registerLazySingleton<LoginRemoteDataSource>(
  //     () => LoginRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: sl()));
  // sl.registerLazySingleton<RemoteDataSource>(() => FakeRemoteDataSourceImpl());

  sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(sharedPreferences: sl()));

  // sl.registerLazySingleton<BenefitRemoteDataSource>(
  //     () => FakeBenefitRemoteDataSourceImpl());
  //
  // sl.registerLazySingleton<RedeemRemoteDataSource>(
  //     () => FakeRedeemRemoteDataSourceImpl());
//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
