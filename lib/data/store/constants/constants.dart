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

const dbName = 'boards.db';
const dbVersion = 1;
const dbAssertPath = 'assets/data/bgBazzar.db';

const mechTable = 'Mechanics';
const mechIndexName = 'mechNameIndex';
const mechIndexPSId = 'mechIndexPSId';
const mechId = 'id';
const mechName = 'name';
const mechDescription = 'description';

const bagItemsTable = 'bagItemsTable';
const bagItemsId = 'id';
const bagItemsAdId = 'adId';
const bagItemsOwnerId = 'ownerId';
const bagItemsOwnerName = 'ownerName';
const bagItemsTitle = 'title';
const bagItemsDescription = 'description';
const bagItemsQuantity = 'quantity';
const bagItemsUnitPrice = 'unitPrice';

const dbVersionTable = 'dbVersion';
const dbVersionId = 'id';
const dbAppVersion = 'version';
const dbBGVersion = 'bg_version';
const dbBGList = 'bg_list';

const bgNamesTable = 'bgNames';
const bgId = 'id';
const bgName = 'name';

const dbAppVersionValue = 1002;
const dbBGVersionValue = 1;
