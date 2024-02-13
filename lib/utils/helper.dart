String removeSpecialCharacters(String input) {
  // Replace double quotes and forward slashes with an empty string
  return input.replaceAll(RegExp(r'[\"\/]'), '');
}

String replaceSpecialString(String input) {
  return input.replaceAll('â', '—');
}

String customEncode(String value) {
  if (value.startsWith('136')) {
    return '136.%20Prayer—O%20Thou%20Dread%20Power';
  } else if (value.startsWith('137')) {
    return '137.%20Song—Farewell%20to%20the%20Banks%20of%20Ayr';
  } else if (value.contains('209')) {
    return '209.%20Song—M’Pherson’s%20Farewell';
  } else if (value.contains('â')) {
    String updated = replaceSpecialString(value);
    return Uri.encodeFull(updated).replaceAll("%21", "!");
  } else {
    return Uri.encodeFull(value).replaceAll("%21", "!");
  }
}
