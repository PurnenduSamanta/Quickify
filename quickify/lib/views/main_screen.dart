import 'package:flutter/material.dart';

import 'home_page.dart';
import 'draft_page.dart';
import '../data/app_database.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Draft? _draftToEdit;

  void _switchToHomeForEdit(Draft draft) {
    setState(() {
      _currentIndex = 0;
      _draftToEdit = draft;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(draftToEdit: _draftToEdit, onEditComplete: () {
        setState(() {
          _draftToEdit = null;
        });
      }), 
      DraftPage(onEdit: _switchToHomeForEdit)
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Draft'),
        ],
      ),
    );
  }
}
