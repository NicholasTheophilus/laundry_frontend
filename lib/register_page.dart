import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Nomor Handphone'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Buat Sandi'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Ulangi Sandi'),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text('Saya menyetujui syarat dan ketentuan'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _termsAccepted
                  ? () {
                      // Logika register di sini
                    }
                  : null,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
