import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timenest/features/requests/presentation/create_request_screen.dart';

import '../../../providers/unread_chat_provider.dart';

import '../../chat/presentation/chat_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../requests/presentation/requests_screen.dart';

class MainShell
    extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
  });

  @override
  ConsumerState<MainShell>
      createState() =>
          _MainShellState();
}

class _MainShellState
    extends ConsumerState<MainShell> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = const [
      HomeScreen(),
      RequestsScreen(),
      ChatScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(
      BuildContext context) {
    final unreadChats =
        ref.watch(
      unreadChatProvider,
    );

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateRequestScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,
      bottomNavigationBar:
          BottomAppBar(
        shape:
            const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                setState(() {
                  currentIndex =
                      0;
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.assignment,
              ),
              onPressed: () {
                setState(() {
                  currentIndex =
                      1;
                });
              },
            ),
            const SizedBox(
              width: 40,
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chat,
                  ),
                  onPressed: () {
                    setState(() {
                      currentIndex =
                          2;
                    });
                  },
                ),
                unreadChats.when(
                  data: (count) {
                    if (count ==
                        0) {
                      return const SizedBox();
                    }

                    return Positioned(
                      right: 0,
                      top: 0,
                      child:
                          Container(
                        padding:
                            const EdgeInsets.all(
                          4,
                        ),
                        decoration:
                            const BoxDecoration(
                          color:
                              Colors.red,
                          shape: BoxShape
                              .circle,
                        ),
                        child:
                            Text(
                          count
                              .toString(),
                          style:
                              const TextStyle(
                            color: Colors
                                .white,
                            fontSize:
                                10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const SizedBox(),
                  error: (_, __) =>
                      const SizedBox(),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
              ),
              onPressed: () {
                setState(() {
                  currentIndex =
                      3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}