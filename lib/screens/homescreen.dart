import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/addnotes.dart';
import 'package:flutter_intern_project/screens/notesdetailed.dart';
class Homescreen extends StatelessWidget {
   Homescreen({super.key});
   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Addnotes()));
      },
      child: Icon(Icons.add) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(stream: _firebaseFirestore.collection('notes')
              .orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshots){
                if(snapshots.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if(!snapshots.hasData || snapshots.data!.docs.isEmpty){
                  return Center(child: Text('No Notes Yet'));
                }
                final notes = snapshots.data!.docs;
                return ListView.builder(
                  
                  itemCount: notes.length,
                  itemBuilder: (context,index){
                    final note = notes[index].data();
                     final String docId = notes[index].id;
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.push(context, 
                        MaterialPageRoute(builder: (context)=> Notesdetailed( note: note, docId: docId,))
                        ),
                        child: ListTile(
                          title: Text(note['title'] ?? ''),                        
                        ),
                      ),
                    );
                  });             
              }),
            )
          ],
        ),
      ),
    );
  }
}