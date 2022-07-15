import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sondazhi/new_sondazh.dart';

class TitlePage extends StatefulWidget {
  TitlePage({this.id});
  final id;

  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  final sondazhi = FirebaseFirestore.instance.collection('sondazhet');
  TextEditingController titleController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  @override
  void dispose() {
    titleController;
    startController;
    endController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        title: const Text('lajmi.net'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                width: MediaQuery.of(context).size.width * 0.33,
                child: TextField(
                  onChanged: (value) {
                    titleController.text = value;
                  },
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
              textAlign: TextAlign.start,
              onChanged: (value) {
                startController.text = value;
              },
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Texti ne Fillim',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            width: MediaQuery.of(context).size.width * 0.33,
            child: TextField(
              onChanged: (value) {
                endController.text = value;
              },
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
                  primary: const Color.fromRGBO(52, 72, 172, 2),
                ),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      startController.text.isNotEmpty &
                          endController.text.isNotEmpty) {
                    await sondazhi.doc(widget.id).update({
                      'title': titleController.text,
                      'startText': startController.text,
                      'endText': endController.text
                    }).then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewSondazh(
                                    id: widget.id,
                                  )));
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ju lutem plotësoni te gjitha fushat'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('Vazhdo tek pyetjet'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
