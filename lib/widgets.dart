import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;
  // const TaskCardWidget({this.title, this.desc});
  const TaskCardWidget({Key? key, this.title, this.desc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '(Unamed Task)',
              style: const TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                desc ?? '(no description)',
                style: const TextStyle(
                    fontSize: 16.0, color: Color(0xFF86829D), height: 1.5),
              ),
            ),
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  const TodoWidget({Key? key, this.text, required this.isDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                color: isDone ? const Color(0xFF7349FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                border: isDone
                    ? null
                    : Border.all(color: const Color(0xFF86829D), width: 1.5)),
            child: const Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Flexible(
            child: Text(
              text ?? "unnamed",
              style: TextStyle(
                color:
                    isDone ? const Color(0xFF86829D) : const Color(0XFF211551),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.w500 : FontWeight.bold,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
