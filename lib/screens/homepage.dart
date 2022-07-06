import 'package:flutter/material.dart';
import 'package:todo_app_srdz_v1/database_helper.dart';
import 'package:todo_app_srdz_v1/screens/taskpage.dart';
import 'package:todo_app_srdz_v1/widgets.dart';

import '../models/task.dart';

class Homapeage extends StatefulWidget {
  const Homapeage({Key? key}) : super(key: key);

  @override
  State<Homapeage> createState() => _HomapeageState();
}

class _HomapeageState extends State<Homapeage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        color: const Color(0xFFF6F6F6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //LOGO
                  margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                  child:
                      const Image(image: AssetImage('assets/images/logo.png')),
                ),
                Expanded(
                  //TASK CARDS
                  child: FutureBuilder<dynamic>(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskPage(
                                            task: snapshot.data[index])),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            });
                      }),
                ),
              ],
            ),
            Positioned(
              //BUTTON
              bottom: 24.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskPage(task: null)))
                      .then((value) => setState(() {}));
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      // color: const Color(0XFF7349FE),
                      gradient: const LinearGradient(
                          colors: [Color(0XFF7349FE), Color(0XFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(40.0)),
                  child: const Image(
                      image: AssetImage('assets/images/add_icon.png')),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
