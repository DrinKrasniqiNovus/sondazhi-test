import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleQuestion extends StatefulWidget {
  SingleQuestion({Key? key, this.questions, @required this.index, this.id})
      : super(key: key);
  List? questions;
  final id;
  var index;
  @override
  State<SingleQuestion> createState() => _SingleQuestionState();
}

class _SingleQuestionState extends State<SingleQuestion> {
  final sondazhi = FirebaseFirestore.instance.collection('sondazhet');
  List<TextEditingController> optionsControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> questionsControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> label = [
    TextEditingController(),
  ];
  int nrOpcionit = 0;

  List<Padding> _optionFields(List<TextEditingController> controllers) {
    return List.generate(
      controllers.length,
      (index) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: TextFormField(
          controller: controllers[index],
          obscureText: false,
          decoration: InputDecoration(
            hintText: 'Opsioni ${index + 1}',
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          ),
          keyboardType: TextInputType.name,
          validator: (val) {
            var emptyIndex =
                controllers.indexWhere((controller) => controller.text.isEmpty);
            if (emptyIndex != -1 &&
                emptyIndex < index &&
                val!.trim().isNotEmpty) {
              return 'Fill fileds in order please';
            }

            return null;
          },
        ),
      ),
    );
  }

  List<Padding> _questionFields(List<TextEditingController> controllers) {
    return List.generate(
      controllers.length,
      (index) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: TextFormField(
          controller: controllers[index],
          obscureText: false,
          decoration: const InputDecoration(
            hintText: 'Pyetja',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          ),
          keyboardType: TextInputType.name,
          validator: (val) {
            var emptyIndex =
                controllers.indexWhere((controller) => controller.text.isEmpty);
            if (emptyIndex != -1 &&
                emptyIndex < index &&
                val!.trim().isNotEmpty) {
              return 'Fill fileds in order please';
            }

            return null;
          },
        ),
      ),
    );
  }

  List<Padding> _labelFields(List<TextEditingController> controllers) {
    return List.generate(
      controllers.length,
      (index) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: TextFormField(
          controller: controllers[index],
          obscureText: false,
          decoration: const InputDecoration(
            hintText: 'Label',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          ),
          keyboardType: TextInputType.name,
          validator: (val) {
            var emptyIndex =
                controllers.indexWhere((controller) => controller.text.isEmpty);
            if (emptyIndex != -1 &&
                emptyIndex < index &&
                val!.trim().isNotEmpty) {
              return 'Fill fileds in order please';
            }

            return null;
          },
        ),
      ),
    );
  }

  redo() {
    nrOpcionit = optionsControllers.length;
    label.first =
        TextEditingController(text: widget.questions![widget.index]['label']);
    questionsControllers = List.generate(
        (widget.questions![widget.index]['question'] as List).length,
        (index) => TextEditingController(
            text: widget.questions![widget.index]['question'][index]['text']));
    optionsControllers = List.generate(
        (widget.questions![widget.index]['options'] as List).length,
        (index) => TextEditingController(
            text: widget.questions![widget.index]['options'][index]['text']));
  }

  getNextId() {
    int nextId = 0;
    for (var i = 0; i < widget.questions!.length; i++) {
      print('forenter');
      print(widget.questions![i]);
      print('========================================');
      if (widget.questions![i]['type'] == 'MS') {
        var msId =
            double.parse((widget.questions![i]['question'] as List)[0]['id'][0])
                .toInt();
        if (nextId < msId) {
          nextId = msId;
        }
      } else {
        var otherId =
            double.parse(widget.questions![i]['question'][0]['id']).toInt();
        if (nextId < otherId) {
          nextId = otherId;
        }
      }
    }
    return (nextId).toString();
  }

  String type = '';

  @override
  void initState() {
    type = widget.questions![widget.index]['type'];

    redo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: Key(widget.index.toString()),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        automaticallyImplyLeading: false,
        title: Text('Pyetja ${widget.index + 1}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _labelFields(label),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.63,
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _questionFields(questionsControllers),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.questions![widget.index]['type'] == 'GS',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(52, 72, 172, 2),
                            ),
                            child: const Text('Shto Pyetje Grid'),
                            onPressed: () {
                              setState(() {
                                questionsControllers
                                    .add(TextEditingController());
                              });
                            },
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(52, 72, 172, 2),
                            ),
                            child: const Text('Fshi Pyetje Grid'),
                            onPressed: () {
                              setState(() {
                                questionsControllers.length == 1
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Nuk mund te kesh me pak se 1 pyetje'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      )
                                    : questionsControllers.removeLast();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 500,
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _optionFields(optionsControllers),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(52, 72, 172, 2),
                      ),
                      onPressed: () {
                        setState(() {
                          optionsControllers.add(TextEditingController());
                          nrOpcionit++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Shto Opsion'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(52, 72, 172, 2),
                      ),
                      onPressed: () {
                        setState(() {
                          optionsControllers.removeLast();
                          nrOpcionit--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('Fshi Opsion'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              width: 200,
              height: 600,
              child: ListView.builder(
                  itemCount: widget.questions!.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        tileColor: const Color.fromRGBO(52, 72, 172, 2),
                        onTap: () {
                          setState(() {
                            widget.index = index;
                            redo();
                          });
                        },
                        title: Text(
                          ('${widget.questions![index]['label']}'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 200,
            child: Row(
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: (Colors.blue)),
                    onPressed: () {
                      setState(() {
                        if (widget.index == 0) {
                          widget.index = widget.questions!.length - 1;
                        } else {
                          widget.index--;
                        }
                      });
                      redo();
                    },
                    icon: const Icon(Icons.navigate_before),
                    label: const Text('Back')),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: (Colors.green)),
                    onPressed: () async {
                      if (questionsControllers.isNotEmpty &&
                          optionsControllers.isNotEmpty) {
                        widget.questions![widget.index] = {
                          'question': questionsControllers
                              .map((e) => {
                                    'text': e.text,
                                    'id': getNextId(),
                                  })
                              .toList(),
                          'options': optionsControllers
                              .map((e) => {
                                    'text': e.text,
                                    'value': optionsControllers.indexOf(e) + 1
                                  })
                              .toList(),
                          'type': widget.questions![widget.index]['type'],
                          'flow': widget.questions![widget.index]['flow'],
                          'label': label.first.text,
                        };
                        await sondazhi.doc(widget.id).update(
                            {'questions': widget.questions}).then((value) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pyetja u ruajt'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ruaj'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: (Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Anulo')),
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: (Colors.blue)),
                    onPressed: () {
                      setState(() {
                        if (widget.index < widget.questions!.length - 1) {
                          widget.index++;
                        } else {
                          widget.index = 0;
                        }
                      });
                      redo();
                    },
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('Next')),
                Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Kthehu')),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
