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
  State<CardSlider> createState() => _CardSliderState();
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
    scrollController.dispose();
    super.dispose();
  }

  //Render widgets
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.28;
    final titleFontSize = size.width * 0.045;

    return SizedBox(
        width: double.infinity,
        height: containerHeight,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.title != null)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Text(widget.title!,
                    style: TextStyle(
                        fontSize: titleFontSize,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold))),
          SizedBox(height: size.height * 0.006),
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
    final size = MediaQuery.of(context).size;

    // Calcular dimensiones responsivas
    final cardWidth = size.width * 0.25;
    final cardHeight = size.height * 0.22;
    final dateFontSize = size.width * 0.028;
    final itemFontSize = size.width * 0.026;
    final totalLabelFontSize = size.width * 0.026;
    final totalValueFontSize = size.width * 0.028;
    final clientFontSize = size.width * 0.025;
    final horizontalMargin = size.width * 0.02;

    return Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
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
                        width: cardWidth,
                        height: cardHeight * 0.82,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                            vertical: size.height * 0.008,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Fecha
                              Text(
                                DateFormat('dd/MM/yyyy\nHH:mm')
                                    .format(bill.date),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.limeAccent,
                                    fontSize: dateFontSize,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2),
                              ),
                              // Items
                              Flexible(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: bill.items
                                        .map((item) => Text(
                                              "- ${item.name}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: itemFontSize,
                                                  fontWeight: FontWeight.bold),
                                            ))
                                        .take(4)
                                        .toList(),
                                  ),
                                ),
                              ),
                              // Total
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("TOTAL",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: totalLabelFontSize,
                                          fontWeight: FontWeight.bold)),
                                  Text("\$ ${bill.total}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: totalValueFontSize,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )))),
          SizedBox(height: size.height * 0.005),
          Flexible(
            child: Text(
              bill.client.completeName ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: clientFontSize,
                color: AppTheme.white,
                height: 1.1,
              ),
            ),
          ),
        ]));
  }
}
