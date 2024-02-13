import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab3/firebase_options.dart';
import 'models/exam.dart';
import 'widgets/exam_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/map_widget.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
      theme: ThemeData(primaryColor: Colors.blue,
        fontFamily: 'Montserrat', ),
    );
  }
}

class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  MainListScreenState createState() => MainListScreenState();
}

class MainListScreenState extends State<MainListScreen> {
  final List<Exam> exams = [
    Exam(course: 'Mobile IS', dateTime: DateTime.now(), latitude:42.004186212873655, longitude: 21.409531941596985),
    Exam(course: 'Data science', dateTime: DateTime(2024, 01, 22),latitude:42.004186212873655, longitude: 21.409531941596985),
    Exam(course: 'Management IS', dateTime: DateTime(2024, 01, 12),latitude:42.004186212873655, longitude: 21.409531941596985),
    Exam(course: 'Team project', dateTime: DateTime(2024, 02, 12),latitude:42.004186212873655, longitude: 21.409531941596985),
    Exam(course: 'Video games', dateTime: DateTime.now(),latitude:42.004186212873655, longitude: 21.409531941596985),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
    title: const Text('Exams for this semester'),
    //  IconButton(
    //         icon: const Icon(Icons.calendar_today),
    //         onPressed: () => _showCalendar(context),
    //           ),
    actions: [
      Row(
        children: [
          const Text('Add a new course:'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => FirebaseAuth.instance.currentUser != null
                ? _addExamFunction(context)
                : _navigateToSignInPage(context),
          ),
         
        ],
      ),
      Row(
        children: [
          const Text("Log out:"),
      IconButton(
        icon: const Icon(Icons.login),
        onPressed: _signOut,
      ),
      Row(
        children: [
          IconButton( 
          icon: const Icon(Icons.calendar_month),
          onPressed: _showCalendar,),
        ],
      ),
      Row(
        children: [
           IconButton(onPressed: _openMap, icon: const Icon(Icons.map)),
        ]
        
      ),
    ],
      )
    ]
  ),
        body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final course = exams[index].course;
                final dateTime = exams[index].dateTime;

                return Container(
                  //width: 80,
                  //height: 80,
                  child: Card(
                    color: Color.fromARGB(255, 173, 216, 230),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            dateTime.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _openMap(),
                            child: const Text('View Location'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendar(){
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarView(exams: exams),
      ),
    );
  }
 void _openMap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MapWidget()));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Future<void> _addExamFunction(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: ExamWidget(
              addExam: _addExam,
            ),
          );
        });
  }

  void _addExam(Exam exam) {
    setState(() {
      exams.add(exam);
    });
  }
}

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _successDialog("You have successfully logged in");
        _navigateToHomePage();
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _successDialog("Your registration is successful");
        _navigateToLoginPage();
      }
    } catch (e) {
      _errorDialog("Authentication Error. Please try again");
    }
  }

  void _successDialog(String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _errorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
     
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomePage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _navigateToLoginPage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _navigateToRegisterPage() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isLogin ? const Text("Log in") : const Text("Sign up"),
      ),
      body: Container(
        // Set the background color for the login page
        color: Color.fromARGB(255, 220, 220, 220), // You can choose any color you prefer
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Make the email text bold
              Text(
                "Email",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // Bold
                ),
              ),
              TextField(
                controller: _emailController,
                //decoration: const InputDecoration(labelText: "Enter your email"),
              ),
              const SizedBox(height: 20),
              // Make the password text bold
              Text(
                "Password",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 20,
                  fontWeight: FontWeight.bold, // Bold
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                //decoration: const InputDecoration(labelText: "Enter your password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authAction,
                child: Text(widget.isLogin ? "Sign In" : "Register"),
              ),
              if (!widget.isLogin)
                ElevatedButton(
                  onPressed: _navigateToLoginPage,
                  child: const Text('Already have an account? Login'),
                ),
              if (widget.isLogin)
                ElevatedButton(
                  onPressed: _navigateToRegisterPage,
                  child: const Text('Create an account'),
                ),
              TextButton(
                onPressed: _navigateToHomePage,
                child: const Text('Back to Main Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}