import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset(0, 0);
  bool menuClicked = false;
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double navBarWidth = mediaQuery.width * 0.65;

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  menuClicked = true;
                });
              },
              child: Text('Press Me'),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            left: menuClicked ? 0 : -navBarWidth,
            curve: Curves.elasticOut,
            child: SizedBox(
              width: navBarWidth,
              child: Stack(
                children: <Widget>[
                  Material(
                    elevation: 40,
                    child: Container(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            if (details.localPosition.dx <= navBarWidth) {
                              _offset = details.localPosition;
                            } else if (details.localPosition.dx >
                                (navBarWidth + 85)) {
                              menuClicked = false;
                            }
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _offset = Offset(0, 0);
                          });
                        },
                        child: CustomPaint(
                          size: Size(navBarWidth, mediaQuery.height),
                          painter: NavBarPainer(offset: _offset),
                          child: Container(
                            width: navBarWidth,
                            height: mediaQuery.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      menuClicked = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back_ios,
                                          size: 15,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          'Back',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/me.jpg"),
                                  radius: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Bouncy Menu',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 0.0, height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                buildDummyMenu(),
                                buildDummyMenu(),
                                buildDummyMenu(),
                                buildDummyMenu(),
                                buildDummyMenu(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding buildDummyMenu() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.bookmark), onPressed: null),
          Text(
            'Bookmarks',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.black54,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class NavBarPainer extends CustomPainter {
  final Offset offset;

  NavBarPainer({this.offset});

  getControlPoints(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 90;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-width, 0);
    path.lineTo(width, 0);
    path.quadraticBezierTo(getControlPoints(width), offset.dy, width, height);
    path.lineTo(-width, height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
