import 'package:flutter/material.dart';

class FixedTitlesView extends StatefulWidget {
  final double height;
  final double width;
  final double fixedHeight;
  final double fixedWidth;
  final Widget origin;
  final Widget colTitles;
  final Widget rowTitles;
  final Widget body;
  final double scrollBarThicknes;
  final double borederThicknes;
  final Color borderColor;

  const FixedTitlesView({
    Key? key,
    required this.height,
    required this.width,
    required this.fixedHeight,
    required this.fixedWidth,
    required this.origin,
    required this.colTitles,
    required this.rowTitles,
    required this.body,
    this.scrollBarThicknes = 16.0,
    this.borederThicknes = 0.5,
    this.borderColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  _FixedTitlesState createState() => _FixedTitlesState();
}

class _FixedTitlesState extends State<FixedTitlesView> {
  final ScrollController _titleScrollController = ScrollController();
  final ScrollController _dataScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  bool? _scrollOriginTitle;

  @override
  Widget build(BuildContext context) {
    final BorderSide borderStyle = BorderSide(
      color: widget.borderColor,
      width: widget.borederThicknes,
    );

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            border: Border(
              top: borderStyle,
              left: borderStyle,
              bottom: borderStyle,
              right: borderStyle,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.origin,
              Container(
                width: widget.width -
                    widget.fixedWidth -
                    widget.borederThicknes * 2,
                height: widget.height - widget.borederThicknes * 2,
                alignment: Alignment.topLeft,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollStartNotification) {
                      _scrollOriginTitle ??= true;
                    } else if (_scrollOriginTitle == true) {
                      if (scrollInfo is ScrollUpdateNotification) {
                        _dataScrollController
                            .jumpTo(_titleScrollController.offset);
                      } else if (scrollInfo is ScrollEndNotification) {
                        _scrollOriginTitle = null;
                      }
                    }
                    return true;
                  },
                  child: Scrollbar(
                    controller: _titleScrollController,
                    isAlwaysShown: true,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    thickness: widget.scrollBarThicknes,
                    hoverThickness: widget.scrollBarThicknes,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _titleScrollController,
                      child: Container(
                        height: widget.height,
                        alignment: Alignment.topLeft,
                        child: widget.colTitles,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: widget.width,
          height: widget.height - widget.scrollBarThicknes,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            border: Border(
              top: borderStyle,
              left: borderStyle,
              right: borderStyle,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: widget.width,
                height: widget.fixedHeight,
              ),
              SizedBox(
                height: widget.height -
                    widget.fixedHeight -
                    widget.scrollBarThicknes -
                    widget.borederThicknes * 2,
                child: Scrollbar(
                  controller: _verticalScrollController,
                  isAlwaysShown: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thickness: widget.scrollBarThicknes,
                  hoverThickness: widget.scrollBarThicknes,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalScrollController,
                    child: Row(
                      children: [
                        SizedBox(
                          width: widget.fixedWidth,
                          child: widget.rowTitles,
                        ),
                        SizedBox(
                          width: widget.width -
                              widget.fixedWidth -
                              widget.borederThicknes * 2,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo is ScrollStartNotification) {
                                _scrollOriginTitle ??= false;
                              } else if (_scrollOriginTitle == false) {
                                if (scrollInfo is ScrollUpdateNotification) {
                                  _titleScrollController
                                      .jumpTo(_dataScrollController.offset);
                                } else if (scrollInfo
                                    is ScrollEndNotification) {
                                  _scrollOriginTitle = null;
                                }
                              }
                              return true;
                            },
                            child: Scrollbar(
                              controller: _dataScrollController,
                              isAlwaysShown: true,
                              thickness: 0.0,
                              hoverThickness: 0.0,
                              scrollbarOrientation: ScrollbarOrientation.bottom,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _dataScrollController,
                                child: widget.body,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixedTitlesView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FixedTitlesView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    const double tableHeight = 240.0;
    const double tableWidth = 240.0;
    const double cellHeight = 24.0;
    const double cellWidth = 48.0;
    const BoxDecoration cellDecoration = BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.blueGrey, width: 0.5),
        right: BorderSide(color: Colors.blueGrey, width: 0.5),
        bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
        left: BorderSide(color: Colors.blueGrey, width: 0.5),
      ),
    );
    Widget topLeft = Container(
      height: cellHeight,
      width: cellWidth,
      alignment: Alignment.center,
      decoration: cellDecoration,
      child: const Text('Demo'),
    );
    Widget colTitles = Row(
      children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          .split('')
          .map<Widget>(
            (char) => Container(
              height: cellHeight,
              width: cellWidth,
              alignment: Alignment.center,
              decoration: cellDecoration,
              child: Text(char),
            ),
          )
          .toList(),
    );
    Widget rowTitles = Column(
      children: List<int>.generate(100, (n) => n + 1)
          .map<Widget>(
            (n) => Container(
              height: cellHeight,
              width: cellWidth,
              alignment: Alignment.center,
              decoration: cellDecoration,
              child: Text('$n'),
            ),
          )
          .toList(),
    );
    Widget body = Row(
      children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          .split('')
          .map<Widget>(
            (char) => Column(
              children: List<int>.generate(100, (n) => n + 1)
                  .map<Widget>(
                    (n) => Container(
                      height: cellHeight,
                      width: cellWidth,
                      alignment: Alignment.center,
                      decoration: cellDecoration,
                      child: Text('$char$n'),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16.0),
            FixedTitlesView(
              key: const ValueKey('Test1'),
              height: tableHeight,
              width: tableWidth,
              fixedHeight: cellHeight,
              fixedWidth: cellWidth,
              origin: topLeft,
              colTitles: colTitles,
              rowTitles: rowTitles,
              body: body,
            ),
            const SizedBox(height: 16.0),
            FixedTitlesView(
              key: const ValueKey('Test2'),
              height: tableHeight,
              width: tableWidth,
              fixedHeight: 36,
              fixedWidth: 64,
              origin: Image.asset(
                'images/mtfujitl.jpg',
                width: 64,
                height: 36,
              ),
              colTitles: Image.asset(
                'images/mtfujitr.jpg',
                width: 576,
                height: 36,
              ),
              rowTitles: Image.asset(
                'images/mtfujibl.jpg',
                width: 64,
                height: 324,
              ),
              body: Image.asset(
                'images/mtfujibr.jpg',
                width: 576,
                height: 324,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
