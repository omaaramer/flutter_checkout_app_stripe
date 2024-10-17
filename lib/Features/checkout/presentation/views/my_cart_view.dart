import 'package:flutter/material.dart';
import 'package:flutter_checkout/core/widgets/cutom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/my_cart_view_body.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'My Cart'),
      body: const MyCartViewBody(),
    );
  }
}
