import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class EmailList extends StatelessWidget {
  final List<String> emails;
  final void Function(String email) eliminarEmail;
  const EmailList(
      {super.key, required this.emails, required this.eliminarEmail});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: emails.map((e) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(size.iScreen(0.4)),
          padding: EdgeInsets.symmetric(
            vertical: size.iScreen(0.2),
            horizontal: size.iScreen(1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e,
                style: TextStyle(
                  fontSize: size.iScreen(1.8),
                  fontWeight: FontWeight.normal,
                ),
              ),
              IconButton(
                onPressed: () {
                  eliminarEmail(e);
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
                color: Colors.red,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
