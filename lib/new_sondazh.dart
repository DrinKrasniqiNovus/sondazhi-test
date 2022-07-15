import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sondazhi/sondazhet.dart';

class NewSondazh extends StatefulWidget {
  NewSondazh({this.id});
  final id;

  @override
  _NewSondazhState createState() => _NewSondazhState();
}

class _NewSondazhState extends State<NewSondazh> {
  final sondazhi = FirebaseFirestore.instance.collection('sondazhet');
  int nrOpsionet = 2;
  bool isSelectedSingle = false;
  bool isSelectedMultiple = false;
  bool isSelectedGrid = false;

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
  int nrPytjes = 1;
  int nrOpcionit = 2;
  String type = '';

  typeFunction(type, e) {
    if (type == 'GS') {
      return '$nrPytjes.${questionsControllers.indexOf(e) + 1}';
    } else if (type == 'SS') {
      return '$nrPytjes';
    } else {
      return optionsControllers
          .map((j) => '$nrPytjes.${optionsControllers.indexOf(j) + 1}')
          .toList();
    }
  }

  @override
  void dispose() {
    questionsControllers;
    optionsControllers;
    super.dispose();
  }

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
          decoration: InputDecoration(
            hintText: 'Pyetja$nrPytjes',
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
          title: const Text('lajmi.net '),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: isSelectedSingle == true ||
                      isSelectedMultiple == true ||
                      isSelectedGrid == true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.63,
                            child: Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _labelFields(label),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                        ],
                      ),
                      Visibility(
                        visible: isSelectedGrid == true,
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
                        width: MediaQuery.of(context).size.width * 0.33,
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _optionFields(optionsControllers),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: (isSelectedGrid ||
                        isSelectedMultiple ||
                        isSelectedSingle),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(52, 72, 172, 2),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Kthehu tek titulli'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(52, 72, 172, 2),
                              ),
                              onPressed: () {
                                setState(() {
                                  optionsControllers
                                      .add(TextEditingController());
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
                                  optionsControllers.length == 2
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Nuk mund te kesh me pak se 2 opsione'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        )
                                      : optionsControllers.removeLast();
                                  nrOpcionit--;
                                });
                              },
                              icon: const Icon(Icons.remove),
                              label: const Text('Fshi Opsione'),
                            ),
                          ),
                        ])),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isSelectedSingle == false) {
                          setState(() {
                            isSelectedSingle = true;
                            questionsControllers.clear();
                            questionsControllers.add(TextEditingController());
                            isSelectedMultiple = false;
                            isSelectedGrid = false;
                            type = 'SS';
                          });
                        } else {
                          setState(() {
                            isSelectedSingle = false;
                          });
                        }
                      },
                      icon: isSelectedSingle == true
                          ? const Icon(Icons.radio_button_checked)
                          : const Icon(Icons.radio_button_off),
                    ),
                    const Text('Single selection'),
                    IconButton(
                      onPressed: () {
                        if (isSelectedMultiple == false) {
                          setState(() {
                            isSelectedSingle = false;
                            isSelectedMultiple = true;
                            questionsControllers.clear();
                            questionsControllers.add(TextEditingController());
                            isSelectedGrid = false;
                            type = 'MS';
                          });
                        } else {
                          setState(() {
                            isSelectedMultiple = false;
                          });
                        }
                      },
                      icon: isSelectedMultiple == true
                          ? const Icon(Icons.radio_button_checked)
                          : const Icon(Icons.radio_button_off),
                    ),
                    const Text('Multiple selection'),
                    IconButton(
                      onPressed: () {
                        if (isSelectedGrid == false) {
                          setState(() {
                            isSelectedSingle = false;
                            isSelectedMultiple = false;
                            isSelectedGrid = true;
                            questionsControllers.clear();
                            questionsControllers.add(TextEditingController());
                            type = 'GS';
                          });
                        } else {
                          setState(() {
                            isSelectedGrid = false;
                          });
                        }
                      },
                      icon: isSelectedGrid == true
                          ? const Icon(Icons.radio_button_checked)
                          : const Icon(Icons.radio_button_off),
                    ),
                    const Text('Grid Selection'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 200,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: (Colors.green)),
          onPressed: () async {
            if (questionsControllers
                    .every((element) => element.text.isNotEmpty) &&
                optionsControllers
                    .every((element) => element.text.isNotEmpty)) {
              await sondazhi.doc(widget.id).update({
                'questions': FieldValue.arrayUnion([
                  {
                    'question': questionsControllers
                        .map((e) => {
                              'text': e.text,
                              'id': typeFunction(type, e),
                            })
                        .toList(),
                    'label': label.first.text,
                    'type': type,
                    'flow': [],
                    'options': optionsControllers
                        .map((e) => {
                              'text': e.text,
                              'value': optionsControllers.indexOf(e) + 1
                            })
                        .toList()
                  }
                ])
              }).then((value) {
                nrPytjes++;
                questionsControllers.clear();
                questionsControllers.add(TextEditingController());
                optionsControllers.clear();
                optionsControllers.add(TextEditingController());
                optionsControllers.add(TextEditingController());
                label.clear();
                label.add(TextEditingController());

                setState(() {
                  isSelectedSingle = false;
                  isSelectedMultiple = false;
                  isSelectedGrid = false;
                  type = '';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pyetja ${nrPytjes - 1} u shtua'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ju lutem mbushni te gjitha fushat '),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Ruaj dhe shto'),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: (const Color.fromRGBO(52, 72, 172, 2))),
          onPressed: () async {
            if (questionsControllers
                    .every((element) => element.text.isNotEmpty) &&
                optionsControllers
                    .every((element) => element.text.isNotEmpty)) {
              await sondazhi.doc(widget.id).update({
                'questions': FieldValue.arrayUnion([
                  {
                    'question': questionsControllers
                        .map((e) => {
                              'text': e.text,
                              'id': typeFunction(type, e),
                            })
                        .toList(),
                    'label': label.first.text,
                    'type': type,
                    'flow': [],
                    'options': optionsControllers
                        .map((e) => {
                              'text': e.text,
                              'value': optionsControllers.indexOf(e) + 1
                            })
                        .toList()
                  }
                ])
              }).then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Sondazhet(),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pyetja e fundit u shtua'),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ju lutem mbushni te gjitha fushat '),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          icon: const Icon(Icons.done),
          label: const Text('Ruaj dhe përfundo'),
        ),
      ),
    ]);
  }
}
