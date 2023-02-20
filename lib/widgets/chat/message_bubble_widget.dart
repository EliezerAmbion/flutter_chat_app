import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final String displayName;
  final bool isMe;

  const MessageBubbleWidget({
    required super.key,
    required this.message,
    required this.isMe,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(15),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(15),
            ),
          ),
          width: 290,
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 20,
            right: 10,
            left: 18,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 11,
                    color: isMe
                        ? Theme.of(context).textTheme.bodyText1!.color
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
