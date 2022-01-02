import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:league/bloc/notifications/notifications_cubit.dart';
import 'package:league/bloc/notifications/notifications_state.dart';
import 'package:shimmer/shimmer.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(Object context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(builder: (context, state) {
      if (state.notification == null) {
        return Container(
            child: Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: (MediaQuery.of(context).size.width) - 20,
                    height: (MediaQuery.of(context).size.height / 3),
                    color: Colors.grey,
                  ),
                ])));
      }
      return Text('Notification');
    });
  }
}
