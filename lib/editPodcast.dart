import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPodcast extends StatelessWidget {
  final DocumentSnapshot
  doc; // เปลี่ยนจาก QueryDocumentSnapshot เป็น DocumentSnapshot

  const EditPodcast({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(
      text: doc['name'],
    );
    TextEditingController ownerController = TextEditingController(
      text: doc['owner'],
    );
    TextEditingController categoryController = TextEditingController(
      text: doc['category'],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Podcast'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  nameController,
                  '📻 Podcast Name',
                  Icons.podcasts,
                  Colors.blue,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  ownerController,
                  '👤 Owner',
                  Icons.person,
                  const Color.fromARGB(255, 0, 0, 0),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  categoryController,
                  '🏷 Category',
                  Icons.category,
                  Colors.orange,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 115, 255, 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await doc.reference.update({
                      'name': nameController.text,
                      'owner': ownerController.text,
                      'category': categoryController.text,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Podcast updated successfully!'),
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้าง TextField ที่มีไอคอนและสี
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    Color color,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
