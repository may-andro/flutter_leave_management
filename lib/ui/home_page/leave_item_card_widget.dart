import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:intl/intl.dart';

class LeaveCardItems extends StatelessWidget {

  LeaveCardItems(this.leave);

  final Leave leave;

  BoxDecoration _buildShadowAndRoundedCorners() {
    return BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 0.0,
          blurRadius: 0.0,
          color: Colors.deepPurple,
        ),
      ],
    );
  }

  final statusThumbnail = Container(
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.fill, image: AssetImage("assets/login.jpg"))));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: _buildShadowAndRoundedCorners(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    shape: new CircleBorder(),
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    onPressed: () => {},
                  ),
                  Text(
                    "Approved",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.white.withOpacity(0.85),
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      width: 150.0,
                      height: 1.0,
                    ),
                  ),
                ],
              )
            ],
          ),

          Text(
            leave.typeOfLeave,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.2,
              fontFamily: 'Poppins',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
          ),
          Text(
            "${leave.numberOfDays} days",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
          Text(
            "${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.startDate.millisecondsSinceEpoch * 1000))} - ${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.endDate.millisecondsSinceEpoch * 1000))}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
