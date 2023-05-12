import 'package:blog_application/services/db/auth/firebase_auth.dart';
import 'package:blog_application/widget/flutter_toast_custom.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String imgUrl =
      "https://images.unsplash.com/photo-1503220317375-aaad61436b1b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHRyYXZlbHxlbnwwfHwwfHw%3D&w=1000&q=80";
  bool showPassword = false;
  String googleImgLink = "https://blog.hubspot.com/hubfs/image8-2.jpg";

  final TextEditingController _email = TextEditingController(text: "test@email.com");
  final TextEditingController _password = TextEditingController(text: "helloworld");

  authenticate() async {
    if (_formKey.currentState!.validate()) {
      //  send to fire base for auth
      bool success = await FirebaseAuthService()
          .loginUser(_email.value.text, _password.value.text);
      if (!success) {
        flutterFailMessage("Email or password wrong");
      }else{
        flutterSuccessMessage("User logged in");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableHome(
        title: const Text(
          "Login",
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
                    "Login",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
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
                    obscureText: !showPassword,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter password here';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      suffixIcon: InkWell(
                        onTap: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        child: !showPassword
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
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text("Register"))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
        bottomSheet: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.network(googleImgLink, height: 15, width: 15, fit: BoxFit.contain,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        googleImgLink,
                      ),
                      maxRadius: 14,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ))),
      ),
    );
  }
}
