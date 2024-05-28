import 'package:e_commerce/components/font_style.dart';
import 'package:e_commerce/controllers/user_controller.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectUser extends StatefulWidget {
  SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

SnackBar incorrectPassword() => SnackBar(
      backgroundColor: Colors.red,
      content: Text('Senha Incorreta!', style: titlePoppins(22)),
    );

class _SelectUserState extends State<SelectUser> {
  bool userSelected = false;
  String? selectedUserEmail;

  final TextEditingController _passwordController = TextEditingController();

  double width = 0;
  double height = 0;
  EdgeInsetsGeometry? margin;

  double buttonHeight = 0;

  bool isButtonDisabled = true;

  var textFieldChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            List<UserModel> users = userController.getUserList();
            List<DropdownMenuEntry> dropEntries = [];

            users.forEach((e) {
              dropEntries.add(DropdownMenuEntry(
                  value: e.email,
                  label: e.nome!,
                  style: ButtonStyle(
                      textStyle: WidgetStatePropertyAll(tilePoppins()))));
            });

            logInUser() {
              if (userSelected && selectedUserEmail!.isNotEmpty) {
                if (userController.setCurrentUser(
                    selectedUserEmail!, _passwordController.text)) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(incorrectPassword());
                  Future.delayed(const Duration(milliseconds: 250));
                  _passwordController.clear();
                }
              }
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 125),
                  const SizedBox(
                    height: 32,
                  ),
                  DropdownMenu(
                    dropdownMenuEntries: dropEntries,
                    width: 220,
                    hintText: 'Selecione o Usuário',
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurple, width: 3))),
                    enableSearch: false,
                    onSelected: (value) {
                      userSelected = true;
                      selectedUserEmail = value.toString();
                      setState(() {
                        margin = const EdgeInsets.symmetric(horizontal: 64);
                        height = 56;
                        buttonHeight = 32;
                      });
                      Future.delayed(const Duration(milliseconds: 400), () {
                        setState(() {
                          textFieldChild = TextField(
                            style: tilePoppins(),
                            textAlignVertical: TextAlignVertical.top,
                            obscureText: true,
                            controller: _passwordController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  isButtonDisabled = false;
                                });
                              } else {
                                setState(() {
                                  isButtonDisabled = true;
                                });
                              }
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Insira a sua Senha",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8)),
                          );
                        });
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: height,
                    margin: margin,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    child: textFieldChild,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    height: buttonHeight,
                    child: TextButton(
                        onPressed: () {
                          isButtonDisabled ? null : logInUser();
                        },
                        style: ButtonStyle(backgroundColor:
                            WidgetStateColor.resolveWith((state) {
                          if (isButtonDisabled) {
                            return Colors.red[800]!;
                          }
                          return Colors.deepPurple;
                        })),
                        child: Text('Logar', style: tilePoppins(20))),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
