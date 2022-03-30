/*final String tableMyParticipant = 'myparticipant';

class MyParticipantFields {
  static final List<String> values = [id, username, eventId, going, interesed];

  static final String id = "_id";
  static final String username = "username";
  static final String eventId = "eventId";
  static final String going = "going";
  static final String interesed = "interesed";
}

class MyParticipant {
  final int? id;
  final String? username;
  final String? eventId;
  final String? going;
  final String? interesed;

  const MyParticipant({
    this.id,
    required this.username,
    required this.eventId,
    this.going,
    this.interesed,
  });

  MyParticipant copy(
          {int? id,
          String? username,
          String? eventId,
          String? going,
          String? interesed}) =>
      MyParticipant(
          id: id ?? this.id,
          username: username ?? this.username,
          eventId: eventId ?? this.eventId,
          going: going ?? this.going,
          interesed: interesed ?? this.interesed);

  String? get getGoing => this.going;

  Map<String, Object?> toJson() => {
        MyParticipantFields.id: id,
        MyParticipantFields.username: username,
        MyParticipantFields.eventId: eventId,
        MyParticipantFields.going: going,
        MyParticipantFields.interesed: interesed
      };

  static MyParticipant fromJson(Map<String, Object?> json) => MyParticipant(
        id: json[MyParticipantFields.id] as int?,
        username: json[MyParticipantFields.username] as String,
        eventId: json[MyParticipantFields.eventId] as String,
        going: json[MyParticipantFields.going] as String,
        interesed: json[MyParticipantFields.interesed] as String,
      );
}
*/