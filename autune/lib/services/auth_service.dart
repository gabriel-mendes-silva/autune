import 'package:crypto/crypto.dart';
import 'package:autune/services/database_service.dart';
import 'dart:convert';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  Map<String, dynamic>? _usuarioAtual;
  Map<String, dynamic>? get usuarioAtual => _usuarioAtual;

  String _hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    return sha256.convert(bytes).toString();
  }

  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String usuario,
    required String senha,
    required String confirmarSenha,
  }) async {
    if (nome.trim().isEmpty ||
        email.trim().isEmpty ||
        usuario.trim().isEmpty ||
        senha.isEmpty) {
      return 'Preencha todos os campos.';
    }

    if (senha != confirmarSenha) {
      return 'As senhas não coincidem.';
    }

    if (senha.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }

    final db = await DatabaseService.instance.database;

    final existente = await db.query(
      'usuarios',
      where: 'usuario = ? OR email = ?',
      whereArgs: [usuario.trim(), email.trim().toLowerCase()],
    );

    if (existente.isNotEmpty) {
      final item = existente.first;
      if (item['usuario'] == usuario.trim()) {
        return 'Este nome de usuário já está em uso.';
      }
      return 'Este e-mail já está cadastrado.';
    }

    await db.insert('usuarios', {
      'nome': nome.trim(),
      'email': email.trim().toLowerCase(),
      'usuario': usuario.trim(),
      'senha': _hashSenha(senha),
    });

    return null;
  }

  Future<String?> login({
    required String usuario,
    required String senha,
  }) async {
    if (usuario.trim().isEmpty || senha.isEmpty) {
      return 'Preencha todos os campos.';
    }

    final db = await DatabaseService.instance.database;

    final resultado = await db.query(
      'usuarios',
      where: 'usuario = ?',
      whereArgs: [usuario.trim()],
    );

    if (resultado.isEmpty) {
      return 'Usuário não encontrado.';
    }

    final user = resultado.first;

    if (user['senha'] != _hashSenha(senha)) {
      return 'Senha incorreta.';
    }

    _usuarioAtual = user;
    return null;
  }

  void logout() {
    _usuarioAtual = null;
  }
}
