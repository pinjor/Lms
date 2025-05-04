import 'package:bjp_app/config/app_colors.dart';
import 'package:bjp_app/config/app_theme_data.dart';
import 'package:bjp_app/core/ui/custom_loader.dart';
import 'package:bjp_app/core/utils/utils.dart';
import 'package:bjp_app/dataRepository/global.dart';
import 'package:bjp_app/features/announcement/presentation/screens/announcement_screen.dart';
import 'package:bjp_app/features/auth/domain/auth_state.dart';
import 'package:bjp_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bjp_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bjp_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:bjp_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:bjp_app/features/events/presentation/screens/event_scedule_screen.dart';
import 'package:bjp_app/features/events/presentation/widgets/event_time_card.dart';
import 'package:bjp_app/features/home/domain/recent_announcement.dart';
import 'package:bjp_app/features/home/presentation/controllers/home_controller.dart';
import 'package:bjp_app/features/home/presentation/screens/contact_information.dart';
import 'package:bjp_app/features/home/presentation/screens/first_home_screen_portion.dart';
import 'package:bjp_app/features/home/presentation/screens/leadership_trainning.dart';
import 'package:bjp_app/features/home/presentation/screens/our_constitution.dart';
import 'package:bjp_app/features/home/presentation/screens/our_introduction_screen.dart';
import 'package:bjp_app/features/home/presentation/widgets/discussion_card_widget.dart';
import 'package:bjp_app/features/media/presentation/screens/photo_album_screen.dart';
import 'package:bjp_app/features/media/presentation/screens/video_album_screen.dart';
import 'package:bjp_app/features/member/presentation/screens/member_screen.dart';
import 'package:bjp_app/features/our_discussion/presentation/controllers/discussion_controller.dart';
import 'package:bjp_app/features/profile/presentation/screens/profile_editing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_icon_widget.dart';
import '../../../announcement/presentation/screens/create_announcement_screen.dart';
import '../../../events/domain/event_model.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../our_discussion/domain/discussion_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _appBarTitle = 'হোম';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventControllerProvider.notifier).fetchEvents(context);
      ref
          .read(discussionControllerProvider.notifier)
          .fetchAllDiscussions(context);

      // Check user role.
      final isAdmin = ref.read(authControllerProvider).isAdmin;
      if (!isAdmin) {
        ref
            .read(homeControllerProvider.notifier)
            .fetchRecentMemberAnnouncement();
      }
    });
  }

  List<Widget> _drawerOptions(
    bool isAdmin,
    AuthState authState, {
    required AsyncValue<List<EventModel>?> events,
    required AsyncValue<List<DiscussionModel>?> discussions,
  }) {
    return isAdmin
        ? [
          _buildDashboard(
            authState,
            eventListState: events,
            discussionListState: discussions,
          ),
          AnnouncementScreen(),
          CreateAnnouncementScreen(),
          MemberScreen(),
          EventSceduleScreen(),
          ChatListScreen(),
        ]
        : [
          _buildDashboard(
            authState,
            eventListState: events,
            discussionListState: discussions,
          ),
          AnnouncementScreen(),
          OurConstitution(),
          PhotoAlbumScreen(),
          VideoAlbumScreen(),
          ProfileEditingScreen(),
          ChatPage(userInfo: '1', name: "Admin"),
        ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (ref.read(authControllerProvider).user?.user?.isAdmin == 1) {
        switch (index) {
          case 0:
            _appBarTitle = 'হোম';
            break;
          // announcements
          case 1:
            _appBarTitle = 'ঘোষণা';
            break;
          case 2:
            _appBarTitle = 'ঘোষণা তৈরি করুন';
            break;
          // create announcements
          case 3:
            _appBarTitle = 'সদস্য';
            break;
          case 4:
            _appBarTitle = 'অনুষ্ঠানের সময়';
            break;
          case 5:
            _appBarTitle = 'চ্যাট তালিকা';
            break;
        }
      } else {
        switch (index) {
          case 0:
            _appBarTitle = 'হোম';
            break;
          // announcements
          case 1:
            _appBarTitle = 'ঘোষণা';
            break;
          case 2:
            _appBarTitle = 'আমাদের সংবিধান';
            break;
          case 3:
            _appBarTitle = 'ছবি';
            break;
          case 4:
            _appBarTitle = 'ভিডিও';
            break;
          case 5:
            _appBarTitle = 'প্রোফাইল পরিবর্তন';
            break;
          case 6:
            _appBarTitle = 'চ্যাট উইথ আন্দালিব';
            break;
        }
      }
    });
  }

  void _logoutUser() {
    // ref.read(authControllerProvider.notifier).logout();
    //Navigator.pop(context);
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

    // Then perform logout
    // ref.read(authControllerProvider.notifier).logout();
    //
    // // Navigate to login screen
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    //       (route) => false,
    // );
  }

  // void _logoutUser() {
  //   // Close the dialog using rootNavigator
  //   Navigator.of(context, rootNavigator: true).pop();
  //
  //   // Perform logout once
  //   ref.read(authControllerProvider.notifier).logout();
  //
  //   // Navigate to LoginScreen and remove all previous routes
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //     // (route) => false,
  //   );
  // }

  void _showAnnouncementDialog(RecentAnnouncement announcement) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // << Changed from gradient to solid color
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.announcement, size: 48, color: AppColors.themeColor),
                SizedBox(height: 10),
                Text(
                  'Announcement',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Divider(color: Colors.white70, thickness: 1, height: 20),
                Text(
                  announcement.content ?? 'No content available',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 10),
                Text(
                  announcement.createdAt ?? 'No date available',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.themeColor,
                    backgroundColor: AppColors.themeColor, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text(
                    'Got it!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isAdmin = authState.isAdmin;
    final eventListState = ref.watch(eventControllerProvider);
    final discussionListState = ref.watch(discussionControllerProvider);

    if (!isAdmin) {
      // Listen for changes in the home controller state.
      ref.listen<AsyncValue<dynamic>>(homeControllerProvider, (previous, next) {
        next.whenData((announcement) {
          Future.delayed(Duration(milliseconds: 300), () {
            // Check if the announcement is not null and show the dialog.

            if (announcement != null) {
              _showAnnouncementDialog(announcement);
            }
          });
        });
      });
    }

    return PopScope(
      canPop: _selectedIndex == 0, // Allow app to minimize only when on home
      onPopInvoked: (bool didPop) {
        if (!didPop && _selectedIndex != 0) {
          // Handle back press: navigate to home screen
          setState(() {
            _selectedIndex = 0;
            _appBarTitle = 'হোম';
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
          body: SafeArea(
            child:
                _drawerOptions(
                  isAdmin,
                  authState,
                  events: eventListState,
                  discussions: discussionListState,
                )[_selectedIndex],
          ),
          floatingActionButton:
              _selectedIndex == 0
                  ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ChatPage(userInfo: '1', name: "Admin"),
                        ),
                      );
                    },
                    child: Icon(Icons.chat, color: Colors.white),
                    backgroundColor: AppColors.themeColor,
                  )
                  : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          drawer: Drawer(
            width: 250,
            child: ListView(
              children: [
                DrawerHeader(child: AppLogoWidget(height: 10, width: 10)),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('হোম'),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  },
                ),
                // announcements
                if (isAdmin) ...[
                  ExpansionTile(
                    leading: Icon(Icons.announcement),
                    title: Text('ঘোষণা'),
                    children: [
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text('ঘোষণা তালিকা'),
                        selected: _selectedIndex == 1,
                        onTap: () {
                          _onItemTapped(1);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text('ঘোষণা তৈরি করুন'),
                        selected: _selectedIndex == 2,
                        onTap: () {
                          _onItemTapped(2);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.person_4),
                    title: Text('সদস্য'),
                    selected: _selectedIndex == 3,
                    onTap: () {
                      _onItemTapped(3);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule_sharp),
                    title: Text('অনুষ্ঠানের সময়'),
                    selected: _selectedIndex == 4,
                    onTap: () {
                      _onItemTapped(4);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('চ্যাট তালিকা'),
                    selected: _selectedIndex == 5,
                    onTap: () {
                      _onItemTapped(5);
                      Navigator.pop(context);
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: Icon(Icons.announcement),
                    title: Text('ঘোষণা'),
                    selected: _selectedIndex == 1,
                    onTap: () {
                      _onItemTapped(1);
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.picture_as_pdf),
                    title: Text('আমাদের সংবিধান'),
                    selected: _selectedIndex == 2,
                    onTap: () {
                      _onItemTapped(2);
                      Navigator.pop(context);
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.perm_media),
                    title: Text('মিডিয়া'),
                    children: [
                      ListTile(
                        leading: Icon(Icons.picture_in_picture_sharp),
                        title: Text('ছবি'),
                        selected: _selectedIndex == 3,
                        onTap: () {
                          _onItemTapped(3);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.video_collection),
                        title: Text('ভিডিও'),
                        selected: _selectedIndex == 4,
                        onTap: () {
                          _onItemTapped(4);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('প্রোফাইল পরিবর্তন'),
                    selected: _selectedIndex == 5,
                    onTap: () {
                      _onItemTapped(5);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('চ্যাট উইথ আন্দালিব'),
                    selected: _selectedIndex == 6,
                    onTap: () {
                      _onItemTapped(6);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    AuthState authState, {
    required AsyncValue<List<EventModel>?> eventListState,
    required AsyncValue<List<DiscussionModel>?> discussionListState,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FirstHomeScreenPortion(),

          SizedBox(height: 15),

          our_introduction_screen(context: context),
          SizedBox(height: 8),
          LeadershipTrainingSection(),
          SizedBox(height: 8),
          if (!authState.isAdmin) ...[
            eventListState.when(
              data: (events) {
                if (events == null || events.isEmpty) {
                  return Text('কোন ইভেন্ট পাওয়া যায়নি');
                }
                return ListView.builder(
                  itemCount: events.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return EventTimeCard(eventModel: events[index]);
                  },
                );
              },
              error: (err, st) => Text('ইভেন্ট লোড করতে ব্যর্থ হয়েছে: $err'),
              loading: () => CustomLoader(),
            ),
            SizedBox(height: 20),
            Text(
              'আপনাদের মতামত',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            SizedBox(height: 5),
            discussionListState.when(
              data: (discussions) {
                if (discussions == null || discussions.isEmpty) {
                  return Text('কোন আলোচনা পাওয়া যায়নি');
                }

                return SizedBox(
                  height: 350, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: discussions.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      final discussion = discussions[i];
                      return DiscussionCardWidget(discussion: discussion);
                    },
                  ),
                );
              },
              error: (err, st) {
                return Text('আলোচনা লোড করতে ব্যর্থ হয়েছে: $err');
              },
              loading: () => CustomLoader(),
            ),
          ],
          SizedBox(height: 8),
          contact_information_screen(),
        ],
      ),
    );
  }
}
