import 'package:flutter/material.dart';
import 'view_notes_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final List<String> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _successMessage;
  Color _selectedColor = Colors.purpleAccent;

  // Function to add a note
  void _addNote() {
    String noteTitle = _titleController.text.trim();
    String noteText = _noteController.text.trim();
    if (noteTitle.isNotEmpty && noteText.isNotEmpty) {
      setState(() {
        _notes.add('$noteTitle: $noteText');
        _titleController.clear(); // Clear the title field
        _noteController.clear(); // Clear the note field
        _successMessage = "Yepie Hurray! Note Added";
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _successMessage = null;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Note cannot be empty')),
      );
    }
  }

  // Navigate back to View Notes Page
  void _navigateToViewNotes() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewNotesPage(notes: _notes),
      ),
    );
  }

  // Function to update selected color
  void _updateColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: _selectedColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToViewNotes,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Note Title Field
              const Text(
                'Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter title here...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _selectedColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Note Content Field
              const Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your note here...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _selectedColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Add Note Button
              ElevatedButton.icon(
                onPressed: _addNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text('Add Note', style: TextStyle(fontSize: 16)),
              ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _successMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Color Palette for Selection
              const Text(
                'Choose Note Background Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildColorOption(Colors.pinkAccent),
                    _buildColorOption(Colors.blueAccent),
                    _buildColorOption(Colors.orangeAccent),
                    _buildColorOption(Colors.purpleAccent),
                    _buildColorOption(Colors.yellowAccent),
                    _buildColorOption(Colors.grey),
                    _buildColorOption(Colors.brown),
                    _buildColorOption(Colors.greenAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a color option
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => _updateColor(color),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 18,
          child: _selectedColor == color
              ? const Icon(Icons.check, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
