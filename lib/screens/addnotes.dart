import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Addnotes extends StatefulWidget {
  final Map<String,dynamic>? note;
    final String? docId; 
  const Addnotes({super.key, this.note, this.docId});

  @override
  State<Addnotes> createState() => _AddnotesState();
}

class _AddnotesState extends State<Addnotes> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> _saveNote() async {
    final title = _title.text.trim();
    final content = _content.text.trim();
    if (title.isEmpty || content.isEmpty) return;

    if(widget.docId == null){
    await _firebaseFirestore.collection('notes').add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
    }
    else{
     await _firebaseFirestore.collection('notes')
      .doc(widget.docId)
      .update({
        'title' : title,
        'content': content,
        'updateAt': FieldValue.serverTimestamp(),
      });
      
    }
    if(!mounted) return;
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    
  }
  
  @override
  void dispose() {
   _title.dispose();
   _content.dispose();
    super.dispose();
  }

  @override
void initState() {
  super.initState();
  if (widget.note != null) {
    _title.text = widget.note!['title'] ?? '';
    _content.text = widget.note!['content'] ?? '';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,       
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Add Title',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )
                ),               
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _content,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )
                ),
               maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}