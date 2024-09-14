import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Song {
  String title;
  String artist;
  int year;

  Song(this.title, this.artist, this.year);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        hintColor: Colors.amber,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: SongListScreen(),
    );
  }
}

class SongListScreen extends StatefulWidget {
  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final List<Song> _songs = [];

  void _navigateToAddSongScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSongScreen(onAddSong: _addSong),
      ),
    );
  }

  void _navigateToUpdateSongScreen(Song song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSongScreen(
          song: song,
          onUpdateSong: (updatedSong) {
            setState(() {
              final index = _songs.indexOf(song);
              if (index != -1) {
                _songs[index] = updatedSong;
              }
            });
          },
        ),
      ),
    );
  }

  void _addSong(Song song) {
    setState(() {
      _songs.add(song);
    });
  }

  void _deleteSong(Song song) {
    setState(() {
      _songs.remove(song);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _songs.isEmpty
            ? Center(child: Text('No songs added yet!', style: Theme.of(context).textTheme.bodyMedium))
            : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(song.title, style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Text('${song.artist} - ${song.year}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.amber),
                            onPressed: () => _navigateToUpdateSongScreen(song),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSong(song),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSongScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddSongScreen extends StatelessWidget {
  final Function(Song) onAddSong;
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _yearController = TextEditingController();

  AddSongScreen({required this.onAddSong});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Song Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _artistController,
              decoration: InputDecoration(
                labelText: 'Artist',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final artist = _artistController.text;
                final year = int.tryParse(_yearController.text);

                if (title.isEmpty || artist.isEmpty || year == null) {
                  return;
                }

                onAddSong(Song(title, artist, year));

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Song added successfully!')),
                );
              },
              child: Text('Add Song'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateSongScreen extends StatefulWidget {
  final Song song;
  final Function(Song) onUpdateSong;

  UpdateSongScreen({required this.song, required this.onUpdateSong});

  @override
  _UpdateSongScreenState createState() => _UpdateSongScreenState();
}

class _UpdateSongScreenState extends State<UpdateSongScreen> {
  late TextEditingController _titleController;
  late TextEditingController _artistController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.song.title);
    _artistController = TextEditingController(text: widget.song.artist);
    _yearController = TextEditingController(text: widget.song.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Song Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _artistController,
              decoration: InputDecoration(
                labelText: 'Artist',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final artist = _artistController.text;
                final year = int.tryParse(_yearController.text);

                if (title.isEmpty || artist.isEmpty || year == null) {
                  return;
                }

                final updatedSong = Song(title, artist, year);
                widget.onUpdateSong(updatedSong);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Song updated successfully!')),
                );
              },
              child: Text('Update Song'),
            ),
          ],
        ),
      ),
    );
  }
}
