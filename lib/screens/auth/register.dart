import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../../provider/onboardprovider.dart';
import '../../utils/utils.dart';
import '../../widgets/customelevatedbutton.dart';
import '../homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final focus = FocusNode();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final GlobalKey<FormState> _registerformKey = GlobalKey<FormState>();
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
    confirmpasswordController.dispose();
    focus.dispose();
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
                  key: _registerformKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      SvgPicture.asset(
                        'assets/secure_files.svg',
                        height: size.height * 0.2,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        'ثبت رمز عبور اصلی برنامه',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      TextFormField(
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        obscureText: provider.isObsecured,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validator: passwordValidator.call,
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
                        height: size.height * 0.03,
                      ),
                      TextFormField(
                        focusNode: focus,
                        obscureText: provider.isObsecured,
                        controller: confirmpasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            passwordMatchValidator.validateMatch(
                                val!, passwordController.text.trim()),
                        decoration: InputDecoration(
                          labelText: 'تکرار رمز عبور',
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
                        height: size.height * 0.04,
                      ),
                      CustomElevatedButton(
                        ontap: () {
                          validate();
                        },
                        buttontext: 'ذخیره',
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      Divider(color: Theme.of(context).primaryColor),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        'توجه داشته باشید در صورت فراموشی رمز عبور '
                        'اصلی برنامه،امکان ریکاوری داده ها میسر نخواهد بود '
                        'این سیاست در راستای حفظ حریم خصوصی و  '
                        'عدم اشتراک گذاری داده های شما در سرورها تدوین شده است.',
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

  void validate() async {
    final FormState form = _registerformKey.currentState!;
    if (form.validate()) {
      context.read<OnBoardingProvider>().isBoardingCompleate = true;
      context
          .read<AuthProvider>()
          .savePassword(password: confirmpasswordController.text.trim());

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }
}
