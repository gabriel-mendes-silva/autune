/// Nomes das rotas utilizadas pelo [Navigator] em todo o app.
///
/// Centralizar os nomes aqui evita strings "mágicas" espalhadas pelas
/// páginas e facilita a manutenção caso uma rota mude de nome.
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String home = '/home';
}
