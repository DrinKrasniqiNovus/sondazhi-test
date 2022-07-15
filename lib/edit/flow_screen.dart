import 'package:flutter/material.dart';
import 'package:sondazhi/edit/flow_selection.dart';

class FlowScreen extends StatefulWidget {
  FlowScreen({Key? key, this.questions, this.id, this.index}) : super(key: key);
  List? questions;
  final id;
  final index;
  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  List? questionOptions;
  List flow = [];
  Map<int, List>? flowMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditPage'),
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
      ),
      body: Stack(children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: ListView(children: <Widget>[
              Card(
                color: const Color.fromRGBO(52, 72, 172, 2),
                key: ValueKey(widget.questions![widget.index].toString()),
                elevation: 2,
                child: Column(children: [
                  ListTile(
                    title: Text(
                      (widget.questions![widget.index]['question'] as List)
                          .map((e) => '${e['id']}: ${e['text']}')
                          .join(', ')
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        Column(
                          children: [
                            for (var j = 0;
                                j <
                                    (widget.questions![widget.index]['options']
                                            as List)
                                        .length;
                                j++)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: RadioListTile<String>(
                                    title: Text(
                                      (widget.questions![widget.index]
                                          ['options'][j]['text']),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    value: '1',
                                    groupValue: '0',
                                    onChanged: (String? value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FlowSelectionPage(
                                                  questionIndex: widget.index,
                                                  optionIndex: j,
                                                  id: widget.id,
                                                  allQuestions:
                                                      widget.questions as List),
                                        ),
                                      );
                                    }),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
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
      ]),
    );
  }
}
