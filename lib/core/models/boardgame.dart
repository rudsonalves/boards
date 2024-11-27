// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  List<String> mechsPsIds;

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
    required this.mechsPsIds,
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
      mechsPsIds: [],
    );
  }

  static String cleanDescription(String text) {
    String description = text.replaceAll('<br/>', '\n');

    while (description[description.length - 1] == '\n') {
      description = description.substring(0, description.length - 1);
    }

    return description;
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
        ' boardgamemechanic: $mechsPsIds)';
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
    List<String>? mechsPsIds,
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
      mechsPsIds: mechsPsIds ?? this.mechsPsIds,
    );
  }
}
