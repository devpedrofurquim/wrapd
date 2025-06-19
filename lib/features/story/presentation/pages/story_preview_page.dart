import 'package:flutter/material.dart';

class StoryPreviewPage extends StatelessWidget {
  const StoryPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Preview')),
      body: const Center(
        child: Text('Visual preview of your GitHub story goes here.'),
      ),
    );
  }
}
