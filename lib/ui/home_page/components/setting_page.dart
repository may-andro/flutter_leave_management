import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_model.dart';

class SettingPage extends StatelessWidget {
  final Menu menu;
  final Function menuClickCallback;
  final VoidCallback closeMenuCallback;

  SettingPage({this.menu, this.closeMenuCallback, this.menuClickCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                closeMenuCallback();
              },
            ),
          ],
        ),
      ),
      body: new Material(
        color: Colors.transparent,
        child: new Stack(
          children: [
            ArcBannerImage(),
            Center(
              child: ListView.builder(
                itemCount: menu.items.length,
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                primary: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: const Color(0x44000000),
                    onTap: () {
                      menuClickCallback(index);
                    },
                    child: Container(
                      width: double.infinity,
                      child: new Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: new Text(
                            menu.items[index].title,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 25.0,
                              fontFamily: 'bebas-neue',
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcBannerImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
        clipper: ArcClipper(),
        child: Container(
          color: Theme.of(context).primaryColor,
          width: screenWidth,
          height: 100.0,
          child: Center(
            child: Text(
              "Setting",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontStyle: FontStyle.normal,
                fontSize: 35.0,
              ),
            ),
          ),
        ));
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
