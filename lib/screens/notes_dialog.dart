import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesDialog extends StatefulWidget {
  final int? noteId;
  final String? title, cotent;
  final int colorIndex;
  final List<Color> noteColor;
  final Function onNoteSaved;

  const NotesDialog(
      {super.key,
      this.noteId,
      this.title,
      this.cotent,
      required this.colorIndex,
      required this.noteColor,
      required this.onNoteSaved});

  @override
  State<NotesDialog> createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  late int selectedColorIndex;
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.title);
    final descController = TextEditingController(text: widget.cotent);
    final currentDate = DateFormat('E d MMM').format(DateTime.now());

    return AlertDialog(
      backgroundColor: widget.noteColor[selectedColorIndex],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.noteId == null ? 'Add Note' : 'Edit Note',
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentDate,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                labelText: "Title",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                alignLabelWithHint: true,
                labelText: "Description",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(
                widget.noteColor.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: widget.noteColor[index],
                      child: selectedColorIndex == index
                          ? const Icon(
                              Icons.check,
                              color: Colors.black54,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () async {
              final newTitle = titleController.text;
              final newDesc = descController.text;
              widget.onNoteSaved(
                  newTitle, newDesc, selectedColorIndex, currentDate);
            },
            child: const Text("Save"))
      ],
    );
  }
}
