import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class LinedNoteScreen extends StatefulWidget {
  final String category;
  const LinedNoteScreen({super.key, required this.category});

  @override
  State<LinedNoteScreen> createState() => _LinedNoteScreenState();
}

class _LinedNoteScreenState extends State<LinedNoteScreen> {
  final contentController = TextEditingController();

  void saveNote() {
    final note = Note(
      id: const Uuid().v4(),
      title: contentController.text.split('\n').firstOrNull ?? 'Başlıksız',
      content: contentController.text,
      category: widget.category,
      date: DateTime.now(),
    );

    context.read<NoteProvider>().addNote(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Yazılı Not"),
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Container(
        color: const Color(0xFFF3EDFF),
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: contentController,
          maxLines: null,
          expands: true,
          style: const TextStyle(
            height: 1.5,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Notlarını buraya yaz...',
            fillColor: Colors.transparent,
            filled: true,
          ),
        ),
      ),
    );
  }
}
