import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital/constants/app_constants.dart';
import 'package:hospital/modular/modular_methods.dart';
import 'package:hospital/providers/api_calls.dart';
import 'package:hospital/screens/log_in.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  static const routeName = '/SignUpPage';

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ApiCalls calls = Get.find();
    return GestureDetector(
      onTap: () {
        ModularMethods.removeFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hospital Management'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textField(userNameController, size, 'User Name'),
            textField(passwordController, size, 'Password'),
            textField(confirmPasswordController, size, 'Confirm Password'),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: 120,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      calls.authenticate(AppConstants.signUp, {
                        "username": userNameController.text,
                        "password1": passwordController.text,
                        "password2": confirmPasswordController.text,
                      }).then((value) {
                        if (value == 200 || value == 201) {
                          Get.snackbar('', 'Successfully signed up');
                          Get.offAndToNamed(LogInPage.routeName);
                        }
                      });
                    },
                    child: const Text('Submit')))
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, Size size, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width * 0.8,
          height: 40,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20),
              hintText: name,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}
