import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'add_note_page.dart'; // Import the Add Note Page

class ViewNotesPage extends StatefulWidget {
  final List<String> notes;

  const ViewNotesPage({super.key, required this.notes});

  @override
  State<ViewNotesPage> createState() => _ViewNotesPageState();
}

class _ViewNotesPageState extends State<ViewNotesPage> {
  final List<Color> _boxColors = [
    Colors.deepPurpleAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.cyanAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.lightGreenAccent.shade100,
    Colors.lime.shade100,
  ];

  late List<String> _filteredNotes; // Notes after filtering
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredNotes = List.from(widget.notes); // Initialize with all notes
  }

  // Function to filter notes
  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = widget.notes
          .where((note) => note.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Function to edit a note
  void _editNote(int index) {
    final TextEditingController controller =
    TextEditingController(text: _filteredNotes[index]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Edit your note'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final originalIndex =
                  widget.notes.indexOf(_filteredNotes[index]);
                  widget.notes[originalIndex] = controller.text;
                  _filterNotes(_searchController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a note
  void _deleteNote(int index) {
    setState(() {
      final originalIndex = widget.notes.indexOf(_filteredNotes[index]);
      widget.notes.removeAt(originalIndex);
      _filteredNotes.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note Deleted!')),
    );
  }

  // Function to limit the note text to 120 characters
  String _getLimitedNoteText(String note) {
    if (note.length > 120) {
      return note.substring(0, 120) + '...';
    } else {
      return note;
    }
  }

  // Navigate to Add Note Page
  void _navigateToAddNotePage() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );

    if (newNote != null) {
      setState(() {
        widget.notes.add(newNote);
        _filterNotes(_searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton( // Back button functionality
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.notes); // Return the updated notes list
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterNotes,
                decoration: InputDecoration(
                  hintText: 'Search Notes Here',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Notes List (Dynamic Size Containers)
            Expanded(
              child: _filteredNotes.isEmpty
                  ? const Center(
                child: Text(
                  'No Notes Found',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
                  : MasonryGridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate:
                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns for dynamic layout
                ),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final color = _boxColors[index % _boxColors.length];
                  return Dismissible(
                    key: Key(_filteredNotes[index]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => _deleteNote(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _getLimitedNoteText(_filteredNotes[index]),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black),
                              onPressed: () => _editNote(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNotePage,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
