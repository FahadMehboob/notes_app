import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/screens/note_card.dart';
import 'package:notes_app/screens/notes_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchNotes = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchNotes;
    });
  }

  final List<Color> noteColor = [
    const Color(0xFF6A0572), // Deep Purple
    const Color(0xFF028090), // Teal Blue
    const Color(0xFF00A896), // Light Teal
    const Color(0xFFF0A6CA), // Pinkish
    const Color(0xFFFE5F55), // Coral Red
    const Color(0xFF3C1642), // Dark Violet
    const Color(0xFF086375), // Deep Teal
    const Color(0xFFFFB400), // Vivid Yellow
    const Color(0xFF53354A), // Muted Maroon
    const Color(0xFF2E4057), // Steel Blue
    const Color(0xFF247BA0), // Blue
    const Color(0xFFF25F5C), // Salmon Red
    const Color(0xFF70C1B3), // Mint
    const Color(0xFFB2DBBF), // Pale Green
    const Color(0xFF9D8189), // Dusty Rose
  ];
  void showNoteDailog(
      {int? id, String? title, String? content, int colorIndex = 0}) {
    showDialog(
        context: context,
        builder: (dialogcontext) {
          return NotesDialog(
            colorIndex: colorIndex,
            noteColor: noteColor,
            noteId: id,
            title: title,
            cotent: content,
            onNoteSaved: (newTitle, newDesc, currentDate, newColorIndex) async {
              if (id == null) {
                await NotesDatabase.instance
                    .insertNote(newTitle, newDesc, currentDate, newColorIndex);
              } else {
                NotesDatabase.instance.updateNote(
                    newTitle, newDesc, currentDate, newColorIndex, id);
              }
              fetchNotes();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: const Text(
          "Notes",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDailog();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No Notes Found",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                      note: note,
                      onDelete: () async {
                        await NotesDatabase.instance.deleteNote(
                          note['id'],
                        );
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDailog(
                          id: note['id'],
                          title: note['title'],
                          content: note['desc'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColor);
                },
                itemCount: notes.length,
              ),
            ),
    );
  }
}
