enum LocalizedStringType {
  name,
  description,
}

extension LocalizedStringTypeExtension on LocalizedStringType {
  String get name {
    switch (this) {
      case LocalizedStringType.name:
        return 'name';
      case LocalizedStringType.description:
        return 'desc';
    }
  }
}
