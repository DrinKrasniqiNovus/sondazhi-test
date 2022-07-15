import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sondazhi/add_notifications.dart';
import 'package:sondazhi/edit/pyetjet_page.dart';
import 'package:sondazhi/title_page.dart';
import 'package:intl/intl.dart';

class Sondazhet extends StatefulWidget {
  const Sondazhet({Key? key}) : super(key: key);

  @override
  _SondazhetState createState() => _SondazhetState();
}

var responses;

class _SondazhetState extends State<Sondazhet> {
  getActive(element) {
    if (element == Null) {
      return false;
    }
    return ((DateTime.parse(element['startDate'].toDate().toString()))
            .isBefore(DateTime.now()) &&
        (DateTime.parse(element['endDate'].toDate().toString()))
            .isAfter(DateTime.now()));
  }

  getInactive(element) {
    if (element == Null) {
      return false;
    }
    return ((DateTime.parse(element['endDate'].toDate().toString()))
            .isBefore(DateTime.now()) &&
        !getDraft(element));
  }

  getDraft(element) {
    if (element == Null) {
      return false;
    }
    return (((DateTime.parse(element['endDate'].toDate().toString()))
            .isAtSameMomentAs(
                (DateTime.parse(element['startDate'].toDate().toString())))) ||
        (DateTime.parse(element['startDate'].toDate().toString()))
            .isAfter(DateTime.now()));
  }

  getResponse() async {
    var answers = await FirebaseFirestore.instance.collection('answers').doc().get();
    QuerySnapshot responses = await FirebaseFirestore.instance
        .collection('answers')
        .where('sondazhiId', isEqualTo:sondazhet.id)
        .get();
    print(responses.docs.length);
  }

  var sondazhet = FirebaseFirestore.instance.collection('sondazhet').doc();

  @override
  void initState() {
    getResponse();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNotifications()),
                );
              },
              icon: const Icon(Icons.notifications_rounded)),
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
          title: const Text('Sondazhet'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sondazhet')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> sondazhiSnapshot) {
            if (sondazhiSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final sondazhDocs = sondazhiSnapshot.data!.docs;
            List active =
                sondazhDocs.where((element) => getActive(element)).toList();
            List inActive =
                sondazhDocs.where((element) => getInactive(element)).toList();
            List draft =
                sondazhDocs.where((element) => getDraft(element)).toList();

            return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      // trailing: Text('Rezultatet:${responses.length}'),
                      tileColor: (index % 2 == 0)
                          ? Colors.blue[100]
                          : Colors.transparent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Pyetjet(id: sondazhDocs[index]['id']),
                          ),
                        );
                      },
                      leading: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Fshij'),
                                  content: const Text(
                                      'A jeni të sigurtë se doni ta fshihni Sondazhin'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('sondazhet')
                                              .doc(sondazhDocs[index]['id'])
                                              .delete()
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Sondazhi-${sondazhDocs[index]['title']}-është fshirë me sukses'),
                                                duration:
                                                    const Duration(seconds: 4),
                                              ),
                                            );
                                          }).then((value) =>
                                                  Navigator.pop(context));
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              });
                        },
                      ),
                      title: Text(
                          '${sondazhDocs[index]['title']} /  ${DateFormat('dd-MM-yyyy').format((sondazhDocs[index]['createdAt'] as Timestamp).toDate())} '),
                      subtitle: Text(
                        active.contains(sondazhDocs[index])
                            ? 'Active'
                            : (inActive.contains(sondazhDocs[index])
                                ? 'Passive'
                                : 'Draft'),
                        style: TextStyle(
                          color: active.contains(sondazhDocs[index])
                              ? Colors.green
                              : (inActive.contains(sondazhDocs[index])
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                      ),
                    );
                  },
                  itemCount: sondazhDocs.length,
                ),
              ),
            ]);
          },
        ),
      ),
      Positioned(
        bottom: 10,
        right: 10,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(52, 72, 172, 2),
          ),
          onPressed: () async {
            await sondazhet.set({
              'startDate': DateTime.now(),
              'endDate': DateTime.now(),
              'createdAt': DateTime.now(),
              'questions': [],
              'title': '',
              'startText': '',
              'endText': '',
              'id': sondazhet.id
            }).then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TitlePage(id: sondazhet.id),
                ),
              ),
            );
          },
          child: const Text('Krijo Sondazhin'),
        ),
      ),
    ]);
  }
}
