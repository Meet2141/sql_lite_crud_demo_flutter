import 'package:flutter/material.dart';
import 'package:sql_lite/model/contact.dart';
import 'package:sql_lite/utils/database_helper.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  Contact contact = Contact();
  DatabaseHelper dbHelper;

  List<Contact> _contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
    });

    refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'SQl Lite Demo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              form(),
              listView(),
            ],
          ),
        ),
      ),
    );
  }

  form() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      color: Colors.white,
      child: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              onSaved: (val) {
                contact.name = val;
              },
              validator: (val) {
                return (val.length == 0 ? 'This field is required' : null);
              },
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            TextFormField(
              controller: mobileController,
              onSaved: (val) {
                contact.mobile = val;
              },
              validator: (val) {
                return (val.length < 10
                    ? 'Atleast 10 character is required'
                    : null);
              },
              decoration: InputDecoration(labelText: "Mobile Number"),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: FlatButton(
                onPressed: () {
                  onSubmit();
                },
                color: Colors.black,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  listView() {
    return Expanded(
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.yellow,
                      size: 40,
                    ),
                    title: Text(_contacts[index].name.toUpperCase()),
                    subtitle: Text(_contacts[index].mobile),
                    trailing: IconButton(
                      onPressed: () async{
                       await  dbHelper.deleteContact(_contacts[index].id);
                       _resetForm();
                       refreshContactList();
                      },
                      icon: Icon(Icons.delete,color: Colors.red,),
                    ),
                    onTap: () {
                      setState(() {
                        contact = _contacts[index];
                        nameController.text = _contacts[index].name;
                        mobileController.text = _contacts[index].mobile;
                      });
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              );
            }),
      ),
    );
  }

  refreshContactList() async {
    List<Contact> refresh = await dbHelper.fetchData(contact);
    setState(() {
      _contacts = refresh;
    });
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      nameController.clear();
      mobileController.clear();
      contact.id = null;
    });
  }

  onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (contact.id == null) {
        await dbHelper.insertData(contact);
      } else {
        await dbHelper.updateData(contact);
      }
      refreshContactList();
      // setState(() {
      //   _contacts.add(Contact(id: null,name: contact.name,mobile: contact.mobile));
      // });
      // form.reset();
      _resetForm();
      //print(contact.name);
    }
  }
}
