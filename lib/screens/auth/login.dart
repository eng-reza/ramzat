import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import '../../provider/authprovider.dart';
import '../../utils/utils.dart';
import '../../widgets/customelevatedbutton.dart';
import '../homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController(text: 'Abc123456@');
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'رمز عبور الزامی است'),
    MinLengthValidator(8, errorText: 'حدافل 8 کاراکتر وارد نمایید'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'حداقل یک کاراکتر خاص وارد نمایید'),
  ]);
  final passwordMatchValidator = MatchValidator(errorText: 'عدم تطابق پسوردها');

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AuthProvider>(
        builder: (BuildContext context, provider, Widget? child) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic) =>
            Utils(context).onWillPop(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                ),
                child: Form(
                  key: _loginformKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      SvgPicture.asset(
                        'assets/secure_login.svg',
                        height: size.height * 0.2,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        'رمز ورود به برنامه را وارد نمایید',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      TextFormField(
                        obscureText: provider.isObsecured,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) => passwordMatchValidator
                            .validateMatch(val!, provider.masterpassword),
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          suffixIcon: InkWell(
                            child: Icon(
                              provider.isObsecured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onTap: () {
                              provider.isObsecured = !provider.isObsecured;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      CustomElevatedButton(
                        ontap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          validate(passwordController.text.trim());
                        },
                        buttontext: 'ورود',
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        'با ذخیره اطلاعات کاربری در اپلیکیشن رمزات'
                        ' نگرانی فراموشی یا مفقودی اطلاعات ورود به سایت ها و دیگر '
                        'نرم افزارها برای همیشه رفع خواهد شد.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void validate(String password) async {
    final FormState form = _loginformKey.currentState!;
    if (form.validate()) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }
}
