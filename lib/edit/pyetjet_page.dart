import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sondazhi/edit/flow_screen.dart';
import 'package:sondazhi/edit/single_question_edit.dart';
import 'package:sondazhi/rezultatet.dart';

import 'konfiguro_page.dart';

class Pyetjet extends StatefulWidget {
  Pyetjet({this.id});

  final id;

  @override
  _PyetjetState createState() => _PyetjetState();
}

int index = 0;

class _PyetjetState extends State<Pyetjet> {
  bool isDelete = false;
  bool isFlowSelected = false;
  List orderQuestions = [5, 1, 4, 3, 6];
  List questions = [];
  getNextId() {
    int nextId = 0;
    for (var i = 0; i < questions.length; i++) {
      print('forenter');
      print(questions[i]);
      print('========================================');
      if (questions[i]['type'] == 'MS') {
        var msId = double.parse((questions[i]['question'] as List)[0]['id'][0])
            .toInt();
        if (nextId < msId) {
          nextId = msId;
        }
      } else {
        var otherId = double.parse(questions[i]['question'][0]['id']).toInt();
        if (nextId < otherId) {
          nextId = otherId;
        }
      }
    }
    return (nextId + 1).toString();
  }

  questionsList() async {
    var sondazhi = await FirebaseFirestore.instance
        .collection('sondazhet')
        .where('id', isEqualTo: widget.id)
        .get();
    setState(() {
      questions = sondazhi.docs.first['questions'];
    });
  }

  void reorderData(int oldindex, int newindex) async {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      questions.forEach((element) {
        element['flow'] = [];
      });
      final question = questions.removeAt(oldindex);
      questions.insert(newindex, question);
    });

    FirebaseFirestore.instance
        .collection('sondazhet')
        .doc(widget.id)
        .update({'questions': questions});
  }

  void sorting() {
    setState(() {
      questions.sort();
    });
  }

  @override
  void initState() {
    questionsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        automaticallyImplyLeading: false,
        title: const Text('EditPage'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: ReorderableListView(
                children: <Widget>[
                  for (var i = 0; i < questions.length; i++)
                    Card(
                      color: const Color.fromRGBO(52, 72, 172, 2),
                      key: ValueKey(questions[i].toString()),
                      elevation: 2,
                      child: ListTile(
                          title: Text(
                            (questions[i]['question'] as List)
                                .map((e) => '${e['id']}: ${e['text']}')
                                .join(', ')
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            (questions[i]['options'] as List)
                                .map((e) => e['text'])
                                .join(', ')
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: isFlowSelected == false
                              ? isDelete == true
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          questions.removeAt(i);
                                        });
                                        FirebaseFirestore.instance
                                            .collection('sondazhet')
                                            .doc(widget.id)
                                            .update({'questions': questions});
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red))
                                  : IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleQuestion(
                                              index: i,
                                              questions: questions,
                                              id: widget.id,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )
                              : isDelete == true
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          questions.removeAt(i);
                                        });
                                        FirebaseFirestore.instance
                                            .collection('sondazhet')
                                            .doc(widget.id)
                                            .update({'questions': questions});
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red))
                                  : IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FlowScreen(
                                                      questions: questions,
                                                      id: widget.id,
                                                      index: i,
                                                    )));
                                      },
                                      icon: const Icon(Icons.fast_forward),
                                      color: Colors.white,
                                    )),
                    ),
                ],
                onReorder: reorderData,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height * 0.70,
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
                  ListTile(
                    tileColor: const Color.fromRGBO(52, 72, 172, 2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Konfiguro(id: widget.id),
                        ),
                      );
                    },
                    title: const Text(
                      'Konfiguro',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    tileColor: const Color.fromRGBO(52, 72, 172, 2),
                    onTap: () {
                      setState(() {
                        isFlowSelected = false;
                      });
                    },
                    title: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                      tileColor: const Color.fromRGBO(52, 72, 172, 2),
                      onTap: () {
                        setState(() {
                          isFlowSelected = true;
                        });
                      },
                      title: const Text(
                        'Flow',
                        style: TextStyle(color: Colors.white),
                      )),
                  ListTile(
                    tileColor: const Color.fromRGBO(52, 72, 172, 2),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Rezultatet(id: widget.id),
                        ),
                      );
                    },
                    title: const Text(
                      'Rezultatet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(52, 72, 172, 2),
                  ),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Shto Pyetje'),
                            content: const Text('Zgjedhni llojin e pyetjes'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      questions.add({
                                        'question': [
                                          {'id': getNextId(), 'text': ''}
                                        ],
                                        'flow': [],
                                        'label': '',
                                        'options': [
                                          {'value': 1, 'text': ''},
                                          {'value': 2, 'text': ''}
                                        ],
                                        'type': 'SS'
                                      });
                                      FirebaseFirestore.instance
                                          .collection('sondazhet')
                                          .doc(widget.id)
                                          .update({'questions': questions})
                                          .then(
                                              (value) => Navigator.pop(context))
                                          .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleQuestion(
                                                    index: questions.length - 1,
                                                    questions: questions,
                                                    id: widget.id,
                                                  ),
                                                ),
                                              ));
                                    });
                                  },
                                  child: const Text('SS')),
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      questions.add({
                                        'question': [
                                          {'id': getNextId(), 'text': ''}
                                        ],
                                        'flow': [],
                                        'label': '',
                                        'options': [
                                          {'value': 1, 'text': ''},
                                          {'value': 2, 'text': ''}
                                        ],
                                        'type': 'MS'
                                      });
                                      FirebaseFirestore.instance
                                          .collection('sondazhet')
                                          .doc(widget.id)
                                          .update({
                                        'questions': questions
                                      }).then((value) =>
                                              Navigator.pop(context));
                                    });
                                  },
                                  child: const Text('MS')),
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      questions.add({
                                        'question': [
                                          {'id': getNextId(), 'text': ''}
                                        ],
                                        'flow': [],
                                        'label': '',
                                        'options': [
                                          {'value': 1, 'text': ''},
                                          {'value': 2, 'text': ''}
                                        ],
                                        'type': 'GS'
                                      });
                                      FirebaseFirestore.instance
                                          .collection('sondazhet')
                                          .doc(widget.id)
                                          .update({
                                        'questions': questions
                                      }).then((value) =>
                                              Navigator.pop(context));
                                    });
                                  },
                                  child: const Text('GS'))
                            ],
                          );
                        });
                  },
                  child: const Text('Shto Pyetje te re'),
                ),
                TextButton.icon(
                    icon: Icon(isDelete
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        isDelete = !isDelete;
                      });
                    },
                    label: const Text('Delete'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
