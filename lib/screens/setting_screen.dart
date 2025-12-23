import 'package:flutter/material.dart';
import 'package:onebanc_application/widget/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  final String userName;

  const SettingScreen({super.key, required this.userName});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late TextEditingController _usernameController;
  bool _isEditing = false;
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: "profile_avatar",
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isEditing
                            ? SizedBox(
                              width: 180,
                              child: TextField(
                                controller: _usernameController,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter Name",
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            )
                            : Text(
                              _usernameController.text,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                        IconButton(
                          icon: Icon(_isEditing ? Icons.check : Icons.edit),
                          color: isDark ? Colors.white : Colors.black,
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });

                            // Optional: show feedback
                            if (!_isEditing) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Name updated"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Divider(color: isDark ? Colors.white24 : Colors.black26),
                    SizedBox(height: 20),
                    SwitchListTile(
                      title: Text(
                        "Dark Mode",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: isDark,
                      onChanged: (value) {
                        themeProvider.toggleDarkMode(value);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hindi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: !isEnglish ? Colors.orange : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: isEnglish,
                            activeColor: Colors.blueAccent,
                            inactiveThumbColor: Colors.orange,
                            onChanged: (val) {
                              setState(() {
                                isEnglish = val;
                              });

                              // Optional: show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isEnglish
                                        ? "Language set to English"
                                        : "भाषा हिंदी में सेट की गई",
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          Text(
                            "English",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isEnglish ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
