import 'package:blog_application/services/db/auth/firebase_auth.dart';
import 'package:blog_application/widget/flutter_toast_custom.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String imgUrl =
      "https://images.unsplash.com/photo-1503220317375-aaad61436b1b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHRyYXZlbHxlbnwwfHwwfHw%3D&w=1000&q=80";
  bool showPassword = false;
  String googleImgLink = "https://blog.hubspot.com/hubfs/image8-2.jpg";

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  authenticate() async {
    if (_formKey.currentState!.validate()) {
      //  send to fire base for auth
      bool success = await FirebaseAuthService().registerUser(
          _email.value.text, _password.value.text, _username.value.text);
      if(mounted && success){
        Navigator.pop(context);
        flutterSuccessMessage("Registered and logged in");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableHome(
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        headerWidget: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
                image: NetworkImage(
                  imgUrl,
                ),
                fit: BoxFit.fill),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Everyday is a new",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Journey",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        body: [
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter username here';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Username"),
                        prefixIcon: Icon(Icons.person)),
                  ),
                  TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter email here';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  TextFormField(
                    controller: _password,
                    obscureText: showPassword,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter email here';
                      }
                    },
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      suffixIcon: InkWell(
                        onTap: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        child: showPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                      prefixIcon: const Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: authenticate,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
