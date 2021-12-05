import 'package:flutter/material.dart';
import 'package:took_test/config/routes.dart';
import 'package:took_test/widgets/user_avatar.dart';

class NewPostHeader extends StatelessWidget {

  const NewPostHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            const UserAvatar(),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.create),
                child: const Text(
                  'What do you think ?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 22
                  ),
                )
              )
            ),
            const VerticalDivider(
              color: Colors.grey,
            ),
            Padding( 
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.create,
                      arguments: true // true for automacally open image pciker
                    ),
                    icon: const Icon(
                      Icons.photo_library_outlined, 
                      size: 40,
                      color: Colors.grey
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}
