import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/audio_note_model.dart';

class AudioNoteProvider with ChangeNotifier {
  List<AudioNote> _notes = [];

  List<AudioNote> get notes => _notes;

  List<AudioNote> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  Future<void> addNote(AudioNote note) async {
    _notes.add(note);
    notifyListeners();
    await saveToPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('audio_notes');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _notes = decoded.map((e) => AudioNote.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_notes.map((e) => e.toMap()).toList());
    await prefs.setString('audio_notes', encoded);
  }
}
