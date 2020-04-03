import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'global_announcement_service.dart';

class GlobalAnnouncementsWidget extends StatefulWidget {
  final Widget child;

  const GlobalAnnouncementsWidget({Key key, this.child}) : super(key: key);

  @override
  _GlobalAnnouncementsWidgetState createState() =>
      _GlobalAnnouncementsWidgetState();
}

class _GlobalAnnouncementsWidgetState extends State<GlobalAnnouncementsWidget> {
  StreamSubscription<QuerySnapshot> _subscription;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();

    _subscription = GlobalAnnouncementService.onNotification(_onNotification);
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    super.dispose();
  }

  void _onNotification(List<Announcement> announcements) {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }

    if (announcements.length > 0) {
      var a = announcements.first;
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: AnnouncementWidget(
              announcement: a,
            ),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class AnnouncementWidget extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementWidget({Key key, this.announcement}) : super(key: key);

  @override
  _AnnouncementWidgetState createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  bool collapsed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              collapsed = !collapsed;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 350),
              width: collapsed ? 50 : MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: collapsed
                    ? Icon(
                        Icons.warning,
                        color: Colors.white,
                      )
                    : Text(
                        widget.announcement.text,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.white,
                              fontSize: 24.0,
                            ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
