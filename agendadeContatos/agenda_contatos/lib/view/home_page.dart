import 'dart:ffi';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState(){
    super.initState();

    //Contact c = Contact();
    //c.name = "Misael Alexandrino";
    //c.email = "misaelalexandrino264@gmail.com";
    //c.phone = "42999779876";
    //c.img = null;
    //helper.saveContact(c);
    helper.getAllContacts(). then((list) => print(list));
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}