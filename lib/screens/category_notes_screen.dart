import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/audio_note_model.dart';
import '../providers/note_provider.dart';
import '../providers/audio_note_provider.dart';
import '../widgets/note_card.dart';
import 'lined_note_screen.dart';
import 'audio_note_screen.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class CategoryNotesScreen extends StatelessWidget {
  final String category;
  const CategoryNotesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final audioNoteProvider = context.watch<AudioNoteProvider>();

    final categoryNotes =
        noteProvider.notes.where((note) => note.category == category).toList();
    final categoryAudioNotes = audioNoteProvider.getNotesByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (categoryNotes.isNotEmpty)
            ...categoryNotes.map((note) => NoteCard(note: note)),
          if (categoryAudioNotes.isNotEmpty)
            ...categoryAudioNotes
                .map((audioNote) => AudioNoteCard(audioNote: audioNote)),
          if (categoryNotes.isEmpty && categoryAudioNotes.isEmpty)
            const Center(
              child: Text(
                "Bu kategoride henüz not yok.",
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("Yazılı Not"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LinedNoteScreen(category: category),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mic),
                    title: const Text("Sesli Not"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioNoteScreen(category: category),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AudioNoteCard extends StatefulWidget {
  final AudioNote audioNote;

  const AudioNoteCard({super.key, required this.audioNote});

  @override
  State<AudioNoteCard> createState() => _AudioNoteCardState();
}

class _AudioNoteCardState extends State<AudioNoteCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (isPlaying) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.audioNote.path));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('yyyy-MM-dd').format(widget.audioNote.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.mic),
        title: Text('Sesli Not - ${widget.audioNote.category}'),
        subtitle: Text(dateFormatted),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: _togglePlay,
        ),
      ),
    );
  }
}
