import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/constants.dart';
import '../widgets/drawer_widget.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return Material(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        iconSize: 35.h,
                        icon: SvgPicture.asset(
                          'assets/images/menu.svg',
                          // fit: BoxFit.cover,
                          width: 30.h,
                          height: 30.h,
                          color: mainColor,
                        ),
                      ),
                    );
                  }),
                  Badge(
                    position: BadgePosition(top: 10, end: 10),
                    badgeColor: redColor,
                    badgeContent: SizedBox(
                      width: 7.h,
                      height: 7.h,
                    ),
                    // badgeContent: Text('',style: TextStyle(fontSize: 12),),
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          // Navigator.pushNamed(context,
                          //     NotificationScreen.routeName);
                        },
                        iconSize: 35,
                        icon: Icon(
                          Icons.notifications,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Hi Abanob',
                style: TextStyle(
                    fontSize: 24,
                    color: mainColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Chose your benifit card',
                style: TextStyle(
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 25.h),
              Theme(
                data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: mainColor,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  // indicatorPadding:  EdgeInsets.only(right: 20),
                  labelPadding: EdgeInsets.only(right: 25.w),
                  indicator: BoxDecoration(),
                  // indicator: CircleTabIndicator(color: Colors.black,radius:2.5),
                  tabs: [
                    Tab(
                      text: 'All',
                    ),
                    Tab(
                      text: 'Indivsual',
                    ),
                    Tab(
                      text: 'Group',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: mainColor,
                              width: 1.5,
                            ),
                            // color: mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                'assets/images/hbd.png',
                              ))),
                    ),
                    itemCount: 20,
                  ),
                  Text('hi indivisual'),
                  Text('hi group'),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleTabIndicator({required this.color, required this.radius});

  //override createBoxPainter

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  final Color color;

  _CirclePainter({required this.color, required this.radius}); //override paint

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius * 4);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
