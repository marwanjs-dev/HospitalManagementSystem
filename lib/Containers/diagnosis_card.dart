import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DiagnosisCard extends StatefulWidget {
  const DiagnosisCard(
      {required String this.date,
      required String this.doctorName,
      required String this.detail,
      required int this.diagnosisID})
      : super();
  final date;
  final doctorName;
  final detail;
  final diagnosisID;

  @override
  State<DiagnosisCard> createState() => _DiagnosisCardState();
}

class _DiagnosisCardState extends State<DiagnosisCard> {
  late final _width = MediaQuery.of(context).size.width;
  late final _height = MediaQuery.of(context).size.height;
  


  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: 0.1 * _height,
      child: Column(
        children: [Row(children: [
          
        ],)],
      ),
    );
  }
}
