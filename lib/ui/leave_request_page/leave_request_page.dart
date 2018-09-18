import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/progress_button.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/leave_type_widget.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/leaves_date_widget.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/project_list_widget.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {

  // init the step to 0th position
  int current_step = 0;


  List<Step> _buildStepperSteps(BuildContext context) {
    List<Step> leaveRequestSteps = [
      new Step(
          title: new Text("Step 1"),
          content: ProjectListWidget(),
          state: getCurrentState(0),
          isActive: (current_step == 0)),
      new Step(
          title: new Text("Step 2"),
          content: LeavesDateWidget(),
          state: StepState.editing,
          isActive: (current_step == 1)),
      new Step(
          title: new Text("Step 3"),
          content: new LeaveTypeWidget(),
          isActive: (current_step == 2)),
    ];

    return leaveRequestSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Leave request"),
      ),

      body: _createContent(context),
    );
  }

  Widget _createContent(BuildContext context) {
    return Stepper(
      currentStep: this.current_step,
      steps: _buildStepperSteps(context),
      type: StepperType.horizontal,
      onStepTapped: (step) {
        handleStepTapped(step);
      },
      onStepCancel: () {
        setState(() {
          if (current_step > 0) {
            current_step = current_step - 1;
          } else {
            current_step = 0;
          }
        });
      },
      onStepContinue: () {
        setState(() {

          if (current_step < 2) {
            current_step = current_step + 1;
          } else {
            current_step = 0;
          }
        });
      },
    );
  }

  bool isActive(int step) {
    return this.current_step == step;
  }

  void handleStepTapped(int step) {
    setState(() {
      current_step = step;
    });
  }

  StepState getCurrentState(int i) {
    if(current_step < i) {
      return StepState.disabled;
    } else if(current_step == i){
      return StepState.editing;
    } else {
      return StepState.complete;
    }
  }
}
