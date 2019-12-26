import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/listDate.dart';

class DateSlider extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;

  const DateSlider({Key key, this.onDateChanged}) : super(key: key);

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  SwiperController _scrollController = SwiperController();
  ListDate listDate;

  int curIndex;
  int todayIndex;

  @override
  void initState() {
    super.initState();

    listDate = new ListDate();
    todayIndex = (listDate.list.length / 2).floor();
    curIndex = todayIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        if (curIndex != todayIndex)
          renderGoTodayBtn()
        else
          Container(
            height: 30,
            child: Text(
              "Today",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ColorPalette.white.withOpacity(0.65),
              ),
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
                child: Icon(
                  FontAwesomeIcons.solidCircle,
                  color: ColorPalette.white,
                  size: 14,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  renderGoTodayBtn() {
    return GestureDetector(
      onTap: () {
        _scrollController.move(todayIndex, animation: true);
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(
                color: ColorPalette.white.withOpacity(0.65), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.all(3),
        child: Text(
          "Go today",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: ColorPalette.white.withOpacity(0.65),
          ),
        ),
      ),
    );
  }

  renderSwiper() {
    var list = listDate.list;

    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        DateTime date = list[index];
        String weekday = DateFormat('EEE').format(date);
        String day = date.day.toString();

        return renderDateItem(weekday, day, index == curIndex);
      },

      itemCount: list.length,
      viewportFraction: 0.2,
      scale: 1,
      loop: true,
      fade: 0.2,
      index: curIndex,
      onIndexChanged: (index) {
        setState(() {
          curIndex = index;
        });
        widget.onDateChanged(listDate.list[index]);
      },
      onTap: (index) {
        _scrollController.move(index, animation: true);
      },
      controller: _scrollController,
      // pagination: new SwiperPagination(),
      // control: new SwiperControl(),
    );
  }

  renderDateItem(String weekday, String day, bool highlight) {
    TextStyle style = TextStyle(
      color:
          highlight ? ColorPalette.white : ColorPalette.white.withOpacity(0.7),
      fontWeight: FontWeight.w500,
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
