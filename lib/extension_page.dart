import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_extension_text_translation/remove_focus.dart';
import 'package:flag/flag_widget.dart';

import 'package:flutter/material.dart';

class ExtensionPage extends StatefulWidget {
  const ExtensionPage({Key? key}) : super(key: key);

  @override
  State<ExtensionPage> createState() => _ExtensionPageState();
}

class _ExtensionPageState extends State<ExtensionPage> {
  final DocumentReference _documentReference =
      FirebaseFirestore.instance.collection('translations').doc('word');

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Text Translation with Firebase extension'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 300,
                      constraints:
                          const BoxConstraints(minHeight: 55, maxHeight: 200),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: 'translation',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          _documentReference
                              .update({'input': _textEditingController.text});

                          _textEditingController.clear();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: _documentReference.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      Map translatedWord =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        children: [
                          const Divider(thickness: 2),
                          const Flag.fromString('TR', height: 40, width: 40),
                          ListTile(
                            title: Text(translatedWord['translated']['tr']),
                            subtitle: const Text('Türkçe'),
                          ),
                          const Divider(thickness: 2),
                          const Flag.fromString('DE', height: 40, width: 40),
                          ListTile(
                            title: Text(translatedWord['translated']['de']),
                            subtitle: const Text('Almanca'),
                          ),
                          const Divider(thickness: 2),
                          const Flag.fromString('US', height: 40, width: 40),
                          ListTile(
                            title: Text(translatedWord['translated']['en']),
                            subtitle: const Text('İngilizce'),
                          ),
                          const Divider(thickness: 2),
                          const Flag.fromString('ES', height: 40, width: 40),
                          ListTile(
                            title: Text(translatedWord['translated']['es']),
                            subtitle: const Text('İspanyolca'),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
