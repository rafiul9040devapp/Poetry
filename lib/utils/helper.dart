String removeSpecialCharacters(String input) {
  // Replace double quotes and forward slashes with an empty string
  return input.replaceAll(RegExp(r'[\"\/]'), '');
}