import 'package:autune/services/auth_service.dart';
import 'package:autune/view/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await AuthService.instance.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      usuario: _usuarioController.text,
      senha: _senhaController.text,
      confirmarSenha: _confirmarSenhaController.text,
    );

    if (!mounted) return;

    if (erro != null) {
      setState(() {
        _erro = erro;
        _carregando = false;
      });
      return;
    }


    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Cadastro realizado! Faça seu login.',
          style: TextStyle(fontFamily: 'AlanSans'),
        ),
        backgroundColor: AppColors.mainColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
            Positioned(
              top: -10,
              right: -20,
              child: Opacity(
                opacity: 0.35,
                child: SvgPicture.asset(
                  'assets/autune-logo.svg',
                  width: 140,
                  colorFilter:
                      ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -30,
              child: Opacity(
                opacity: 0.20,
                child: SvgPicture.asset(
                  'assets/autune-logo.svg',
                  width: 130,
                  colorFilter:
                      ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),

                    // Logo
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/autune-logo.svg',
                            width: 36,
                            height: 36,
                            colorFilter: ColorFilter.mode(
                                AppColors.mainColor, BlendMode.srcIn),
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

                    const SizedBox(height: 44),

                    Text(
                      'CADASTRO',
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
                    const SizedBox(height: 20),

                    // Mensagem de erro
                    if (_erro != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _erro!,
                          style: TextStyle(
                            fontFamily: 'AlanSans',
                            fontSize: 13,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _Label(texto: 'NOME COMPLETO'),
                    const SizedBox(height: 6),
                    _CampoTexto(controller: _nomeController),

                    const SizedBox(height: 16),

                    _Label(texto: 'E-MAIL'),
                    const SizedBox(height: 6),
                    _CampoTexto(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    _Label(texto: 'USUÁRIO'),
                    const SizedBox(height: 6),
                    _CampoTexto(controller: _usuarioController),

                    const SizedBox(height: 16),

                    _Label(texto: 'SENHA'),
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
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Label(texto: 'CONFIRMAR SENHA'),
                    const SizedBox(height: 6),
                    _CampoTexto(
                      controller: _confirmarSenhaController,
                      obscureText: !_confirmarSenhaVisivel,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmarSenhaVisivel
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.oliveBrownColor,
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                      ),
                    ),

                    const SizedBox(height: 32),


                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _cadastrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.mainColor.withOpacity(0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'CADASTRAR',
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

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'JÁ TEM CADASTRO? ',
                            style: TextStyle(
                              fontFamily: 'AlanSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.oliveBrownColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              'ENTRAR',
                              style: TextStyle(
                                fontFamily: 'AlanSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
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

class _Label extends StatelessWidget {
  final String texto;
  const _Label({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontFamily: 'AlanSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.oliveBrownColor,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _CampoTexto({
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'AlanSans',
        fontSize: 15,
        color: Color(0xFF493D22),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
