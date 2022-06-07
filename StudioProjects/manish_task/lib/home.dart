import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  //late bool value = false;
  CollectionReference students = FirebaseFirestore.instance.collection('students');


  Future<void> addStudent(String name,String title) {
    // Calling the collection to add a new user
    return students
    //adding to firebase collection
        .add({
      //Data added in the form of a dictionary into the document.
      'name': "$name",
      'title': "$title",
      "image":"https://cdn.pixabay.com/photo/2019/03/03/08/25/rabbit-4031334_960_720.png"

    })
        .then((value) => print("Student data Added"))
        .catchError((error) => print("Student couldn't be added."));
  }
  bool valuefirst = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.defaultDialog(
            title: "Add Details",
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller.name,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.title,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        var image = await controller.uploadImage();
                      },
                      child: Obx(() => !controller.uploaded.value
                          ? Text("Upload Image")
                          : Text("Uploaded"))),
                  MaterialButton(
                    onPressed: () async{
                      Navigator.pop(context);
                      addStudent(controller.name.text,controller.title.text);
                    },
                    child: const Text("Submit"),
                    color: Colors.red,
                  )
                ],
              ),
            ),
          );
          // FirebaseFirestore.instance.collection('students').add({
          //   'name': 'Sangam',
          //   "title": "sharma",
          //   "image":
          //       "https://cdn.pixabay.com/photo/2019/03/03/08/25/rabbit-4031334_960_720.png"
          // });
        },
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('students').snapshots(),
          builder:
              //(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              //padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
             // children: snapshot.data!.docs.map((e)
                itemCount: snapshot.data!.docs.length, // error
                itemBuilder: (BuildContext context, int index)
              {
                DocumentSnapshot ds =
                snapshot.data!.docs[index];
              //  log("E ius ${e["name"]}");
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      FirebaseFirestore.instance.collection('students').doc(ds.id).delete();
                      //ds[index].removeAt(snapshot.data);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  child: Card(
                    elevation: 5,
                    child: CheckboxListTile(
                      title: Text(ds["name"].toUpperCase()),
                      value: valuefirst,
                      onChanged: (value) {
                        setState(() {
                          valuefirst = value!;

                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                );
              });

          }),
    );
  }
}
