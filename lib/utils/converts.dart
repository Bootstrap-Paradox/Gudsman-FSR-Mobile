String convertToSnakeCase(String input) {
  String output = '';
  for (int i = 0; i < input.length; i++) {
    if (input[i] == input[i].toUpperCase()) {
      output += '_${input[i].toLowerCase()}';
    } else {
      output += input[i];
    }
  }
  return output;
}

String convertToCamelCase(String input) {
  String output = '';
  for (int i = 0; i < input.length; i++) {
    if (input[i] == '_') {
      output += input[i + 1].toUpperCase();
      i++;
    } else {
      output += input[i];
    }
  }
  return output;
}

String convertToEnglish(String input) {
  String output = '';
  for (int i = 0; i < input.length; i++) {
    if (input[i] == '_') {
      output += ' ';
    } else {
      output += input[i];
    }
  }
  return output.substring(0, 1).toUpperCase() + output.substring(1);
}
