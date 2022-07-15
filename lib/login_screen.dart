import 'package:flutter/material.dart';
import 'package:sondazhi/sondazhet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String user1 = 'NovusAdmin';
  String user2 = 'LajmiAdmin';
  String pass1 = '1312';
  String pass2 = '1313';
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(52, 72, 172, 2),
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width * 0.33,
              child: TextField(
                textAlign: TextAlign.start,
                onChanged: (value) {
                  userController.text = value;
                },
                maxLines: 1,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'User'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              width: MediaQuery.of(context).size.width * 0.33,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  passController.text = value;
                },
                maxLines: 1,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(52, 72, 172, 2),
              ),
              onPressed: () {
                if ((userController.text == user1 &&
                        passController.text == pass1) ||
                    (userController.text == user2 &&
                        passController.text == pass2)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Sondazhet(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Useri ose Passwordi nuk jane te sakte. Provo perseri'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
