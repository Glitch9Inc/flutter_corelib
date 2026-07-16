class FirebaseUtil {
  static String parseErrorMessage(String errorMessage) {
    return errorMessage.substring(errorMessage.indexOf(']') + 1);
  }
}
