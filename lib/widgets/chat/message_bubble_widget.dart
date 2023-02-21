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
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
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
                  style: isMe
                      ? Theme.of(context).textTheme.bodyText1
                      : Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                          ),
                ),
              ),
              Text(
                message,
                style: isMe
                    ? Theme.of(context).textTheme.headline4
                    : Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.white,
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
