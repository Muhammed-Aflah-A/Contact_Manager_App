import 'package:contact_app/model/user.dart';
import 'package:contact_app/notifier/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _updateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final form = context.watch<FormProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Consumer<SqlContactProvider>(
          builder: (context, sqlProvider, child) {
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue, size: 28),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            sqlProvider.selectedContact.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green, size: 28),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            sqlProvider.selectedContact.phone,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.red, size: 28),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            sqlProvider.selectedContact.gmail,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            final nameEditController = TextEditingController(
                              text: sqlProvider.selectedContact.name,
                            );
                            final phoneEditController = TextEditingController(
                              text: sqlProvider.selectedContact.phone,
                            );
                            final gmailEditController = TextEditingController(
                              text: sqlProvider.selectedContact.gmail,
                            );
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Update contact",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  content: Form(
                                    key: _updateKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: nameEditController,
                                            decoration: InputDecoration(
                                              labelText: "Name",
                                              suffixIcon: Icon(
                                                Icons.person,
                                                color: Colors.blue,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              value = value?.replaceAll(
                                                "  ",
                                                " ",
                                              );
                                              if (value == null ||
                                                  value.trim().isEmpty) {
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
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(form.numberFocus);
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller: phoneEditController,
                                            decoration: InputDecoration(
                                              labelText: "Phone Number",
                                              suffixIcon: Icon(
                                                Icons.phone,
                                                color: Colors.green,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator: (value) {
                                              value = value?.replaceAll(
                                                " ",
                                                "",
                                              );
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return "Please enter a phone number";
                                              }
                                              if (!RegExp(
                                                r'^[0-9]{10,}$',
                                              ).hasMatch(value)) {
                                                return "Ph no: at least 10 number long (digits only)";
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              form.number = newValue;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(form.gmailFocus);
                                            },
                                          ),
                                          SizedBox(height: 20),
                                          TextFormField(
                                            controller: gmailEditController,
                                            decoration: InputDecoration(
                                              labelText: "Gmail",
                                              suffixIcon: Icon(
                                                Icons.mail,
                                                color: Colors.red,
                                              ),
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              value = value?.replaceAll(
                                                " ",
                                                "",
                                              );
                                              if (value == null ||
                                                  value.trim().isEmpty) {
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
                                            textInputAction:
                                                TextInputAction.done,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            _updateKey.currentState!.reset();
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
                                            if (_updateKey.currentState!
                                                .validate()) {
                                              _updateKey.currentState!.save();
                                              await sqlProvider.updateProfile(
                                                User(
                                                  id: sqlProvider
                                                      .selectedContact
                                                      .id,
                                                  name: nameEditController.text
                                                      .trim(),
                                                  phone: phoneEditController
                                                      .text
                                                      .trim(),
                                                  gmail: gmailEditController
                                                      .text
                                                      .trim(),
                                                ),
                                              );
                                              _updateKey.currentState!.reset();
                                              form.nameController.clear();
                                              form.numberController.clear();
                                              form.gmailController.clear();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text("Update"),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Update"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            sqlProvider.deleteProfile(
                              sqlProvider.selectedContact.id!,
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
