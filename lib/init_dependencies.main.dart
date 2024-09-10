part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  // Changing default directory of Hive
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );
}

void _initAuth() {
  serviceLocator
    // Data Source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(), // no need to do it
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use Cases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

// for Blogs
void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(serviceLocator()),
    )
    ..registerFactory(
      () => GetAllBlogs(serviceLocator()),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
