import 'package:cloudgo_mobileapp/repository/NotificationRepository.dart';
import 'package:cloudgo_mobileapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloudgo_mobileapp/widgets/notification_item.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<NotificationRepository>(context);
    _scrollController.addListener(
      () {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          repository.onSCrollDown();
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "THÔNG BÁO",
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.36),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: MarginValue.small / 2,
                vertical: MarginValue.small / 2),
            decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(10.0)),
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.red,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                controller: _controller,
                tabs: [
                  label(
                    Icons.checklist_outlined,
                    repository.unreadNotify,
                  ),
                  label(
                    Icons.how_to_reg,
                    repository
                        .getListNotificationLeaving()
                        .where((element) => !element.isRead)
                        .length,
                  ),
                  label(
                      Icons.note_add,
                      repository
                          .getListNotificationCheckin()
                          .where((element) => !element.isRead)
                          .length)
                ]),
          ),
        ),
      ),
      body: TabBarView(controller: _controller, children: [
        Container(
            child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < repository.notifictions.length) {
                    return NotificationItem(
                        item: repository.notifictions[index]);
                  } else {
                    return repository.nextOffSet != null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: MarginValue.medium),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container();
                  }
                },
                itemCount: repository.notifictions.length)),
        Container(
            child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < repository.notifictions.length) {
                    return NotificationItem(
                        item: repository.notifictions[index]);
                  } else {
                    return repository.nextOffSet != null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: MarginValue.medium),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container();
                  }
                },
                itemCount: repository.getListNotificationLeaving().length)),
        Container(
            child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index < repository.notifictions.length) {
                    return NotificationItem(
                        item: repository.notifictions[index]);
                  } else {
                    return repository.nextOffSet != null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: MarginValue.medium),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container();
                  }
                },
                itemCount: repository.getListNotificationCheckin().length)),
      ]),
    );
  }

  Widget label(IconData data, int notificationSize) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          data,
          color: Colors.black,
        ),
        const SizedBox(
          width: 3,
        ),
        notificationSize != 0
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(
                    horizontal: MarginValue.small / 2),
                child: Center(
                  child: Text(
                    '$notificationSize',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
