mixin StringUtil {
  String abbreviate(String value) {
    final List<String> content = value.split(' ');
    
    for (var i = 1; i < content.length - 1; i++) {
      if (content[i].length > 3) {
        content[i] = content[i][0] + '.';
      }
    }

    return content.join(' ');
  }

  String capitalize(String value) {
    final List<String> content = value.split(' ');
    
    for (var i = 0; i < content.length; i++) {
      if (content[i].length > 3) {
        content[i] = content[i][0].toUpperCase() +  content[i].substring(1).toLowerCase();
      }
    }

    return content.join(' ');
  }
}