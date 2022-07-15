import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FlowSelectionPage extends StatefulWidget {
  FlowSelectionPage(
      {this.questionIndex,
      this.optionIndex,
      this.id,
      @required this.allQuestions});
  final questionIndex;
  final optionIndex;
  final id;
  List? allQuestions;

  @override
  State<FlowSelectionPage> createState() => _FlowSelectionPageState();
}

class _FlowSelectionPageState extends State<FlowSelectionPage> {
  List flow = [];
  List beforeDelete = [];
  List isAdded = [];
  List subList = [];

  List<Widget>? getQuestions() {
    List filterdQuestions =
        widget.allQuestions!.sublist(widget.questionIndex + 1);

    List<Widget> cards =
        List.filled(filterdQuestions.length, const Text('data'));
    cards = [];

    for (var i = 0; i < filterdQuestions.length; i++) {
      var card = Card(
        color: isAdded[i] ? Colors.green : const Color.fromRGBO(52, 72, 172, 2),
        key: ValueKey(filterdQuestions[i].toString()),
        elevation: 2,
        child: SingleChildScrollView(
          child: Column(children: [
            ListTile(
              onTap: () {
                setState(() {
                  isAdded[i] = !isAdded[i];
                  if (isAdded[i] == true) {
                    if (filterdQuestions[i]['type'] == 'MS') {
                      flow.add((filterdQuestions[i]['question'] as List)[0]
                          ['id'][0]);
                    } else {
                      flow.add((filterdQuestions[i]['question'] as List)[0]
                              ['id']
                          .toString());
                    }
                  } else {
                    if (filterdQuestions[i]['type'] == 'MS') {
                      flow.remove((filterdQuestions[i]['question'] as List)[0]
                          ['id'][0]);
                    } else if (filterdQuestions[i]['type'] == 'GS') {
                      flow.remove(
                          (filterdQuestions[i]['question'] as List)[0]['id']);
                    }
                    flow.remove((filterdQuestions[i]['question'] as List)
                        .map((e) => e['id'])
                        .join(', '));
                  }
                });
              },
              leading: Text(
                '${i + 1}',
                style: const TextStyle(color: Colors.white),
              ),
              title: Text(
                (filterdQuestions[i]['question'][0]['text']),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                (filterdQuestions[i]['options'] as List)
                    .map((e) => e['text'])
                    .join(', ')
                    .toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ]),
        ),
      );
      cards.add(card);
    }

    return cards;
  }

  @override
  void initState() {
    subList = widget.allQuestions!.sublist(widget.questionIndex + 1);
    flow = widget.allQuestions!
        .where((element) => (element['flow'] as List)
            .contains('${widget.questionIndex + 1}.${widget.optionIndex + 1}'))
        .map((e) {
      if (e['type'] != 'MS') {
        return e['question'][0]['id'];
      } else {
        return e['question'][0]['id'][0];
      }
    }).toList();

    isAdded = List.generate(subList.length, (index) {
      if (flow.isNotEmpty) {
        if (subList[index]['type'] == 'MS') {
          if (flow
              .contains((subList[index]['question'][0]['id'][0]).toString())) {
            return true;
          }
        }
        if (flow.contains((subList[index]['question'][0]['id']).toString())) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Selection'),
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: ListView(children: getQuestions()!),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 200,
            child: Row(
              children: [
                ...flow
                    .map(
                      (e) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x20000000),
                              offset: Offset(0, 5.5),
                            )
                          ],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFD9D9D9),
                            width: 0.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              children: [
                                const SizedBox(),
                                Text(
                                  '$e',
                                  style: const TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontFamily: 'Pin Display',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: (const Color.fromRGBO(52, 72, 172, 2))),
                    onPressed: () async {
                      for (var i = 0; i < isAdded.length; i++) {
                        String questionOptionIndex =
                            '${widget.questionIndex + 1}.${widget.optionIndex + 1}';

                        if (isAdded[i] == true &&
                            !(subList[i]['flow'] as List)
                                .contains(questionOptionIndex)) {
                          (subList[i]['flow'] as List).add(questionOptionIndex);
                        } else if (isAdded[i] == false) {
                          (subList[i]['flow'] as List)
                              .remove(questionOptionIndex);
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection('sondazhet')
                          .doc(widget.id)
                          .update({'questions': widget.allQuestions}).then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Flow-i eshte ruajtur'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  ));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ruaj Flowin'),
                  ),
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: (Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Anulo')),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(52, 72, 172, 2),
                ),
              ),
              width: 200,
              height: 49,
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
