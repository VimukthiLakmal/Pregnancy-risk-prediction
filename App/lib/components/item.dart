import 'package:flutter/material.dart';

import '../model/data.dart';


class EventItem extends StatelessWidget {
  final Data event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    super.key,
    required this.event,
    required this.onDelete,
    this.onTap,
  });

 
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:  Text(
        event.name
      ),
      subtitle: Text(
        event.date.toString(),
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}