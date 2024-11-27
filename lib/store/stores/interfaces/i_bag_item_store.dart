abstract class IBagItemStore {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> getAll();
  Future<int> add(Map<String, dynamic> map);
  Future<int> update(Map<String, dynamic> map);
  Future<int> updateQuantity(int id, int quantity);
  Future<int> delete(int id);
  Future<void> resetDatabase();
  Future<void> cleanDatabase();
}
