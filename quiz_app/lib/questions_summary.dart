import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map(
            (data) {
              final bool isAnswerCorrect =
                  data['user_answer'] == data['correct_answer'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAnswerCorrect
                      ? const Color.fromARGB(255, 109, 181, 172)
                      : const Color.fromARGB(255, 237, 69, 162),
                  child: Text(((data['question_index'] as int) + 1).toString()),
                ),
                title: Text(
                  data['question'].toString(),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['user_answer'].toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 237, 69, 162),
                      ),
                    ),
                    Text(
                      data['correct_answer'].toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 109, 181, 172),
                      ),
                    ),
                  ],
                ),
              );
              // return Row(
              //   children: [
              //     Text(
              //       ((data['question_index'] as int) + 1).toString(),
              //       textAlign: TextAlign.start,
              //     ),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Text(data['question'].toString()),
              //           const SizedBox(
              //             height: 5,
              //           ),
              //           Text(data['user_answer'].toString()),
              //           Text(data['correct_answer'].toString()),
              //         ],
              //       ),
              //     ),
              //   ],
              // );
            },
          ).toList(),
        ),
      ),
    );
  }
}
