import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notesdetailed extends StatefulWidget {
   final Map<String,dynamic> note;
    final String docId; 

  const Notesdetailed({super.key, required this.note, required this.docId});

  @override
  State<Notesdetailed> createState() => _NotesdetailedState();
}

class _NotesdetailedState extends State<Notesdetailed> {
  bool isEditing = false;
  late TextEditingController titlecontroller;
  late TextEditingController contentcontroller;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

   @override
  void dispose() {
   titlecontroller.dispose();
   contentcontroller.dispose();
    super.dispose();
  }

  @override
void initState() {
  super.initState();
    titlecontroller = TextEditingController(text:widget.note['title'] ?? '');
    contentcontroller = TextEditingController(text:widget.note['content'] ?? '');
  }

Future<void> _editNote() async {
    
     await _firebaseFirestore.collection('notes')
      .doc(widget.docId)
      .update({
        'title' : titlecontroller.text.trim(),
        'content': contentcontroller.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    setState(() {
      isEditing= false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        actions: [
          isEditing?
          IconButton(onPressed: _editNote, icon: Icon(Icons.save)):
          PopupMenuButton<String>(
            onSelected: (value) {
              if(value == 'edit'){
                setState(() {
                  isEditing= true;
                });
              }
             else if(value == 'delete'){
              showDialog(context: context, 
              builder:(_)=>AlertDialog(
                title: Text('Delete Notes'),
                content: Text('Are You sure?'),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Cancel')),
                  TextButton(onPressed: (){
                    FirebaseFirestore.instance
                    .collection('notes')
                    .doc(widget.docId)
                    .delete();
                    Navigator.pop(context); 
                    Navigator.pop(context);
                  }, child: Text('Delete'))
                ],
              ),             
              );
              }
            },
            itemBuilder: (context)=> [
              PopupMenuItem(
                 value: 'edit',
                child: Text('Edit'),),
              PopupMenuItem(
                 value: 'delete',
                child: Text('Delete')),
            ]        
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing?TextField(
              controller: titlecontroller,
            ):
            Text('${widget.note['title'] ?? ''}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(
              height: 20,
            ),
            isEditing?TextField(
              controller: contentcontroller,
              maxLines: null,
            ):
            Text('${widget.note['content'] ?? ''}')
          ],
        ),
      ),
    );
  }
}