abstract class IMechanicsStore {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> getAll();
  Future<int> add(Map<String, dynamic> map);
  Future<int> update(Map<String, dynamic> map);
  Future<int> delete(String id);
  Future<void> resetDatabase();
}
