

class Validation{
  static bool isValidEmail(String email) {
    // Use a regular expression to check if the email format is valid
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

}