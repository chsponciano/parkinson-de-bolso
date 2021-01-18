abstract class StringUtil {
  static String getInitials(String value) {
    return value.isNotEmpty ? value.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase() : '';
  }
}