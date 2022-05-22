import 'package:more4u/data/datasources/login_remote_data_source.dart';
import 'package:more4u/data/repositories/login_repository_impl.dart';
import 'package:more4u/presentation/Login/cubits/login_cubit.dart';

import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/repositories/login_repository.dart';
import 'domain/usecases/login_user.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Cubits
  sl.registerFactory(() => LoginCubit(loginUser: sl()));

// Usecases

  sl.registerLazySingleton(() => LoginUserUsecase(sl()));

// Repository

  sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

// Datasources

  //todo uncomment this when api is published
  // sl.registerLazySingleton<LoginRemoteDataSource>(
  //     () => LoginRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => FakeLoginRemoteDataSourceImpl());

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
