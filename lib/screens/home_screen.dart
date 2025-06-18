import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'category_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['Özel', 'İş', 'Okul', 'Genel'];
  final TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE, dd.MM.yyyy', 'tr_TR').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Memomate Defter Notu"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              formattedDate,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          TableCalendar(
            locale: 'tr_TR',
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: selectedDate,
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDate = selected;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: Colors.deepPurple),
                    title: Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      print("Kategoriye tıklandı: $category");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CategoryNotesScreen(category: category),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Yeni Kategori Ekle"),
                content: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: "Kategori adı girin"),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("İptal"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newCat = controller.text.trim();
                      if (newCat.isNotEmpty && !categories.contains(newCat)) {
                        setState(() {
                          categories.add(newCat);
                        });
                      }
                      controller.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Ekle"),
                  ),
                ],
              );
            },
          );
        },
        label: const Text("Kategori Ekle"),
        icon: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
