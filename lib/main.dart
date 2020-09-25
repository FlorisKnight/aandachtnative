import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.

class MyApp extends StatelessWidget {
  static const String _title = 'Aandacht notificatie app';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
          // Define the default brightness and colors.
          primaryColor: Colors.deepOrange[400],
          accentColor: Colors.red[300],

          // Define the default font family.
          fontFamily: 'Montserrat'),
      home: MainWidget(),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void openPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Setup'),
        ),
        body: SetupForm(),
      );
    },
  ));
}

/// This is the stateless widget that the main application instantiates.
class MainWidget extends StatelessWidget {
  MainWidget({Key key}) : super(key: key);
  List<String> messages = [
    'Aandacht!',
    'I want hugs!',
    'I want kisses!',
    'Cuddles?',
    'I love you!',
    'Love me!',
    'Psssst!',
    'I can see you...',
    'I am sad :(',
    'Food?',
    'Send nudes',
    'Can I has some coochie?',
    'Can I has some dick?',
    'I want smash',
    'Proud of you!',
    'You okay?',
    'Toilet paper?',
    'I shat myself again...',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Aandacht!',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              openPage(context);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: [
              for (var i in messages)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: ButtonTheme(
                    height: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        try {
                          prefs.getString('username');
                          prefs.getString('friendtoken');

                          Scaffold.of(context).showSnackBar(
                              SnackBar(duration: const Duration(milliseconds: 1000), content: Text('Message sent!')));
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1000),
                              content: Text(
                                  'There was a problem sending the message')));
                        }
                      },
                      color: Colors.white,
                      child: Text(
                        i,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupForm extends StatefulWidget {
  @override
  SetupFormState createState() {
    return SetupFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SetupFormState extends State<SetupForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final username = TextEditingController();
    final friendtoken = TextEditingController();

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(children: <Widget>[
            Text(
              'Setup',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            TextField(
              controller: friendtoken,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Friend token',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: RaisedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('username', username.text);
                          prefs.setString('friendtoken', friendtoken.text);

                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            Scaffold.of(context).showSnackBar(
                                SnackBar(duration: const Duration(milliseconds: 1000), content: Text('Changes submitted')));
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();

                          ClipboardManager.copyToClipBoard(
                              prefs.getString('token'));
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            Scaffold.of(context).showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 1000),
                                content: Text('Token copied to clipboard')));
                          }
                        },
                        child: Text('Get Token'),
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}