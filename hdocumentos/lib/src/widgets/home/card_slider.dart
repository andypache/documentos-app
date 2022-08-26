import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:intl/intl.dart';

///Widgets for my sales
class CardSlider extends StatefulWidget {
  final List<BillModel> bills;
  final String? title;
  final Function onNextPage;

  const CardSlider(
      {Key? key, required this.bills, required this.onNextPage, this.title})
      : super(key: key);

  @override
  _CardSliderState createState() => _CardSliderState();
}

///Create state widgets for slider
class _CardSliderState extends State<CardSlider> {
  final ScrollController scrollController = ScrollController();

  //Build and render slider call next page
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Render widgets
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 240,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.title != null)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.title!,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold))),
          const SizedBox(height: 5),
          Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.bills.length,
                  itemBuilder: (_, int index) => _BillPoster(
                      widget.bills[index],
                      '${widget.title}-$index-${widget.bills[index].id}')))
        ]));
  }
}

//Create widgets for view detail sale into card slider
class _BillPoster extends StatelessWidget {
  final BillModel bill;
  final String resume;

  //Constructor
  const _BillPoster(this.bill, this.resume);

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          stops: [0, 0.8],
          colors: [AppTheme.primaryButton, AppTheme.primary]));

  //Build card slider
  @override
  Widget build(BuildContext context) {
    bill.resume = resume;

    return Container(
        width: 100,
        height: 170,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: bill),
              child: Hero(
                  tag: bill.resume!,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: boxDecoration,
                        child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                  DateFormat('dd/MM/yyyy HH:mm')
                                      .format(bill.date),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.limeAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                      children: bill.items
                                          .map((item) => Text("- ${item.name}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)))
                                          .take(5)
                                          .toList()))),
                          Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("TOTAL",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                Text("\$ ${bill.total}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                              ])
                        ]),
                        width: 100,
                        height: 170,
                      )))),
          const SizedBox(height: 5),
          Column(children: [
            Text("${bill.client.completeName}",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppTheme.white))
          ])
        ]));
  }
}
