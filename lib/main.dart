import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewPodcasts.dart';
import 'addPodcast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcast Manager',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast Manager'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.podcasts, size: 100, color: Colors.deepOrange),
            const SizedBox(height: 10),
            const Text(
              'Welcome to Podcast Manager',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ปุ่ม ดูรายการทั้งหมด
            _buildButton(
              context,
              label: '📜 ดูรายการทั้งหมด',
              color: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewPodcasts()),
                  ),
            ),

            const SizedBox(height: 10),
            // ปุ่ม เพิ่มพอดแคสต์
            _buildButton(
              context,
              label: '➕ เพิ่มพอดแคสต์',
              color: Colors.green,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPodcast(),
                    ), // เปลี่ยนไปหน้าสร้างพอดแคสต์
                  ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // รายการพอดแคสต์ตัวอย่าง
            Expanded(
              child: ListView(
                children: [
                  _buildPodcastCard(
                    title: 'Flutter for Beginners',
                    owner: 'John Doe',
                    category: 'Technology',
                  ),
                  _buildPodcastCard(
                    title: 'Mindfulness & You',
                    owner: 'Sarah Smith',
                    category: 'Wellness',
                  ),
                  _buildPodcastCard(
                    title: 'Business Talks',
                    owner: 'Michael Johnson',
                    category: 'Finance',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้างปุ่ม
  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้าง Card ของพอดแคสต์
  Widget _buildPodcastCard({
    required String title,
    required String owner,
    required String category,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.podcasts, color: Colors.redAccent, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('🎙 Owner: $owner\n📌 Category: $category'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ),
    );
  }

  // Dialog สำหรับเพิ่มพอดแคสต์
  void _showAddPodcastDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ownerController = TextEditingController();
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มพอดแคสต์ใหม่'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อพอดแคสต์'),
              ),
              TextField(
                controller: ownerController,
                decoration: const InputDecoration(labelText: 'เจ้าของรายการ'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'หมวดหมู่'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('บันทึก'),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    ownerController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
                  );
                  return;
                }

                // บันทึกลง Firestore
                await FirebaseFirestore.instance.collection('Podcasts').add({
                  'name': nameController.text,
                  'owner': ownerController.text,
                  'category': categoryController.text,
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เพิ่มพอดแคสต์สำเร็จ!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
