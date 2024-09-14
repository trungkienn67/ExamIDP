class Song {
  String title;
  String artist;
  int year;

  // Constructor
  Song(this.title, this.artist, this.year);

  // Method to display song details
  @override
  String toString() {
    return 'Title: $title, Artist: $artist, Year: $year';
  }

  // Method to update song details
  void updateDetails(String newTitle, String newArtist, int newYear) {
    title = newTitle;
    artist = newArtist;
    year = newYear;
  }
}
