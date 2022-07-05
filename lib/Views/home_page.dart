import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:developer' as devtools show log;
import 'package:hospitalmanagementsystem/Constants/routes.dart';
import 'package:hospitalmanagementsystem/Constants/texts.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';
import 'package:readmore/readmore.dart';
import '../enums/menu_actions.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late final PatientService _patientService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _patientService = new PatientService();
    _patientService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.pink[700],
          centerTitle: true,
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutConfirmation(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
              devtools.log(value.toString());
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            })
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints.expand(height: 200),
                child: imageSlider(context),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: ReadMoreText(
                  content,
                  trimLines: 3,
                  textAlign: TextAlign.justify,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " Show More ",
                  trimExpandedText: " Show Less ",
                  lessStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
                  moreStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ),
              FutureBuilder(
                future: _patientService.getUser(email: userEmail),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return StreamBuilder(
                          stream: _patientService.allDiagnosis,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                return const Text("waiting");
                              default:
                                return const CircularProgressIndicator();
                            }
                          });
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ));
  }
}

Swiper imageSlider(Context) {
  return Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index) {
      return Image.asset(
        "assets/download.jpeg",
        width: 150,
        height: 150,
        fit: BoxFit.fitHeight,
      );
    },
    itemCount: 10,
    viewportFraction: 0.8,
    scale: 0.9,
  );
}

Future<bool> showLogOutConfirmation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("log out"),
        content: const Text("Are you sure you want to log out"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("log out")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("cancel"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
