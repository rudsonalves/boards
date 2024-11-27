# Copyright (C) 2024 Rudson Alves
# 
# This file is part of bgbazzar.
# 
# bgbazzar is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# bgbazzar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

docker_up:
	docker compose up -d

docker_down:
	docker compose down

flutter_clean:
	flutter clean && flutter pub get

diff:
	git add .
	git diff --cached > ~/diff

push:
	git add .
	git commit -F ~/commit.txt
	git push origin HEAD
	git checkout main

build_profile:
	flutter clean
	flutter pub get
	flutter run --profile