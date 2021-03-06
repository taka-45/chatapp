// ログイン画面用Widget
import 'package:chatapp/talkroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  }),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(infoText),
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final result =
                            await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(result.user?.uid)
                            .set({
                          'userId': result.user?.uid,
                          'name': "No Name",
                          'user': "",
                        });

                        await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return TalkRoomPage(result.user!);
                        }));
                      } catch (e) {
                        setState(() {
                          infoText = "登録に失敗しました: ${e.toString()}";
                        });
                      }
                    },
                  )),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                    child: Text("ログイン"),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final result = await auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return TalkRoomPage(result.user!);
                          }),
                        );
                      } catch (e) {
                        setState(() {
                          infoText = "ログインに失敗しました：${e.toString()}";
                        });
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
