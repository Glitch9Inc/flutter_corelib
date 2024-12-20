/// Enum for database to object mapping strategy
/// 1. 단일 객체를 받아서 이를 개별 객체로 변환. 예를 들어, 데이터베이스 쿼리 결과로 하나의 행만을 반환, 혹은 하나의 JSON 객체를 파싱.
/// 2. 여러 객체를 받아서 이를 각각의 Map을 객체로 변환한 후, 그 결과를 리스트로 반환. 데이터베이스 쿼리에서 여러 행을 반환받거나, 여러 JSON 객체를 포함하는 배열을 파싱할 때 사용.
enum MappingStrategy {
  /// 단일 객체를 받아서 이를 개별 객체로 변환. 예를 들어, 데이터베이스 쿼리 결과로 하나의 행만을 반환, 혹은 하나의 JSON 객체를 파싱.
  single,

  /// 여러 객체를 받아서 이를 각각의 Map을 객체로 변환한 후, 그 결과를 리스트로 반환. 데이터베이스 쿼리에서 여러 행을 반환받거나, 여러 JSON 객체를 포함하는 배열을 파싱할 때 사용.
  list
}
