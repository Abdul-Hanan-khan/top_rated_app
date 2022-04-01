extension StringExtension on String {
  String capitalized() {
    if (this == null || this.isEmpty) return this;
    List<String> parts = this.split(" ");
    parts = parts.map((s) => _capitalizeWord(s)).toList();
    return parts.join(" ");
  }

  String _capitalizeWord(String word) {
    if(word.isEmpty) {
      return "";
    }
    String fChar = word.substring(0, 1).toUpperCase();
    String end = word.substring(1, word.length);
    return "$fChar$end";
  }
}
