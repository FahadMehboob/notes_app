import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function onDelete;
  final Function onTap;
  final List<Color> noteColors;

  const NoteCard(
      {super.key,
      required this.note,
      required this.onDelete,
      required this.onTap,
      required this.noteColors});
  @override
  Widget build(BuildContext context) {
    final colorIndex = note['color'] as int;
    return GestureDetector(
        onTap: () => onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: noteColors[colorIndex],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note['date'],
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                note['title'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Text(
                  note['description'],
                  style: const TextStyle(
                      color: Colors.black54,
                      height: 1.5,
                      overflow: TextOverflow.fade),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      onDelete();
                    },
                    icon: Icon(
                      fill: 0.9,
                      semanticLabel: 'Delete',
                      Icons.delete_forever,
                      color: Colors.white.withOpacity(0.69),
                      size: 25,
                    ),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
