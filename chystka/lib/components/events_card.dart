import 'package:chystka/model_views/event_view.dart';
import 'package:chystka/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class EventsCard extends StatefulWidget {
  final bool horizontal;
  final List<EventModel> events;

  EventsCard(this.horizontal, this.events);

  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var c = TabController(length: 3, vsync: this);
    final tabExplore = widget.events
        .where((element) => element.state == EventState.explore)
        .toList();
    final tabActive = widget.events
        .where((element) => element.state == EventState.active)
        .toList();
    final tabFinished = widget.events
        .where((element) => element.state == EventState.finished)
        .toList();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: widget.horizontal
              ? BorderRadius.horizontal(left: Radius.circular(28))
              : BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            child: TabBar(
              controller: c,
              labelStyle:
                  GoogleFonts.montserratAlternates(fontWeight: FontWeight.w500),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Color(0xff1a73e8),
              unselectedLabelColor: Color(0xff5f6368),
              isScrollable: true,
              indicator: MD2Indicator(
                  indicatorHeight: 3,
                  indicatorColor: Color(0xff1a73e8),
                  indicatorSize:
                      MD2IndicatorSize.full //3 different modes tiny-normal-full
                  ),
              tabs: <Widget>[
                Tab(
                  text: "   Explore   ",
                ),
                Tab(
                  text: "   Active   ",
                ),
                Tab(
                  text: "   Finished   ",
                )
              ],
            ),
          ),
          Container(
            height: widget.horizontal
                ? MediaQuery.of(context).size.height - 140
                : MediaQuery.of(context).size.height / 2 - 60,
            child: TabBarView(controller: c, children: [
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18),
                itemCount: tabExplore.length,
                itemBuilder: (ctx, id) => EventView(tabExplore[id]),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18),
                itemCount: tabActive.length,
                itemBuilder: (ctx, id) => EventView(tabActive[id]),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18),
                itemCount: tabFinished.length,
                itemBuilder: (ctx, id) => EventView(tabFinished[id]),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
