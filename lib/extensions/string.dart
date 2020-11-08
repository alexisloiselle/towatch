extension StringExtension on String {
  String asNotEmpty() => this.isEmpty ? null : this;
}
