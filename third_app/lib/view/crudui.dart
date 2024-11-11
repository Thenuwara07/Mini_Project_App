import 'package:flutter/material.dart';
import '../db/biodata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudUI extends StatefulWidget {
  const CrudUI({Key? key}) : super(key: key);

  @override
  _CrudUIState createState() => _CrudUIState();
}

class _CrudUIState extends State<CrudUI> {
  final DatabaseService database =
      DatabaseService(collectionPath: 'yourCollection');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void _addData() {
    if (_nameController.text.isNotEmpty && _ageController.text.isNotEmpty) {
      database.addDocument({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'createdAt': Timestamp.now(),
      });
      _nameController.clear();
      _ageController.clear();
    }
  }

  void _updateData(String docId, String name, int age) {
    _nameController.text = name;
    _ageController.text = age.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Document"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _ageController.text.isNotEmpty) {
                  database.updateDocument(docId, {
                    'name': _nameController.text,
                    'age': int.tryParse(_ageController.text) ?? age,
                  });
                  _nameController.clear();
                  _ageController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(String docId) {
    database.deleteDocument(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Example")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addData,
              child: const Text("Add Data"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: database
                    .getDocuments(), // Updated function call for single document
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.data!.exists) {
                    return const Center(child: Text("No data available"));
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  return ListView(
                    children: [
                      ListTile(
                        title: Text(data['name'] ?? "No Name"),
                        subtitle: Text("Age: ${data['age'] ?? "N/A"}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _updateData(
                                snapshot.data!.id,
                                data['name'] ?? "",
                                data['age'] ?? 0,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteData(snapshot.data!.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
            ],
        ),
      ),
    );
  }
}
