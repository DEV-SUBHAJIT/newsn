import 'package:flutter/material.dart';

import '../utils/const.dart';
import '../view/webview.dart';

class CustomToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomToolbar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: THEME_COLOR,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      // Set the back arrow color to white
      elevation: 12,
      title: Text(
        title.replaceAll("\r\n", "").trim(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Montserrat Bold',
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle popup menu item selection
            if (value == 'Privacy Policy') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const WebViewPage(
                        title: "Privacy Policy",
                        url: PRIVACY_POLICY,
                      ),
                ),
              );
            } else if (value == 'Contact Us') {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                // user must tap button! for dialog dismiss
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Contact Us'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            'Have a question or need assistance? Feel free to reach out to us at help@ecart.roywebtech.in. Our dedicated team is here to help you with any inquiries you may have. We look forward to hearing from you!',
                          ),
                          // Text('Go to settings and turn on your internet'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Ok',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder:
              (BuildContext context) => [
                PopupMenuItem(
                  value: 'Privacy Policy',
                  child: Text('Privacy Policy'),
                ),
                PopupMenuItem(value: 'Contact Us', child: Text('Contact Us')),
              ],
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
