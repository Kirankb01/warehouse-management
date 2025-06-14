import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:warehouse_management/screens/nav_bar_screen.dart';


class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => BottomNavBar()), // Replace with your main screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to StockHub",
          body: "Easily manage products and stock in your warehouse.",
          image: Center(child: Image.asset("assets/Welcome_img.jpg", height: 250)),
        ),
        PageViewModel(
          title: "Add & Update Products",
          body: "Quickly add, edit, or delete products using our simple UI.",
          image: Center(child: Image.asset("assets/logistics.png", height: 250)),
        ),
        PageViewModel(
          title: "Track Inventory",
          body: "View your items in list or grid. Stay in control anytime.",
          image: Center(child: Image.asset("assets/image_tracking_img_org.JPG", height: 250)),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }
}
