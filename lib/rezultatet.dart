import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:universal_html/html.dart" as html;

class Rezultatet extends StatefulWidget {
  Rezultatet({Key? key, @required this.id});
  final id;
  @override
  State<Rezultatet> createState() => _RezultatetState();
}

class _RezultatetState extends State<Rezultatet> {
  List<List<String>> itemlist = [];
  Stream<QuerySnapshot>? streamQuery;
  @override
  void initState() {
    streamQuery = FirebaseFirestore.instance
        .collection('answers')
        .where('sondazhiId', isEqualTo: widget.id)
        .snapshots();
    super.initState();
  }

  generateCsv() async {
    String csvData = const ListToCsvConverter().convert(itemlist);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('paM-dd-yyyy-HH-mm-ss').format(now);
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'item_export_$formattedDate.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
          title: const Text('Rezultatet'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: streamQuery,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var answers = snapshot.data!.docs;

              var questionsIDs =
                  (answers[0]['answers']['answer'] as Map).keys.toList();
              questionsIDs.sort();

              itemlist = [
                <String>[
                  'userId',
                  ...questionsIDs,
                ],
              ];
              for (var i = 0; i < answers.length; i++) {
                var answersValues = [];
                for (var j = 0; j < questionsIDs.length; j++) {
                  answersValues.add((answers[i]['answers']['answer']
                      as Map)[questionsIDs[j]]);
                }
                itemlist.add([
                  answers[i]['userId'],
                  ...answersValues,
                ]);
              }

              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return const Card(
                              child: ListTile(
                                title: Text(
                                  'TeDhenat',
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            generateCsv();
          },
          child: const Icon(Icons.download),
        ));
  }
}
