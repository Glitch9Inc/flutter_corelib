import 'issue.dart';

class IssueException implements Exception {
  final Issue issue;
  IssueException({required this.issue});
}
