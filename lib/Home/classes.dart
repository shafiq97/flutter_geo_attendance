import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import '../Login.dart';
import '../Model/Subject.dart';
import 'CheckIn.dart';
import 'StudentProfile.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final _key = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  @override
  void initState() {
    super.initState();
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("User logged out");
  }
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _key.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu_sharp)),
        ),
        drawer: Container(
          width: we * 0.35,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                //height: he * 0.17,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:  NetworkImage("https://unsplash.com/photos/62wQhEghaw0"),
                ),
              ),
              Expanded(
                child: Container(
                  width: we * 0.5,
                  child: SidebarX(
                    controller: _controller,
                    items: [
                      SidebarXItem(icon: Icons.home, label: 'Home'),
                      SidebarXItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Classes()));
                          },
                          icon: Icons.library_books, label: 'My Classes'),
                      SidebarXItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          },
                          icon: Icons.person,
                          label: 'Profile'),
                      SidebarXItem(icon: Icons.calendar_month, label: 'Calendar'),
                      SidebarXItem(icon: Icons.settings, label: "settings"),
                      SidebarXItem(
                          onTap: () {
                            signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          icon: Icons.logout,
                          label: 'Log Out'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Today's Classes"),
                Container(
                  width: we,
                  height: he * 0.8,
                  child: ListView.builder(
                      itemCount: Subject.subjects.length,
                      itemBuilder: (context, index) {
                        final subject =Subject.subjects[index];

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CheckIn(stud_id: '',))
                              );
                            },
                            child: Container(
                              width: we,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(subject.title),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  // child: Icon(subject.icon),
                                ),
                                trailing: Text(subject.formattedTimeStart),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
