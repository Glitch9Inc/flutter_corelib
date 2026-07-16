class PermissionCheckResult<TPermissionModel> {
  final bool isGranted;
  final List<TPermissionModel> missingPermissions;

  bool get isDenied => !isGranted;

  const PermissionCheckResult(this.isGranted, this.missingPermissions);

  factory PermissionCheckResult.granted() {
    return const PermissionCheckResult(true, []);
  }

  factory PermissionCheckResult.denied(List<TPermissionModel> missingPermissions) {
    return PermissionCheckResult(false, missingPermissions);
  }
}
