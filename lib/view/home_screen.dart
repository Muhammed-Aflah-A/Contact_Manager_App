import 'package:contact_app/model/user.dart';
import 'package:contact_app/notifier/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _addkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final form = context.watch<FormProvider>();
    final sqlProvider = context.watch<SqlContactProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Phone Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    "Add to contact",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                content: Form(
                  key: _addkey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: form.nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person, color: Colors.blue),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            value = value?.replaceAll("  ", " ");
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a name";
                            }
                            if (value.length < 3) {
                              return "Name must be at least 3 character long";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            form.name = newValue;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(form.numberFocus);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: form.numberController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            prefixIcon: Icon(Icons.phone, color: Colors.green),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            value = value?.replaceAll(" ", "");
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a phone number";
                            }
                            if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
                              return "Ph no: at least 10 number long (digits only)";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            form.number = newValue;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(
                              context,
                            ).requestFocus(form.gmailFocus);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: form.gmailController,
                          decoration: InputDecoration(
                            labelText: "Gmail",
                            prefixIcon: Icon(Icons.mail, color: Colors.red),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            value = value?.replaceAll(" ", "");
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a gmail";
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return "Please enter a valid gmail";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            form.gmail = newValue;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: () {
                          form.nameController.clear();
                          form.numberController.clear();
                          form.gmailController.clear();
                          _addkey.currentState!.reset();
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: () async {
                          if (_addkey.currentState!.validate()) {
                            final nameExist = await sqlProvider.dbHelper
                                .isNameExist(form.nameController.text.trim());
                            final phoneExist = await sqlProvider.dbHelper
                                .isphoneExist(
                                  form.numberController.text.trim(),
                                );
                            if (nameExist && phoneExist) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "name and number already saved",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            } else if (nameExist) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "This name already saved",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            } else if (phoneExist) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "This number already saved",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            _addkey.currentState!.save();
                            await sqlProvider.addProfile(
                              User(
                                name: form.nameController.text.trim(),
                                phone: form.numberController.text.trim(),
                                gmail: form.gmailController.text.trim(),
                              ),
                            );
                            _addkey.currentState!.reset();
                            form.nameController.clear();
                            form.numberController.clear();
                            form.gmailController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer<SqlContactProvider>(
          builder: (context, sqLiteProvider, child) {
            if (sqLiteProvider.profile.isEmpty) {
              return Center(
                child: Text(
                  "No contacts saved",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: sqLiteProvider.profile.length,
              itemBuilder: (context, index) {
                final person = sqLiteProvider.profile[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(person.name),
                    leading: Icon(Icons.person, color: Colors.blue),
                    onTap: () {
                      context.read<SqlContactProvider>().setSelectedContact(
                        person,
                      );
                      Navigator.pushNamed(context, "profile_page");
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
