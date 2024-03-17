import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'camera_stream.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

late List<CameraDescription> cameras;
AuthService authService = AuthService();

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool pressedbutton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pressedbutton == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  pressedbutton = !pressedbutton;
                });
                final message = await authService.registration(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                if (message!.contains('Success')) {
                  cameras = await availableCameras();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CameraApp(
                            cameras: cameras,
                          )));
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
                setState(() {
                  pressedbutton = false;
                });
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
