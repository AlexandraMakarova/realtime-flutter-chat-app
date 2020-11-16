import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/show_alert.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';

import '../widgets/labels.dart';
import '../widgets/logo.dart';
import '../widgets/custom_input.dart';
import '../widgets/button_blue.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(title: 'Logup'),
                _Form(),
                Labels(
                  route: 'login',
                  title: "Do you have account already?",
                  subtitle: 'Login',
                ),
                Text(
                  'Terms and privacy',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Name',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          ButtonBlue(
            text: 'Sigh Up',
            onPressed: authService.authenticationInProcess
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final sighUpOk = await authService.signUp(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());
                    if (sighUpOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(
                        context,
                        'Sigh up error',
                        sighUpOk,
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
