import 'package:flutter/material.dart';
import 'package:sqlite_demo/local_db.dart';
import 'package:sqlite_demo/local_db.model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyDemo());
  }
}

class MyDemo extends StatefulWidget {
  const MyDemo({super.key});

  @override
  State<MyDemo> createState() => _MyDemoState();
}

class _MyDemoState extends State<MyDemo> {
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtEditNameController = TextEditingController();
  late Future<List<Student>> futureData;

  @override
  void initState() {
    futureData = LocalDataBase.selectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: txtNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                await LocalDataBase.insertData(
                    Student(name: txtNameController.text));
                futureData = LocalDataBase.selectData();
                setState(() {});
              },
              child: const Text('Submit'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                await LocalDataBase.closeDb;
              },
              child: const Text('Close'),
            ),
            FutureBuilder<List<Student>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.data!.isNotEmpty && snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        await LocalDataBase.deleteData(
                            snapshot.data![index].id!);
                        futureData = LocalDataBase.selectData();
                        setState(() {});
                      },
                      child: ListTile(
                        title: Text(snapshot.data![index].name!),
                        onTap: () {
                          txtEditNameController.text =
                              snapshot.data![index].name!;
                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) => SimpleDialog(
                                children: [
                                  TextField(
                                    controller: txtEditNameController,
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      print(snapshot.data![index].id!);
                                      await LocalDataBase.updateData(Student(
                                          id: snapshot.data![index].id!,
                                          name: txtEditNameController.text));
                                      futureData = LocalDataBase.selectData();

                                      if (!mounted) return;
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update Name'),
                                  )
                                ],
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        },
                      ),
                    ),
                  ));
                } else {
                  return const Center(child: Text('There Is No Data'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
