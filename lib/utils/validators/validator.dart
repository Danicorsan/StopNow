class Validator {
  
  // Validar email
  static bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // La contraseña debe tener al menos 8 caracteres, al menos una letra mayúscula, al menos una letra minúscula y al menos un número.
  static bool isValidPassword(String password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])\S{8,16}$');
    return passwordRegex.hasMatch(password);
  }
}
