import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';

class LeaveDetailPage extends StatelessWidget {
  @required final Leave leave;

  LeaveDetailPage(this.leave);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Leave Detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: createUi(context),
    );
  }

  Widget createUi(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    leave.message,
                    style: TextStyle(
                      color: Colors.black87,
                      letterSpacing: 1.2,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        '${(leave.status == 1) ? 'approved' : 'declined'} your leave.',
                        style: TextStyle(
                          color: (leave.status == 1)
                              ? Colors.green
                              : Colors.red,
                          letterSpacing: 1.2,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        Center(child: isLeaveApproved())
      ],
    );
  }

  Widget isLeaveApproved() {
    if (leave.status == 1) {
      return Container(
        width: 200.0,
        height: 200.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.shade100,
          image: DecorationImage(
            image: new ExactAssetImage('assets/tick.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Center();
    }
  }
}
