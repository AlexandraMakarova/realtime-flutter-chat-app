import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/show_alert.dart';
import '../services/socket_service.dart';
import '../services/auth_service.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';
import '../widgets/custom_input.dart';
import '../widgets/button_blue.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  title: 'Messenger',
                ),
                _Form(),
                Labels(
                  route: 'register',
                  title: "Don't have account yet?",
                  subtitle: 'Create a new one.',
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
            text: 'Login',
            onPressed: authService.authenticationInProcess
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(
                        context,
                        'Login error',
                        'Check your credentials',
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
