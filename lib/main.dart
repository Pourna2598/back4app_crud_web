
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyAppId = 'Mv1H4q0DwIkv7GCaTxLv59K8ela6F8fxrYYGJ0d0';
  const keyClientKey = '157oojDDXN1rTkyY4srDG0WcIsLBPwtmOXiK5EFA';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyAppId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Back4App Web CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    final user = ParseUser(_usernameController.text, _passwordController.text, null);
    final response = await user.login();
    if (response.success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      setState(() => message = response.error!.message);
    }
  }

  Future<void> signUp() async {
    final user = ParseUser(_usernameController.text, _passwordController.text, _usernameController.text + '@email.com');
    final response = await user.signUp();
    if (response.success) {
      setState(() => message = "Account created! Please log in.");
    } else {
      setState(() => message = response.error!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login or Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: login, child: Text("Login")),
            ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _itemController = TextEditingController();
  List<ParseObject> items = [];

  Future<void> fetchItems() async {
    final query = QueryBuilder(ParseObject('Item'));
    final response = await query.query();
    if (response.success && response.results != null) {
      setState(() => items = List<ParseObject>.from(response.results!));
    }
  }

  Future<void> addItem() async {
    final item = ParseObject('Item')..set('name', _itemController.text);
    await item.save();
    _itemController.clear();
    fetchItems();
  }

  Future<void> deleteItem(ParseObject item) async {
    await item.delete();
    fetchItems();
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _itemController, decoration: InputDecoration(labelText: "New Item"))),
                IconButton(onPressed: addItem, icon: Icon(Icons.add))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.get<String>('name') ?? ''),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => deleteItem(item)),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
