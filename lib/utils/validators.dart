// ignore: unused_import
import 'dart:developer';

class Validators {
  static String? emailValidator(String? mail) {
    if (mail == null) {
      return "Email can't be empty";
    }

    if (mail.isEmpty) {
      return "Email can't be empty";
    }

    if (!mail.contains('@')) {
      return "Email wrong formatted";
    }

    final splittedMail = mail.split('@');

    if (splittedMail.length != 2) {
      return "Email wrong formatted";
    }

    final rightPart = splittedMail[1];

    if (!rightPart.contains('.')) {
      return "Email wrong formatted";
    }

    return null;
  }

  static String? usernameValidator(String? username) {
    if (username == null) {
      return "User name can't be empty";
    }

    if (username.isEmpty) {
      return "User name can't be empty";
    }

    if (username.contains(' ')) {
      return "User name shouldn't contain space";
    }

    return null;
  }

  static String? taxIdValidator(String? taxId) {
    if (taxId == null) {
      return "Tax ID can't be empty";
    }

    if (taxId.isEmpty) {
      return "Tax ID can't be empty";
    }

    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(taxId)) {
      return "Tax ID should contain only numbers";
    }

    return null;
  }

  static String? nameValidator(String? username) {
    String invalidUsernameMessage = "Name shouldn't be empty";
    if (username == null) {
      return invalidUsernameMessage;
    }

    if (username.isEmpty) {
      return invalidUsernameMessage;
    }

    return null;
  }

  static bool specialCharactersPresent(String value) {
    List<String> specialChars = [
      '!',
      '-',
      '@',
      '#',
      '\$',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
      '_',
      '=',
      '.',
      ',',
      '/',
      '>',
      '<',
    ];

    for (var char in specialChars) {
      if (value.contains(char)) {
        return true;
      }
    }

    return false;
  }

  static bool numericsPresent(String value) {
    final numericRegex = RegExp(r'[0-9,\b]');
    return numericRegex.hasMatch(value);
  }

  static bool uppercasePresent(String value) {
    final upperCaseRegex = RegExp(r'[A-Z,\b]');
    return upperCaseRegex.hasMatch(value);
  }

  static bool minLengthCorrect(String value, int length) {
    return value.length >= length;
  }
}
