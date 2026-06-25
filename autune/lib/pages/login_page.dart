import 'package:autune/pages/cadastro_page.dart';
import 'package:autune/view/app_frame.dart';
import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AppFrame()));
  }

  void _irParaCadastro() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CadastroPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5E6CE), Color(0xFFD4A57A)],
          ),
        ),
        child: Stack(
          children: [
            // Folhas decorativas no topo
            Positioned(
              top: -10,
              right: -20,
              child: Opacity(
                opacity: 0.35,
                child: SvgPicture.asset(
                  'assets/autune-logo.svg',
                  width: 140,
                  colorFilter: ColorFilter.mode(
                    AppColors.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: -40,
              child: Opacity(
                opacity: 0.18,
                child: SvgPicture.asset(
                  'assets/autune-logo.svg',
                  width: 110,
                  colorFilter: ColorFilter.mode(
                    AppColors.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            // Folhas decorativas na base
            Positioned(
              bottom: -20,
              left: -30,
              child: Opacity(
                opacity: 0.20,
                child: SvgPicture.asset(
                  'assets/autune-logo.svg',
                  width: 130,
                  colorFilter: ColorFilter.mode(
                    AppColors.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            // Conteúdo principal
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),

                    // Logo + nome
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/autune-logo.svg',
                            width: 36,
                            height: 36,
                            colorFilter: ColorFilter.mode(
                              AppColors.mainColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Autune',
                            style: TextStyle(
                              fontFamily: 'NotoSerif',
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 56),

                    // Título LOG IN
                    Text(
                      'LOG IN',
                      style: TextStyle(
                        fontFamily: 'AlanSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.oliveBrownColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Divider(color: AppColors.oliveBrownColor, thickness: 1),

                    const SizedBox(height: 24),

                    // Campo usuário
                    Text(
                      'USUÁRIO',
                      style: TextStyle(
                        fontFamily: 'AlanSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.oliveBrownColor,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _CampoTexto(
                      controller: _usuarioController,
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

                    // Campo senha
                    Text(
                      'SENHA',
                      style: TextStyle(
                        fontFamily: 'AlanSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.oliveBrownColor,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _CampoTexto(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.oliveBrownColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _senhaVisivel = !_senhaVisivel;
                          });
                        },
                      ),
                    ),

                    // Esqueci minha senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'ESQUECI MINHA SENHA',
                          style: TextStyle(
                            fontFamily: 'AlanSans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.oliveBrownColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Botão entrar
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _entrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(
                            fontFamily: 'AlanSans',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link para cadastro
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'NÃO TEM CADASTRO? ',
                            style: TextStyle(
                              fontFamily: 'AlanSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.oliveBrownColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: _irParaCadastro,
                            child: Text(
                              'CADASTRE-SE AGORA',
                              style: TextStyle(
                                fontFamily: 'AlanSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const _CampoTexto({
    required this.controller,
    required this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'AlanSans',
        fontSize: 15,
        color: Color(0xFF493D22),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
        ),
      ),
    );
  }
}
