class AuthService {
  // Simula um login validando e-mail e senha
  bool login(String email, String senha) {
    if (email.isNotEmpty && senha.isNotEmpty) {
      return true;
    }
    return false;
  }
}