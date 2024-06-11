import 'package:flutter_corelib/flutter_corelib.dart';

class FutureResult {
  bool success;
  Issue? issue;

  FutureResult({required this.success, this.issue});
  factory FutureResult.success() => FutureResult(success: true);
  factory FutureResult.fail(Issue issue) => FutureResult(success: false, issue: issue);
}
