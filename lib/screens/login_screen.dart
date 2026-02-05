import 'package:flutter/material.dart';
import 'package:flutter_intern_project/screens/homescreen.dart';
import 'package:flutter_intern_project/sevices/auth_services.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = AuthServices();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form( key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Login',
                style: GoogleFonts.acme(),
                      textScaler: const TextScaler.linear(3),),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() {                          
                        }),
                        controller: email,
                        decoration: InputDecoration(
                          label: Text('Email'),
                          hintText: 'Enter your Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      Text('Please enter your password');
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {                   
                  }),
                  controller: password,
                  decoration: InputDecoration(
                    label: Text('Password'),
                    hintText: "Enter your password",
                    border: OutlineInputBorder(),
                  ),
                ),
                ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.pink[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    // color: Colors.brown[400],
                                  )
                                : Text(
                                    'Log In',
                                    style: GoogleFonts.acme(
                                       color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 80,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text('Dont have already account!!'),
                                TextButton(
                                  onPressed: _signup,
                                  child: Text(
                                    'Create a new account!!',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                         ElevatedButton(
                            onPressed: isLoading ? null : _googleSignInaccount,
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                                    'Continue with Google',
                                    style: GoogleFonts.acme(
                                       color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                          ), 
              ],
          )),
        )),
    );
  }

Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      final user = await auth.signIn(
        email.text.trim(),
        password.text.trim(),
      );

      if (user != null) {
        // Navigate to home
        // ignore: use_build_context_synchronously
        await Navigator.push(context, MaterialPageRoute(builder: (context)=> Homescreen()));
      }
    } catch (e) {
      throw(e.toString());
    }
    setState(() => isLoading = false);
  }

  Future<void> _signup() async {
    setState(() => isLoading = true);
    try {
      await auth.signUp(
        email.text.trim(),
        password.text.trim(),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));
    } catch (e) {
      _showError(e.toString());
    }
    setState(() => isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  Future<void> _googleSignInaccount() async{
     try {
      final user = await auth.signInWithGoogle();
      if(!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Homescreen(),
          ),
        );
      }
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

}