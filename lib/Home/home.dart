import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_attendance/Login.dart';
import '../Model/Subject.dart';
import 'CheckIn.dart';
import 'StudentProfile.dart';
import 'classes.dart';
import 'package:sidebarx/sidebarx.dart';

class Home extends StatefulWidget {
  final String UserId;

  const Home({
    super.key,
    required this.UserId,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //String userId;
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("User logged out");
  }

  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu_sharp)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.UserId),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
              title: Text("Hi, ${userEmail ?? 'User'}.",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: const Text("Welcome to your Classes",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Classes()));
              },
              title: const Text("Today's Classes"),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            Container(
              width: we,
              height: he * 0.7,
              child: ListView.builder(
                itemCount: Subject.subjects.length,
                itemBuilder: (context, index) {
                  final subject = Subject.subjects[index];
                  return ListTile(
                    onTap: () {
                      DateTime lessonEndTime = subject.datetimeRange.end;
                      DateTime currentTime = DateTime.now();
                      DateTime lessonStartTime = subject.datetimeRange.start;
                      Duration timeLeft =
                          lessonStartTime.difference(currentTime);

                      int hoursLeft = timeLeft.inHours;
                      int minutesLeft = (timeLeft.inMinutes % 60);

                      final String formattedTimeLeft =
                          '${hoursLeft}h ${minutesLeft}m';

                      if (currentTime.isBefore(lessonStartTime)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Lesson starts in ${formattedTimeLeft}"),
                        ));
                      } else if (currentTime.isAfter(lessonEndTime)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(" The Lesson has already ended"),
                        ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckIn(
                                      stud_id: widget.UserId,
                                    )));
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor:
                          index % 2 == 0 ? Colors.blue : Colors.black38,
                      child: Text(subject.title[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(subject.title),
                    trailing: Text(
                        "${subject.formattedTimeStart}-${subject.formattedTimeEnd}"),
                  );
                },
              ),
            ),
            // ListTile(
            //   title: Text("Check Attendance Report"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // ListTile(
            //   title: Text("Faculty Details"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // ListTile(
            //   title: Text("Class Details"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
          ]),
        ),
      ),
      drawer: Container(
        width: we * 0.35,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              //height: he * 0.17,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage("https://unsplash.com/photos/62wQhEghaw0"),
              ),
            ),
            Expanded(
              child: Container(
                width: we * 0.5,
                child: SidebarX(
                  controller: _controller,
                  items: [
                    const SidebarXItem(icon: Icons.home, label: 'Home'),
                    SidebarXItem(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Classes()));
                        },
                        icon: Icons.library_books,
                        label: 'My Classes'),
                    SidebarXItem(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        },
                        icon: Icons.person,
                        label: 'Profile'),
                    const SidebarXItem(
                        icon: Icons.calendar_month, label: 'Calendar'),
                    const SidebarXItem(icon: Icons.settings, label: "settings"),
                    SidebarXItem(
                        onTap: () {
                          signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
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
    );
  }
}
