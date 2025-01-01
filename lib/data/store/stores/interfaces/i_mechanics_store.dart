// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

abstract class IMechanicsStore {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> getAll();
  Future<int> add(Map<String, dynamic> map);
  Future<int> update(Map<String, dynamic> map);
  Future<int> delete(String id);
  Future<void> resetDatabase();
}
