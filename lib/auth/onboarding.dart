import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gudsman_service/components/buttons/buttons.dart';
import 'package:gudsman_service/components/custom_appbar.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final List<Map<String, String>> onBoardingInfo = [
    {
      'title': 'Digital Reports',
      'description':
          'All Reports are saved to your Gudsman Cloud and can be accessed from across the Globe',
      'imagePath': 'assets/digital_report.png',
    },
    {
      'title': 'Time Tracked',
      'description':
          'All reports are Time Tracked to monitor employee Performance',
      'imagePath': 'assets/time_tracked.png',
    },
    {
      'title': 'Gudsman Network',
      'description':
          'You are connected to a powerfull Internal Network that communicate with each other to provide a seamless experience',
      'imagePath': 'assets/network.png',
    },
  ];

  final PageController _pageController = PageController(viewportFraction: 1);
  int activePage = 0;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 120,
          ),
          Expanded(
            child: PageView.builder(
                itemCount: onBoardingInfo.length,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                pageSnapping: true,
                itemBuilder: (context, pageIndex) {
                  final Map<String, String> currentData =
                      onBoardingInfo[pageIndex];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Image.asset(currentData['imagePath'] ?? ''),
                      Expanded(
                        child: Image(
                          fit: BoxFit.contain,
                          image: AssetImage(currentData['imagePath'] ?? ''),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42.0, vertical: 22.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 24,
                                offset: const Offset(
                                    3, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  currentData['title'] ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF4D4D4D),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currentData['description'] ?? '',
                                  style: const TextStyle(
                                      color: Color(0xFF797979),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  text: 'Login',
                  borderRadius: 16.0,
                  onClick: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomButton(
                    leftAlign: false,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    text: 'Next',
                    iconSpaced: MainAxisAlignment.spaceBetween,
                    borderRadius: 16.0,
                    onClick: () {
                      if (activePage == onBoardingInfo.length - 1) {
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        activePage = activePage + 1;
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInQuad);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
