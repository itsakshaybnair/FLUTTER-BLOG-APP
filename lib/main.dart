import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_blog_app/core/theme/theme.dart';
import 'package:flutter_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_blog_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
        

        //  AuthBloc(
        //   userSignUp: UserSignUp(
        //     AuthRepositoryImpl(
        //       AuthRemoteDataSourceImpl(supabase.client),
        //     ),
        //   ),

        // )
      ),


       BlocProvider(
        create: (_) => serviceLocator<BlogBloc>(),)

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Blog',
      theme: AppTheme.darkThememode,
      home: SafeArea(
        child: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedin) {
            if (isLoggedin == true) {
              return const BlogPage();
            }
            return const LoginPage();
          },
        ),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
