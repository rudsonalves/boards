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

class BoardgameModel {
  String? id;
  String name;
  String image;
  int publishYear;
  int minPlayers;
  int maxPlayers;
  int minTime;
  int maxTime;
  int minAge;
  String? designer;
  String? artist;
  String? description;
  List<String> mechIds; // List of mechanic ids

  BoardgameModel({
    this.id,
    required this.name,
    required this.image,
    required this.publishYear,
    required this.minPlayers,
    required this.maxPlayers,
    required this.minTime,
    required this.maxTime,
    required this.minAge,
    this.designer,
    this.artist,
    this.description,
    required this.mechIds,
  });

  factory BoardgameModel.clean() {
    return BoardgameModel(
      name: '',
      image: '',
      publishYear: 2010,
      minPlayers: 2,
      maxPlayers: 4,
      minTime: 25,
      maxTime: 50,
      minAge: 10,
      mechIds: [],
    );
  }

  static String cleanDescription(String text) {
    String description = text.replaceAll('<br/>', '\n');

    while (description[description.length - 1] == '\n') {
      description = description.substring(0, description.length - 1);
    }

    return description;
  }

  String toSimpleString() {
    return '**$name ($publishYear)**: $minPlayers - $maxPlayers jogadores; '
        '$minTime a $maxTime min; idade recomendada +$minAge; '
        'Artista(s): *$artist*\nDesigner(s): *$designer*';
  }

  @override
  String toString() {
    return 'BoardgameModel('
        ' id: $id,\n'
        ' name: $name,\n'
        ' image: $image,\n'
        ' yearpublished: $publishYear,\n'
        ' minplayers: $minPlayers,\n'
        ' maxplayers: $maxPlayers,\n'
        ' minplaytime: $minTime,\n'
        ' maxplaytime: $maxTime,\n'
        ' age: $minAge,\n'
        ' designer: $designer,\n'
        ' artist: $artist,\n'
        ' description: $description,\n'
        ' boardgamemechanic: $mechIds)';
  }

  BoardgameModel copyWith({
    String? id,
    String? name,
    String? image,
    int? publishYear,
    int? minPlayers,
    int? maxPlayers,
    int? minTime,
    int? maxTime,
    int? minAge,
    String? designer,
    String? artist,
    String? description,
    List<String>? mechIds,
  }) {
    return BoardgameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      publishYear: publishYear ?? this.publishYear,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      minTime: minTime ?? this.minTime,
      maxTime: maxTime ?? this.maxTime,
      minAge: minAge ?? this.minAge,
      designer: designer ?? this.designer,
      artist: artist ?? this.artist,
      description: description ?? this.description,
      mechIds: mechIds ?? this.mechIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'publishYear': publishYear,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'minTime': minTime,
      'maxTime': maxTime,
      'minAge': minAge,
      'designer': designer,
      'artist': artist,
      'description': description,
      'mechsPsIds': mechIds,
    };
  }

  factory BoardgameModel.fromMap(Map<String, dynamic> map) {
    return BoardgameModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      image: map['image'] as String,
      publishYear: map['publishYear'] as int,
      minPlayers: map['minPlayers'] as int,
      maxPlayers: map['maxPlayers'] as int,
      minTime: map['minTime'] as int,
      maxTime: map['maxTime'] as int,
      minAge: map['minAge'] as int,
      designer: map['designer'] != null ? map['designer'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      mechIds: List<String>.from(
        (map['mechsPsIds'] as List<dynamic>).map((id) => id as String),
      ),
    );
  }
}
