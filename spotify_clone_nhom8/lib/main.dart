import 'dart:io'; // Thêm import để ghi đè HttpOverrides
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Để sử dụng dotenv
import 'package:spotify_clone_nhom8/bloc/theme_cubit.dart';
import 'package:spotify_clone_nhom8/core/configs/theme/app_theme.dart';
import 'package:spotify_clone_nhom8/screens/splash_screen.dart'; // Màn hình Splash
import 'package:spotify_clone_nhom8/auth/signin.dart'; // Màn hình đăng nhập
import 'package:spotify_clone_nhom8/screens/main_screen.dart'; // Màn hình chính

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tải file .env
  await dotenv.load(fileName: ".env");

  // Khởi tạo HydratedBloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // Ghi đè HttpOverrides để bỏ qua lỗi SSL (nếu cần)
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

// Ghi đè HttpOverrides để bỏ qua lỗi chứng chỉ SSL
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/signin': (context) => const SigninPage(),
            '/main': (context) => const MainScreen(),
          },
        ),
      ),
    );
  }
}
