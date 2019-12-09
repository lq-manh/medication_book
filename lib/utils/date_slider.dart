import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';

class MyDate {
  MyDate(this.weekDay, this.date);

  String weekDay;
  String date;
}

class DateSlider extends StatefulWidget {
  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  List<DateTime> listDate = [];
  SwiperController _scrollController = SwiperController();
  MyDate today;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();

    listDate.add(now.subtract(Duration(days: 7)));
    listDate.add(now.subtract(Duration(days: 6)));
    listDate.add(now.subtract(Duration(days: 5)));
    listDate.add(now.subtract(Duration(days: 4)));
    listDate.add(now.subtract(Duration(days: 3)));
    listDate.add(now.subtract(Duration(days: 2)));
    listDate.add(now.subtract(Duration(days: 1)));
    listDate.add(now);
    listDate.add(now.add(Duration(days: 1)));
    listDate.add(now.add(Duration(days: 2)));
    listDate.add(now.add(Duration(days: 3)));
    listDate.add(now.add(Duration(days: 4)));
    listDate.add(now.add(Duration(days: 5)));
    listDate.add(now.add(Duration(days: 6)));
    listDate.add(now.add(Duration(days: 7)));

    // today = new MyDate(DateFormat('EEEE').format(now), now.day.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          "Today",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: ColorPalette.white.withOpacity(0.65),
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: ColorPalette.white.withOpacity(0.65),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: renderSwiper(),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: ColorPalette.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                child: Icon(FontAwesomeIcons.solidCircle, color: ColorPalette.white, size: 14,),
              )
            ],
          ),
        )
      ],
    );
  }

  renderSwiper() {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        DateTime date = listDate[index];
        String weekday = DateFormat('EEE').format(date);
        String day = date.day.toString();

        return renderDateItem(weekday, day);
      },

      itemCount: listDate.length,
      viewportFraction: 0.2,
      scale: 1,
      loop: true,
      index: (listDate.length / 2).floor(),
      onIndexChanged: (index) {},
      onTap: (index) {
        _scrollController.move(index, animation: true);
      },
      controller: _scrollController,
      // pagination: new SwiperPagination(),
      // control: new SwiperControl(),
    );
  }

  renderDateItem(String weekday, String day) {
    TextStyle style = TextStyle(
      color: ColorPalette.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Text(
            weekday,
            style: style,
          ),
          SizedBox(height: 10),
          Text(
            day,
            style: style,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
