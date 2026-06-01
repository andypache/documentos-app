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
    final shortest = size.shortestSide;
    final containerHeight = shortest * 0.52;
    final titleFontSize = shortest * 0.055;

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
          SizedBox(height: shortest * 0.008),
          Expanded(
              child: ListView.builder(
                  key: ValueKey('bill_slider_${widget.title}'),
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
    final shortest = size.shortestSide;

    // Calcular dimensiones responsivas basadas en shortestSide
    final cardWidth = shortest * 0.32;
    final cardHeight = shortest * 0.42;
    final dateFontSize = shortest * 0.034;
    final itemFontSize = shortest * 0.03;
    final totalLabelFontSize = shortest * 0.03;
    final totalValueFontSize = shortest * 0.034;
    final clientFontSize = shortest * 0.028;
    final horizontalMargin = size.width * 0.02;

    return Container(
        key: ValueKey('bill_poster_${bill.id}'),
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
                            horizontal: shortest * 0.012,
                            vertical: shortest * 0.01,
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
                              Padding(
                                padding: EdgeInsets.only(top: shortest * 0.008),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      color: Colors.white.withOpacity(0.25),
                                      thickness: 0.8,
                                      height: shortest * 0.02,
                                    ),
                                    Text("TOTAL",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: totalLabelFontSize,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: shortest * 0.006),
                                    Text("\$ ${bill.total}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: totalValueFontSize,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )))),
          SizedBox(height: shortest * 0.007),
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
