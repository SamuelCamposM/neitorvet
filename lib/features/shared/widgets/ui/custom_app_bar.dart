import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userName;
  final String moduleName;
  final String logoUrl;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.userName,
    required this.moduleName,
    required this.logoUrl,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.network(
            logoUrl,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/no-image.jpg',
                height: 40,
              );
            },
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moduleName,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      actions: actions ??
          [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
