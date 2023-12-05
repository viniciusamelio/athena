import 'package:example/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    initDatabase().then(
      (value) async {
        final result = await db.rawQuery(
          "select *, address.id as 'address_id' from user inner join address on user.id = address.user_id where user.id = 'mockedId'",
        );

        if (kDebugMode) {
          print(result.first);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
