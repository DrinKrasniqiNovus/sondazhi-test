import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Konfiguro extends StatefulWidget {
  Konfiguro({Key? key, this.id}) : super(key: key);
  final id;
  @override
  State<Konfiguro> createState() => _KonfiguroState();
}

class _KonfiguroState extends State<Konfiguro> {
  var textet;
  final sondazhi = FirebaseFirestore.instance.collection('sondazhet');
  TextEditingController titleController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  DateTime? start;
  DateTime? end;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  Future<Map<String, dynamic>> getSondazhi() async {
    var textResponse = await FirebaseFirestore.instance
        .collection('sondazhet')
        .doc(widget.id)
        .get();

    return textResponse.data()!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        automaticallyImplyLeading: false,
        title: const Text('EditPage'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0.0),
                            prefixIcon: const Icon(
                              Icons.date_range,
                              color: Colors.black,
                              size: 18,
                            ), //icon of text field
                            labelText: "Select Start Date",
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          controller: startDate,
                          onChanged: (value) {
                            startDate.text = value;
                          },
                          onSaved: (value) {
                            startDate.text = value!;
                          },
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                String formattedDate =
                                    DateFormat.yMMMd().format(date).toString();
                                setState(() {
                                  start = date;
                                  startDate.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0.0),
                          prefixIcon: const Icon(
                            Icons.date_range,
                            color: Colors.black,
                            size: 18,
                          ),
                          labelText: "Select End Date",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),

                        controller: endDate,
                        onChanged: (value) {
                          endDate.text = value;
                        },
                        onSaved: (value) {
                          endDate.text = value!;
                        },
                        readOnly:
                            false, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (date) {
                              String formattedDate =
                                  DateFormat.yMMMd().format(date).toString();
                              setState(() {
                                end = date;
                                endDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            },
                            currentTime: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: (Colors.green)),
                      onPressed: () async {
                        if (startDate.text.isNotEmpty &&
                            endDate.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('sondazhet')
                              .doc(widget.id)
                              .update(
                                  {'startDate': start, 'endDate': end}).then(
                            (value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sondazhi ndryshoj daten'),
                                duration: Duration(seconds: 2),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Ruaj'),
                    ),
                  ],
                ),
                FutureBuilder<Map<String, dynamic>>(
                    future: getSondazhi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        titleController = TextEditingController(
                            text: snapshot.data!['title']);
                        startController = TextEditingController(
                            text: snapshot.data!['startText']);
                        endController = TextEditingController(
                            text: snapshot.data!['endText']);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 50,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  child: TextField(
                                    controller: titleController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Emri i sondazhit',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 50,
                              ),
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: TextField(
                                controller: startController,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Texti ne Fillim',
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 50, bottom: 50),
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: TextField(
                                controller: endController,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Texti ne fund',
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await sondazhi.doc(widget.id).update({
                                      'title': titleController.text,
                                      'startText': startController.text,
                                      'endText': endController.text
                                    }).then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Titulli,Start Text dhe End Text u ruajten'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text('Ruaj'),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }
                    }),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.10,
              height: MediaQuery.of(context).size.width * 0.10,
              child: ListView(
                children: [
                  ListTile(
                    tileColor: const Color.fromRGBO(52, 72, 172, 2),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      'Kthehu',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
