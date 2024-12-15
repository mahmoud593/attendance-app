import 'package:attendience_app/features/student_behaver/presentation/widget/student_behaver_body.dart';
import 'package:flutter/material.dart';

class StudentBehaverView extends StatelessWidget {
  const StudentBehaverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StudentBehaverBody(),
    );
  }
}
