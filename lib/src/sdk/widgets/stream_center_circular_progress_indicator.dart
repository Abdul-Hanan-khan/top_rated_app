import 'package:flutter/material.dart';

class StreamCenterCircularProgressIndicator extends StatelessWidget {
  final Stream<bool> stream;
  StreamCenterCircularProgressIndicator(this.stream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: stream,
        initialData: false,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? SizedBox()
              : Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 3,
                ));
        });
  }
}
