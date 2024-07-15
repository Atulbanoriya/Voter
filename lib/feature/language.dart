import 'package:flutter/material.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  String selectedLanguage = 'Choose Language';

  void _chooseLanguage() async {
    final List<String> languages = ['English', 'Hindi', 'Punjabi'];
    final String? chosenLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: languages.map((String language) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(language),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(language);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (chosenLanguage != null) {
      setState(() {
        selectedLanguage = chosenLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: Image.asset(
              "assest/image/logo.png",
              height: 50,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Language Setting ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: _chooseLanguage,
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: selectedLanguage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  readOnly: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
