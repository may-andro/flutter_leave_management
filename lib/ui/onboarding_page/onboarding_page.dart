import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/components/dot_indicator_widget.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/components/onboarding_item_widget.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/model/IntroModel.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/utility/page_transformer.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

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
    return Scaffold(
        body: createContent()
    );
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
              child: new Center(
                child: new DotsIndicator(
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
              ),
            ),
          ),

          _createGetStartButton()

        ]));
  }

  Widget _createGetStartButton() {
    if(isLastPage) {
      return Positioned(
        bottom: 56.0,
        left: 32.0,
        right: 32.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(0.0),
              color: Colors.blue,
              child: Text("Get Started"),
              onPressed: () {
                setOnboardingFinished();
                Navigation.navigateTo(context, 'signin', replace: true,
                    transition: TransitionType.fadeIn);
              },
              onHighlightChanged: (isPressed) {},
            )
          ],
        ),
      ) ;
    } else {
      return Container();
    }
  }

  void setOnboardingFinished() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ONBOARDING_FINISHED, true);

  }
}
