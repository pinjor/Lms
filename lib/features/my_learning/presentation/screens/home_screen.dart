import 'package:bjp_app/config/app_colors.dart';
import 'package:bjp_app/config/app_theme_data.dart';

import 'package:bjp_app/core/utils/utils.dart';
import 'package:bjp_app/dataRepository/global.dart';
import 'package:bjp_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bjp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bjp_app/features/features/presentation/screens/Banner_section_screen.dart';
import 'package:bjp_app/features/features/presentation/screens/welcome_section_screen.dart';
import 'package:bjp_app/features/our_discussion/presentation/controllers/discussion_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../events/presentation/controllers/event_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _appBarTitle = 'Preparation360';
  int _selectedIndex = 0;

  @override

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    WelcomeSectionScreen(),
    BannerSectionScreen(),
    //Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
    Text('Index 3: Settings', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  void _logoutUser() {
    if (Navigator.canPop(context)) {
      print("1");
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      user = "";
      token = "";
    } else {
      print("2");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      print("3");
      Navigator.pop(context);
    }
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      print("4");
      Navigator.of(context, rootNavigator: true).pop(); // Closes dialog
    }


  }




  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isAdmin = authState.isAdmin;
    final eventListState = ref.watch(eventControllerProvider);
    final discussionListState = ref.watch(discussionControllerProvider);



    return PopScope(
      canPop: _selectedIndex == 0, // Allow app to minimize only when on home
      onPopInvoked: (bool didPop) {
        if (!didPop && _selectedIndex != 0) {
          // Handle back press: navigate to home screen
          setState(() {
            _selectedIndex = 0;
            _appBarTitle = 'Preparation360';
          });
        }
      },

      child: Theme(
        data: AppThemeData.lightThemeData,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              _appBarTitle,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed:
                    () => showLogoutDialog(
                      context: context,
                      onPressed: () => _logoutUser(),
                    ),
                child: Text(
                  'Logout',
                  style: TextStyle(color: AppColors.themeColor, fontSize: 14),
                ),
              ),
            ],
          ),
          body:
          Center(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Features',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                label: 'My learning',
                backgroundColor: Colors.purple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
                backgroundColor: Colors.pink,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),



        ),
      ),
    );
  }

}
