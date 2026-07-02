import 'package:autune/pages/cadastro_page.dart';
import 'package:autune/pages/login_page.dart';
import 'package:autune/pages/splash_page.dart';
import 'package:autune/providers/afinador_provider.dart';
import 'package:autune/routes/app_routes.dart';
import 'package:autune/view/app_frame.dart';
import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider disponibiliza o AfinadorProvider para toda a
    // árvore de widgets abaixo dele. Qualquer tela pode ler ou ouvir mudanças
    // sem precisar receber os dados via parâmetros de construtor.
    return ChangeNotifierProvider(
      create: (_) => AfinadorProvider(),
      child: MaterialApp(
        title: 'Autune',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashPage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.cadastro: (context) => const CadastroPage(),
          AppRoutes.home: (context) => const AppFrame(),
        },
      ),
    );
  }
}
