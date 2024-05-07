import 'package:flutter/material.dart';

class CopiedSnackBar extends SnackBar {
  CopiedSnackBar({Key? key, required String message})
      : super(
          key: key,
          content: Row(
            children: [
              const Icon(Icons.content_copy),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
}
