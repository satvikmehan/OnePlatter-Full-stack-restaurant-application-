import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:onebanc_application/authentication/login_screen.dart';
import 'package:onebanc_application/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isChecked=false;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon:Icon(Icons.arrow_back,color: Colors.white70,),
          onPressed: ()
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen())
            );
          }
        )
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Let’s create your account",style:TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color:Color(0xFFF6F6F6)),
              ),
              SizedBox(height: 32,),
              Form(child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          expands: false,
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.user,color: Colors.blue),
                          labelText:"First Name",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          expands: false,
                        style: TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.user,color: Colors.blue),
                          labelText:"Last Name",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    expands:false,
                    decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.user_edit_copy,color: Colors.blue),
                          labelText:"Username",
                          labelStyle: TextStyle(color: Colors.white),
                  )
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    expands:false,
                    decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct,color: Colors.blue),
                          labelText:"Email",
                          labelStyle: TextStyle(color: Colors.white),
                  )
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    expands:false,
                    decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.call,color: Colors.blue),
                          labelText:"Phone Number",
                          labelStyle: TextStyle(color: Colors.white),
                  )
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                      obscureText: true,
                      style: TextStyle(color: Colors.blue),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check,color: Colors.blue,),
                        labelText:"Password",
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon:Icon(Iconsax.eye_slash,color: Colors.white54,)
                      ),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(width: 24,height: 48,
                        child: Checkbox(value: isChecked, onChanged: (bool? value)
                              {
                                setState(
                                ()
                                {
                                  isChecked=value!;
                                }
                              );
                              }
                              ,activeColor: Colors.blue.shade900,),
                      ),
                      SizedBox(width: 16),
                      Text("I agree to Privacy Policy and Terms Of Use",style: TextStyle(color: Colors.white,fontSize: 12))
                    ],
                  ),
                  SizedBox(height:32),
                  SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){
                    Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                  }, child: Text("Let's Start",style: TextStyle(color: Colors.blue.shade900))),)
                ],
              )
              ),
              SizedBox(height:24),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Or Sign Up With",style:TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.8)),),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFE0E0E0)),borderRadius: BorderRadius.circular(100)),
                      child: IconButton(onPressed: (){},
                      icon: Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/google-icon.png"))),
                    ),
                    SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFE0E0E0)),borderRadius: BorderRadius.circular(100)),
                      child: IconButton(onPressed: (){},
                      icon: Image(
                        width: 24,
                        height: 24,
                        image: AssetImage("assets/images/facebook-icon.png"))),
                    ),
                  ],
                )
            ],
          ),),
          
      ),
    );
  }
}