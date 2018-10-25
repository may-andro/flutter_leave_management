import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/components/dot_indicator_widget.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/components/onboarding_item_widget.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/model/OnboardingModel.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/utility/page_transformer.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _controller = new PageController();

  static const _kCurve = Curves.ease;

  static const _kDuration = const Duration(milliseconds: 300);

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: createContent());
  }

  Widget createContent() {
    return Container(
        color: Colors.white,
        child: Stack(children: <Widget>[
          PageTransformer(
            pageViewBuilder: (context, visibilityResolver) {
              return PageView.builder(
                controller: _controller,
                itemCount: sampleItems.length,
                onPageChanged: (int) {
                  print(int);
                  setState(() {
                    isLastPage = ((sampleItems.length - 1) == int);
                  });
                },
                itemBuilder: (context, index) {
                  final item = sampleItems[index];
                  final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);

                  return OnboardingItemWidget(
                    item: item,
                    pageVisibility: pageVisibility,
                  );
                },
              );
            },
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new Container(
              color: Colors.grey[800].withOpacity(0.5),
              padding: const EdgeInsets.all(20.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new DotsIndicator(
                      controller: _controller,
                      itemCount: sampleItems.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),

                    InkWell(
                      child: Icon(isLastPage ? Icons.done : Icons.navigate_next,
                          color: Colors.white),
                      onTap: () {
                        setOnboardingFinished();
                        Navigation.navigateTo(context, 'signin',
                            replace: true, transition: TransitionType.fadeIn);
                      },
                    )

                  ]
              ),
            ),
          ),
        ]));
  }

  void setOnboardingFinished() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ONBOARDING_FINISHED, true);
  }
}
