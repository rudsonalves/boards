class ParserServerErrors {
  static String message(int code) {
    switch (code) {
      case 101:
        return 'Usuário/senha inválidos. Por favor, tente novamente.';
      case 202:
        return 'Este usuário já possui cadastro. Tente '
            'um outro usuário ou recupere a senha na página de login.';
      case 203:
        return 'Este e-mail já foi utilizado. Tente '
            'um outro e-mail ou recupere a senha na página de login.';
      case 205:
        return 'Esta conta ainda não foi verificada. Verifique sua caixa de e-mail.';
      default:
        return 'Desculpe. Ocorreu um erro. Por favor, tente mais tarde.';
    }
  }
}
