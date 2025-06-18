import 'package:flutter/material.dart';
import '../models/audio_note_model.dart';

class AudioNoteCard extends StatelessWidget {
  final AudioNote note;

  const AudioNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.mic, color: Colors.deepPurple),
        title: Text(
          "Sesli Not - ${note.category}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(note.path), // Ses dosyası yolu
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            // Ses dosyasını çalacak fonksiyonu buraya ekleyeceğiz
            // Örn: AudioPlayer().startPlayer(fromURI: note.path);
          },
        ),
      ),
    );
  }
}
