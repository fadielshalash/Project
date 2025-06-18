import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import '../models/audio_note_model.dart';
import '../providers/audio_note_provider.dart';

class AudioNoteScreen extends StatefulWidget {
  final String category;
  const AudioNoteScreen({super.key, required this.category});

  @override
  State<AudioNoteScreen> createState() => _AudioNoteScreenState();
}

class _AudioNoteScreenState extends State<AudioNoteScreen> {
  final Record _recorder = Record();
  bool _isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    if (micStatus != PermissionStatus.granted ||
        storageStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mikrofon ve depolama izni gerekli")),
      );
    }
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
      _filePath = path;

      await _recorder.start(path: path);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() {
      _isRecording = false;
    });

    if (_filePath != null) {
      final note = AudioNote(
        path: _filePath!,
        category: widget.category,
        date: DateTime.now(),
      );

      final provider = Provider.of<AudioNoteProvider>(context, listen: false);
      await provider.addNote(note);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt tamamlandı")),
      );
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sesli Not - ${widget.category}"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          label: Text(_isRecording ? "Kaydı Durdur" : "Kaydı Başlat"),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRecording ? Colors.red : Colors.deepPurple[200],
            foregroundColor: Colors.white,
          ),
          onPressed: _isRecording ? _stopRecording : _startRecording,
        ),
      ),
    );
  }
}
