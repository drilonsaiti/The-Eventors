final String tableParticipant = 'participant';

class ParticipantFields {
  static final List<String> values = [id, eventId, going, interesed];

  static final String id = "_id";
  static final String eventId = "eventId";
  static final String going = "going";
  static final String interesed = "interesed";
}

class Participant {
  final int? id;
  final int? eventId;
  final String? going;
  final String? interesed;

  const Participant({
    this.id,
    required this.eventId,
    this.going,
    this.interesed,
  });

  Participant copy({int? id, int? eventId, String? going, String? interesed}) =>
      Participant(
          id: id ?? this.id,
          eventId: eventId ?? this.eventId,
          going: going ?? this.going,
          interesed: interesed ?? this.interesed);

  String? get getGoing => this.going;

  Map<String, Object?> toJson() => {
        ParticipantFields.id: id,
        ParticipantFields.eventId: eventId,
        ParticipantFields.going: going,
        ParticipantFields.interesed: interesed
      };

  static Participant fromJson(Map<String, Object?> json) => Participant(
        id: json[ParticipantFields.id] as int?,
        eventId: json[ParticipantFields.eventId] as int,
        going: json[ParticipantFields.going] as String,
        interesed: json[ParticipantFields.interesed] as String,
      );
}
