abstract class IBgNamesStore {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> getAll();
  Future<int> add(Map<String, dynamic> map);
  Future<int> update(Map<String, dynamic> map);
  Future<void> resetDatabase();
  Future<int> delete(String bgId);
}
