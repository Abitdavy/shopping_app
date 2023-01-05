import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool?> showDecisionDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'This Action is irreversible',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('cancel'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.cancel),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('confirm'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check_circle),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
