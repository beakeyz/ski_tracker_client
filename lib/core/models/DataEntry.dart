
/*
 * One track entry
 * 
 * Data that describes a single track 
 */
class DataEntry {
  int horizontalDistance;
  double upDistance;
  double downDistance;

  double maxSpeed;
  double trackTimeSec;
  String date;
  int index;

  DataEntry(
    {
      required this.horizontalDistance,
      required this.upDistance,
      required this.downDistance,
      required this.maxSpeed,
      required this.date,
      required this.trackTimeSec,
      required this.index
    }
  );

  DataEntry.fromJson(Map<String, dynamic> json)
      : horizontalDistance = json['HoriDistance'],
        upDistance = json['UpDistance'],
        downDistance = json['DownDistance'],
        maxSpeed = json['MaxSpeed'],
        date = json['Date'],
        trackTimeSec = json['TrackTime'],
        index = json['Index'];

  Map<String, dynamic> toJson() => {
        'HoriDistance': horizontalDistance,
        'UpDistance' : upDistance,
        'DownDistance' : downDistance,
        'MaxSpeed': maxSpeed,
        'Date': date,
        'TrackTime': trackTimeSec,
        'Index': index,
      };
}
