import 'package:flutter/material.dart';
import 'package:flutter_checkout/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/styles.dart';

AppBar buildAppBar({final String? title, required context}) {
  return AppBar(
    leading: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyCartView(),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/arrow.svg',
        ),
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(
      title ?? '',
      textAlign: TextAlign.center,
      style: Styles.style25,
    ),
  );
}
