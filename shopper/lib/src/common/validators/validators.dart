class Validators {
  const Validators._internal();

  static bool nickname(String rawNickname) {
    if (rawNickname.length < 6) return false;
    return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(rawNickname);
  }

  static bool email(String rawEmail) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(rawEmail);
  }

  static bool password(String rawPassword) {
    if (rawPassword.length < 8) return false;
    if (!(rawPassword.contains(RegExp(r'[a-z]')) ||
        rawPassword.contains(RegExp(r'[A-Z]')))) return false;
    if (!rawPassword.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }
}
