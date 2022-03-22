import 'package:flutter/material.dart';

class PagingIndicator extends StatelessWidget {
  const PagingIndicator({
    Key key,
    this.visiblityCondition = true,
    this.topPadding = 16,
  }) : super(key: key);

  final bool visiblityCondition;
  final double topPadding;
  @override
  Widget build(BuildContext context) {
    return visiblityCondition
        ? Wrap(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
