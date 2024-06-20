import 'package:flutter/material.dart';
import 'HomePage.dart'; // Mengimpor halaman HomePage
import 'HistoryPage.dart'; // Mengimpor halaman HistoryPage
import 'MyOrderPage.dart'; // Mengimpor halaman MyOrderPage
import 'api_service.dart'; // Impor file api_service.dart
import 'CheckoutPage.dart'; // Mengimpor halaman CheckoutPage
import 'PaymentStatusPage.dart'; // Mengimpor halaman PaymentStatusPage

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Laundry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), 
      home: GetStartedPage(),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/history': (context) => HistoryPage(),
        '/myorder': (context) => MyOrderPage(
          totalPrice: 0,
          alamat: '',
          jadwalJemput: DateTime.now(),
          waktuPenjemputan: '',
          quantity: 0,
          name: '',
          serviceId: 0,
          paymentStatus: '',
          orderId: '',
          Id: 0,
        ),
        '/checkout': (context) => CheckoutPage( // Tambahkan route untuk halaman CheckoutPage
          totalPrice: 0,
          alamat: '',
          jadwalJemput: DateTime.now(),
          waktuPenjemputan: '',
          quantity: 0,
          name: '',
          serviceId: 0,
          payment_status: '',
          orderId: '',
          Id: 0,
        ),
        '/payment-status': (context) => PaymentStatusPage( // Tambahkan route untuk halaman PaymentStatusPage
          totalPrice: 0,
          alamat: '',
          jadwalJemput: DateTime.now(),
          waktuPenjemputan: '',
          quantity: 0,
          name: '',
          serviceId: 0,
          paymentStatus: '',
          orderId: '',
          Id: 0,
        ),
      },
    );
  }
}

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  bool _isLoginPanelVisible = false;
  bool _isRegisterPanelVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1E9E1),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 4),
                Image.asset(
                  'assets/logos/logo.png',
                  height: 200,
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    'Get ready to make your life easy with single click of app, which makes laundry things handle better',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF986E39),
                    ),
                  ),
                ),
                Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Color(0xFF986E39),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoginPanelVisible = true;
                        });
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          if (_isLoginPanelVisible || _isRegisterPanelVisible)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLoginPanelVisible = false;
                  _isRegisterPanelVisible = false;
                });
              },
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          Positioned(
            bottom: _isLoginPanelVisible || _isRegisterPanelVisible
                ? 0
                : -MediaQuery.of(context).size.height * 3 / 4,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _isLoginPanelVisible || _isRegisterPanelVisible
                  ? MediaQuery.of(context).size.height * 3 / 4
                  : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: _isLoginPanelVisible
                  ? LoginPageContent(
                      onRegisterTap: () {
                        setState(() {
                          _isLoginPanelVisible = false;
                          _isRegisterPanelVisible = true;
                        });
                      },
                      onLoginSuccess: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    )
                  : _isRegisterPanelVisible
                      ? RegisterPage(
                          onLoginTap: () {
                            setState(() {
                              _isLoginPanelVisible = true;
                              _isRegisterPanelVisible = false;
                            });
                          },
                        )
                      : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPageContent extends StatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;

  LoginPageContent({required this.onRegisterTap, required this.onLoginSuccess});

  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    // Panggil fungsi loginUser untuk melakukan login
    bool loginSuccess = await loginUser(_emailController.text, _passwordController.text);

    if (loginSuccess) {
      // Login sukses, arahkan ke halaman beranda (HomePage)
      widget.onLoginSuccess();
    } else {
      // Login gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Gagal'),
          content: Text('Email atau Password salah'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF986E39),
              ),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          SizedBox(height: 100),
          Padding(
            padding: EdgeInsets.only(right: 180.0),
            child: Text(
              'Lupa kata sandi?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF986E39),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Color(0xFF986E39),
                ),
                onPressed: _login,
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: GestureDetector(
              onTap: widget.onRegisterTap,
              child: Text.rich(
                TextSpan(
                  text: 'Belum punya akun? ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Yuk Daftar!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF986E39),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  RegisterPage({required this.onLoginTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  void _register() async {
    // Logika registrasi di sini
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registrasi Gagal'),
          content: Text('Kata sandi tidak cocok'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    bool registerSuccess = await registerUser(_nameController.text , _emailController.text, _phoneController.text, _passwordController.text);

    if (registerSuccess) {
      // Registrasi sukses, arahkan ke halaman login
      widget.onLoginTap();
    } else {
      // Registrasi gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registrasi Gagal'),
          content: Text('Terjadi kesalahan, silakan coba lagi'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF986E39),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Masukkan Nama Anda'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Masukkan Alamat E-mail'),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Masukkan Nomor Handphone'),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Masukkan Kata Sandi'),
              obscureText: true,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Ulangi Kata Sandi'),
              obscureText: true,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: _agreeToTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _agreeToTerms = value!;
                  });
                },
              ),
              Text('Saya menyetujui syarat dan ketentuan'),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Color(0xFF986E39),
                ),
                onPressed: _agreeToTerms ? _register : null,
                child: Text(
                  'Buat Akun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: GestureDetector(
              onTap: widget.onLoginTap,
              child: Text.rich(
                TextSpan(
                  text: 'Sudah punya akun? ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Yuk Masuk!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF986E39),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
