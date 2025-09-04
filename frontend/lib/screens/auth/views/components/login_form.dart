import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth_provider.dart';
import 'package:shop/route/route_constants.dart';
import '../../../../constants.dart';


class LoginForm extends StatefulWidget{
  const LoginForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<LoginForm> createState() => _StateLogInForm();
}

class _StateLogInForm extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (widget.formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success) {
        Navigator.pushNamed(context, entryPointScreenRoute);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Login Failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Emoji.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _passwordController,
            validator: passwordValidator.call,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height > 700
                ? size.height * 0.1
                : defaultPadding,
          ),
          Consumer<AuthProvider>(
            builder: (context, auth, child) => auth.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: () => _login(context), child: const Text('Login')),
          ),
        ],
      ),
    );
  }
}
