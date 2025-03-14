import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPodcast extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  AddPodcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มพอดแคสต์ใหม่ 🎙️'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.podcasts, size: 80, color: Colors.deepOrange),
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: nameController,
              label: 'ชื่อพอดแคสต์',
              icon: Icons.mic,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: ownerController,
              label: 'เจ้าของรายการ',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: categoryController,
              label: 'หมวดหมู่',
              icon: Icons.category,
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'บันทึกข้อมูล',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 99, 199, 85),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      ownerController.text.isEmpty ||
                      categoryController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('⚠️ กรุณากรอกข้อมูลให้ครบถ้วน'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('Podcasts')
                        .add({
                          'name': nameController.text,
                          'owner': ownerController.text,
                          'category': categoryController.text,
                        });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ เพิ่มพอดแคสต์เรียบร้อยแล้ว!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print('Error adding podcast: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('❌ ไม่สามารถบันทึกพอดแคสต์ได้'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
