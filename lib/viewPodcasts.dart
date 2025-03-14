import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editPodcast.dart';

class ViewPodcasts extends StatelessWidget {
  final CollectionReference podcasts = FirebaseFirestore.instance.collection(
    'Podcasts',
  );

  ViewPodcasts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎙 Podcasts List'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: podcasts.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No podcasts found 😞',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children:
                snapshot.data!.docs.map((doc) {
                  return _buildPodcastCard(context, doc);
                }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildPodcastCard(BuildContext context, DocumentSnapshot doc) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.podcasts, color: Colors.white),
        ),
        title: Text(
          doc['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          '📌category : ${doc['category']}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPodcast(doc: doc),
                  ),
                );
              },
              tooltip: 'Edit Podcast',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, doc),
              tooltip: 'Delete Podcast',
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Podcast'),
            content: Text('Are you sure you want to delete "${doc['name']}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  podcasts.doc(doc.id).delete();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
