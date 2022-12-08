import 'package:flutter/material.dart';
import 'package:github_task/constant/static_string.dart';

import '../widgets/custom_text.dart';

class NoContentLabel extends StatelessWidget {
  const NoContentLabel({
    Key? key,
    required this.title,
    this.style,
    this.onPress,
  }) : super(key: key);
  final String title;
  final TextStyle? style;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(
              txtTitle: title,
              align: TextAlign.center,
              style: style ??
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10.0),
            if (onPress == null)
              const SizedBox()
            else
              TextButton(
                onPressed: onPress,
                child: const CustomText(
                  txtTitle: StaticString.retry,
                  align: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
