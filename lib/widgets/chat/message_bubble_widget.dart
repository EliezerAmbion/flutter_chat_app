import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatefulWidget {
  final String message;
  final String displayName;
  final bool isMe;
  final String? photoUrl;

  const MessageBubbleWidget({
    required super.key,
    required this.message,
    required this.isMe,
    required this.displayName,
    required this.photoUrl,
  });

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  bool _isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isTextVisible = !_isTextVisible;
            });
          },
          child: Column(
            crossAxisAlignment:
                widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isMe
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: !widget.isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(15),
                        bottomRight: widget.isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(
                      top: 25,
                      left: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    child: Text(
                      widget.message,
                      style: widget.isMe
                          ? Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.white,
                              )
                          : Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                  // image position
                  Positioned(
                    top: 10,
                    right: widget.isMe ? 7 : null,
                    left: widget.isMe ? null : 7,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: widget.photoUrl != null
                          ? NetworkImage(widget.photoUrl!)
                          : const AssetImage('assets/images/no-image.jpg')
                              as ImageProvider,
                    ),
                  ),
                ],
              ),
              _isTextVisible
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20.0, left: 20),
                      child: Text(
                        widget.displayName,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
