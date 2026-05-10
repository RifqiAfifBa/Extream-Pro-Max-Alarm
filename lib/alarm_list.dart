import 'package:AlarmappUIDesignFreebieCommunity/theme/tokens.dart';
import 'package:AlarmappUIDesignFreebieCommunity/widgets/stretch_wrap.dart';
import 'package:flutter/material.dart';

class AlarmList extends StatefulWidget {
  const AlarmList({super.key});

  @override
  _AlarmListState createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  bool switchState = true;
  bool switchState1 = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0D0F14),

        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 288,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.0000, 0.0000),
                      radius: 0.80,
                      colors: [Color(0x144F6BFF), Color(0x004F6BFF)],
                      stops: [0, 0.7],
                    ),
                  ),
                ),
              ),
              Container(
                color: gray300,
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 840),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 96),
                      width: double.infinity,
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: padding16,
                              left: padding24,
                              right: padding24,
                              bottom: 20,
                            ),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  width: 106.4,
                                  padding: const EdgeInsets.only(bottom: 0.5),
                                  child: const Flex(
                                    spacing: 1.5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 106.4,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'XAlarm',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                letterSpacing: -0.3,
                                                color: white500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 106.4,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 106.6,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Monday, 23 June',
                                                  style: TextStyle(
                                                    fontSize: fs13,
                                                    fontFamily: 'Inter',
                                                    height: 1.5,
                                                    color: lightslategray,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: height36,
                                  padding: const EdgeInsets.only(
                                    top: 7.25,
                                    bottom: 8.25,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(br9999),
                                    ),
                                    gradient: gradient1,
                                  ),
                                  alignment: AlignmentDirectional.center,
                                  child: const Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'JD',
                                        style: TextStyle(
                                          fontSize: fs13,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                          letterSpacing: 0.3,
                                          color: white500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: padding24,
                              right: padding24,
                              bottom: padding24,
                            ),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(padding19),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        width: 1,
                                        color: mediumslateblue200,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(br24),
                                    ),
                                    gradient: LinearGradient(
                                      transform: GradientRotation(3.14 * 0.33),
                                      colors: [
                                        Color(0xFF1D2330),
                                        Color(0xFF232B3B),
                                      ],
                                      stops: [0, 1],
                                    ),
                                  ),
                                  child: Flex(
                                    spacing: 3,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            const Flex(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.vertical,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 77.7,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'NEXT ALARM',
                                                      style: TextStyle(
                                                        fontSize: fs10,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.5,
                                                        letterSpacing: 1.2,
                                                        color: lightslategray,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: padding3,
                                                left: padding11,
                                                right: padding11,
                                                bottom: padding3,
                                              ),
                                              decoration: const BoxDecoration(
                                                border: Border.fromBorderSide(
                                                  BorderSide(
                                                    width: 1,
                                                    color: crimson200,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br9999),
                                                ),
                                                color: crimson100,
                                              ),
                                              child: Flex(
                                                spacing: 6,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration:
                                                        const BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                0xCCFF4F6B,
                                                              ),
                                                              blurRadius: 6,
                                                              spreadRadius: 0,
                                                              offset: Offset(
                                                                0,
                                                                0,
                                                              ),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  br9999,
                                                                ),
                                                              ),
                                                          color: crimson300,
                                                        ),
                                                  ),
                                                  const Flex(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    direction: Axis.vertical,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: 41.9,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'ACTIVE',
                                                            style: TextStyle(
                                                              fontSize: fs10,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.5,
                                                              letterSpacing:
                                                                  0.8,
                                                              color: crimson300,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: padding9,
                                        ),
                                        width: double.infinity,
                                        child: const Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                '06:30',
                                                style: TextStyle(
                                                  fontSize: 44,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w900,
                                                  height: 1,
                                                  letterSpacing: -1,
                                                  color: white500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                'In 7 hours 24 minutes',
                                                style: TextStyle(
                                                  fontSize: fs13,
                                                  fontFamily: 'Inter',
                                                  height: 1.5,
                                                  color: lightslategray,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 13),
                                        width: double.infinity,
                                        child: Flex(
                                          spacing: gap8,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.horizontal,
                                          children: [
                                            ElevatedButton.icon(
                                              icon: Image(
                                                image: AssetImage(
                                                  "assets/Img@2x.png",
                                                ),
                                              ),
                                              iconAlignment:
                                                  IconAlignment.start,
                                              label: Text(
                                                "QR Scan",
                                                style: TextStyle(
                                                  fontSize: fs11,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    mediumslateblue300,
                                                foregroundColor:
                                                    mediumslateblue400,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(br9999),
                                                      ),
                                                ),
                                                side: BorderSide(
                                                  width: 1,
                                                  color: mediumslateblue100,
                                                ),
                                                padding: EdgeInsets.only(
                                                  top: padding5,
                                                  left: padding11,
                                                  right: padding11,
                                                  bottom: padding5,
                                                ),
                                                fixedSize: Size(
                                                  double.infinity,
                                                  29,
                                                ),
                                                minimumSize: Size(84.9, 29),
                                                elevation: 0,
                                                alignment: Alignment.centerLeft,
                                              ),
                                              onPressed: () {},
                                            ),
                                            ElevatedButton.icon(
                                              icon: Image(
                                                image: AssetImage(
                                                  "assets/Img-1@2x.png",
                                                ),
                                              ),
                                              iconAlignment:
                                                  IconAlignment.start,
                                              label: Text(
                                                "Morning",
                                                style: TextStyle(
                                                  fontSize: fs11,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    mediumslateblue300,
                                                foregroundColor:
                                                    mediumslateblue400,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(br9999),
                                                      ),
                                                ),
                                                side: BorderSide(
                                                  width: 1,
                                                  color: mediumslateblue100,
                                                ),
                                                padding: EdgeInsets.only(
                                                  top: padding5,
                                                  left: padding11,
                                                  right: padding11,
                                                  bottom: padding5,
                                                ),
                                                fixedSize: Size(
                                                  double.infinity,
                                                  29,
                                                ),
                                                minimumSize: Size(86, 29),
                                                elevation: 0,
                                                alignment: Alignment.centerLeft,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: padding16),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: padding24,
                                    right: padding24,
                                  ),
                                  width: double.infinity,
                                  child: const Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flex(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 94.9,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'My Alarms',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.5,
                                                  color: white500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flex(
                                        spacing: gap4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flex(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            direction: Axis.vertical,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 10.5,
                                                height: 12,
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/Img-2@2x.png',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flex(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            direction: Axis.vertical,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Add',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                  letterSpacing: 0.2,
                                                  color: mediumslateblue400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: padding24,
                              right: padding24,
                            ),
                            width: double.infinity,
                            child: Flex(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(padding19),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border.fromBorderSide(
                                      BorderSide(width: 1, color: white400),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(br20),
                                    ),
                                    color: gray200,
                                  ),
                                  child: Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Flex(
                                                spacing: gap16,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Container(
                                                    width: width44,
                                                    height: height30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: padding4,
                                                        ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxWidth: width44,
                                                            maxHeight: height26,
                                                          ),
                                                      child: Transform(
                                                        transform:
                                                            Matrix4.identity()
                                                              ..scale(
                                                                height26 / 32,
                                                                height26 / 32,
                                                              ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                boxShadow:
                                                                    shadowDrop,
                                                              ),
                                                          child: Switch.adaptive(
                                                            value: switchState,
                                                            autofocus: false,
                                                            onChanged:
                                                                (bool value) {
                                                                  setState(() {
                                                                    switchState =
                                                                        value;
                                                                  });
                                                                },
                                                            trackColor:
                                                                WidgetStateProperty<
                                                                  Color?
                                                                >.fromMap(<
                                                                  WidgetState,
                                                                  Color
                                                                >{
                                                                  WidgetState
                                                                      .selected: Color(
                                                                    0xFF4F6BFF,
                                                                  ),
                                                                }),
                                                            thumbColor:
                                                                WidgetStatePropertyAll<
                                                                  Color
                                                                >(
                                                                  Color(
                                                                    0xFFFFFFFF,
                                                                  ),
                                                                ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                  0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flex(
                                                    spacing: gap4,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    direction: Axis.vertical,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        width: 148.3,
                                                        child: Flex(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          direction:
                                                              Axis.vertical,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '06:30',
                                                              style: TextStyle(
                                                                fontSize: fs28,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                height: 1,
                                                                letterSpacing:
                                                                    -0.5,
                                                                color: white500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width:
                                                            148.30000000000018,
                                                        height: 25.5,
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 6.5,
                                                            ),
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topStart,
                                                        child: const SizedBox(
                                                          width: 148.1,
                                                          child: Flex(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.vertical,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                width: 89.8,
                                                                child: FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    'Morning Wake',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          fs13,
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      height:
                                                                          1.5,
                                                                      color:
                                                                          lightslategray,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 148.3,
                                                        child: StretchWrap(
                                                          spacing: gap8,
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top:
                                                                        padding3,
                                                                    left:
                                                                        padding9,
                                                                    right:
                                                                        padding9,
                                                                    bottom:
                                                                        padding3,
                                                                  ),
                                                              decoration: const BoxDecoration(
                                                                border: Border.fromBorderSide(
                                                                  BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        white400,
                                                                  ),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        br9999,
                                                                      ),
                                                                    ),
                                                                color:
                                                                    darkslategray,
                                                              ),
                                                              child: const Flex(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                direction: Axis
                                                                    .horizontal,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Flex(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    direction: Axis
                                                                        .vertical,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            42.3,
                                                                        child: FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child: Text(
                                                                            'Mon–Fri',
                                                                            style: TextStyle(
                                                                              fontSize: fs11,
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w500,
                                                                              height: 1.5,
                                                                              letterSpacing: -0.18,
                                                                              color: lightslategray,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ElevatedButton.icon(
                                                              icon: Image(
                                                                image: AssetImage(
                                                                  "assets/Img-3@2x.png",
                                                                ),
                                                              ),
                                                              iconAlignment:
                                                                  IconAlignment
                                                                      .start,
                                                              label: Text(
                                                                "QR Scan",
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      fs11,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 1.5,
                                                                ),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    mediumslateblue300,
                                                                foregroundColor:
                                                                    mediumslateblue400,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          br9999,
                                                                        ),
                                                                      ),
                                                                ),
                                                                side: BorderSide(
                                                                  width: 1,
                                                                  color:
                                                                      mediumslateblue100,
                                                                ),
                                                                padding: EdgeInsets.only(
                                                                  top: padding3,
                                                                  left:
                                                                      padding9,
                                                                  right:
                                                                      padding9,
                                                                  bottom:
                                                                      padding3,
                                                                ),
                                                                fixedSize: Size(
                                                                  double
                                                                      .infinity,
                                                                  25,
                                                                ),
                                                                minimumSize:
                                                                    Size(
                                                                      78.1,
                                                                      25,
                                                                    ),
                                                                elevation: 0,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: padding4,
                                                left: padding30,
                                                bottom: padding24,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: minW44,
                                                minHeight: minH44,
                                              ),
                                              child: const Flex(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flex(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    direction: Axis.vertical,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: width14,
                                                        height: height16,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/Img-4@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(padding19),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border.fromBorderSide(
                                      BorderSide(width: 1, color: white400),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(br20),
                                    ),
                                    color: gray200,
                                  ),
                                  child: Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Flex(
                                                spacing: gap16,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Container(
                                                    width: width44,
                                                    height: height30,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: padding4,
                                                        ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxWidth: width44,
                                                            maxHeight: height26,
                                                          ),
                                                      child: Transform(
                                                        transform:
                                                            Matrix4.identity()
                                                              ..scale(
                                                                height26 / 32,
                                                                height26 / 32,
                                                              ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                boxShadow:
                                                                    shadowDrop,
                                                              ),
                                                          child: Switch.adaptive(
                                                            value: switchState1,
                                                            autofocus: false,
                                                            onChanged:
                                                                (bool value) {
                                                                  setState(() {
                                                                    switchState1 =
                                                                        value;
                                                                  });
                                                                },
                                                            trackColor:
                                                                WidgetStateProperty<
                                                                  Color?
                                                                >.fromMap(<
                                                                  WidgetState,
                                                                  Color
                                                                >{
                                                                  WidgetState
                                                                      .selected: Color(
                                                                    0xFF4F6BFF,
                                                                  ),
                                                                }),
                                                            thumbColor:
                                                                WidgetStatePropertyAll<
                                                                  Color
                                                                >(
                                                                  Color(
                                                                    0xFFFFFFFF,
                                                                  ),
                                                                ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                  0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                          minWidth: 169,
                                                        ),
                                                    child: Flex(
                                                      spacing: gap4,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                          width: 169,
                                                          child: Flex(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.vertical,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                '08:00',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      fs28,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  height: 1,
                                                                  letterSpacing:
                                                                      -0.5,
                                                                  color:
                                                                      white500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 169,
                                                          height: 25.5,
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 6.5,
                                                              ),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .topStart,
                                                          child: const SizedBox(
                                                            width: 169,
                                                            child: Flex(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              direction:
                                                                  Axis.vertical,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                  width: 63.4,
                                                                  child: FittedBox(
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      'Gym Time',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            fs13,
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        height:
                                                                            1.5,
                                                                        color:
                                                                            lightslategray,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 169,
                                                          child: Flex(
                                                            spacing: gap8,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            direction:
                                                                Axis.vertical,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.only(
                                                                  top: padding3,
                                                                  left:
                                                                      padding9,
                                                                  right:
                                                                      padding9,
                                                                  bottom:
                                                                      padding3,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                  border: Border.fromBorderSide(
                                                                    BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          white400,
                                                                    ),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          br9999,
                                                                        ),
                                                                      ),
                                                                  color:
                                                                      darkslategray,
                                                                ),
                                                                child: const Flex(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Flex(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      direction:
                                                                          Axis.vertical,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              26.3,
                                                                          child: FittedBox(
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child: Text(
                                                                              'Daily',
                                                                              style: TextStyle(
                                                                                fontSize: fs11,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5,
                                                                                color: lightslategray,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              ElevatedButton.icon(
                                                                icon: Image(
                                                                  image: AssetImage(
                                                                    "assets/Img-5@2x.png",
                                                                  ),
                                                                ),
                                                                iconAlignment:
                                                                    IconAlignment
                                                                        .start,
                                                                label: Text(
                                                                  "Math Challenge",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        fs11,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    height: 1.5,
                                                                  ),
                                                                ),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      mediumslateblue300,
                                                                  foregroundColor:
                                                                      mediumslateblue400,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            br9999,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  side: BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        mediumslateblue100,
                                                                  ),
                                                                  padding: EdgeInsets.only(
                                                                    top:
                                                                        padding3,
                                                                    left:
                                                                        padding9,
                                                                    right:
                                                                        padding9,
                                                                    bottom:
                                                                        padding3,
                                                                  ),
                                                                  fixedSize: Size(
                                                                    double
                                                                        .infinity,
                                                                    25,
                                                                  ),
                                                                  minimumSize:
                                                                      Size(
                                                                        115.5,
                                                                        25,
                                                                      ),
                                                                  elevation: 0,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: padding4,
                                                left: padding30,
                                                bottom: padding24,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: minW44,
                                                minHeight: minH44,
                                              ),
                                              child: const Flex(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flex(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    direction: Axis.vertical,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: width14,
                                                        height: height16,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/Img-6@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.6,
                                  child: Container(
                                    padding: const EdgeInsets.all(padding19),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(width: 1, color: white400),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br20),
                                      ),
                                      color: gray200,
                                    ),
                                    child: Flex(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      direction: Axis.vertical,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Flex(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Flex(
                                                  spacing: gap16,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Container(
                                                      width: width44,
                                                      height: height30,
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: padding4,
                                                          ),
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topStart,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: width44,
                                                            height: height26,
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left:
                                                                      padding3,
                                                                  right: 17,
                                                                ),
                                                            decoration: const BoxDecoration(
                                                              border:
                                                                  Border.fromBorderSide(
                                                                    BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          white300,
                                                                    ),
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      br9999,
                                                                    ),
                                                                  ),
                                                              color:
                                                                  darkslategray,
                                                            ),
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerStart,
                                                          ),
                                                          Positioned(
                                                            top: 3,
                                                            left: 5,
                                                            child: Opacity(
                                                              opacity: 0.5,
                                                              child: Container(
                                                                width: width20,
                                                                height:
                                                                    height20,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          br9999,
                                                                        ),
                                                                      ),
                                                                  color:
                                                                      lightslategray,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Flex(
                                                      spacing: gap4,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                          width: 144.3,
                                                          child: Flex(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            direction:
                                                                Axis.vertical,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                '22:00',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      fs28,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  height: 1,
                                                                  letterSpacing:
                                                                      -0.5,
                                                                  color:
                                                                      white500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              144.30000000000018,
                                                          height: 25.5,
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 6.5,
                                                              ),
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .topStart,
                                                          child: const SizedBox(
                                                            width: 143.9,
                                                            child: Flex(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              direction:
                                                                  Axis.vertical,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  'Night Reminder',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        fs13,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.5,
                                                                    letterSpacing:
                                                                        0.1,
                                                                    color:
                                                                        lightslategray,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 144.3,
                                                          child: StretchWrap(
                                                            spacing: gap8,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.only(
                                                                  top: padding3,
                                                                  left:
                                                                      padding9,
                                                                  right:
                                                                      padding9,
                                                                  bottom:
                                                                      padding3,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                  border: Border.fromBorderSide(
                                                                    BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          white400,
                                                                    ),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          br9999,
                                                                        ),
                                                                      ),
                                                                  color:
                                                                      darkslategray,
                                                                ),
                                                                child: const Flex(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Flex(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      direction:
                                                                          Axis.vertical,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              49.3,
                                                                          child: FittedBox(
                                                                            fit:
                                                                                BoxFit.scaleDown,
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child: Text(
                                                                              'Weekend',
                                                                              style: TextStyle(
                                                                                fontSize: fs11,
                                                                                fontFamily: 'Inter',
                                                                                fontWeight: FontWeight.w500,
                                                                                height: 1.5,
                                                                                color: lightslategray,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets.only(
                                                                  top: padding3,
                                                                  left:
                                                                      padding9,
                                                                  right:
                                                                      padding9,
                                                                  bottom:
                                                                      padding3,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                  border: Border.fromBorderSide(
                                                                    BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          white400,
                                                                    ),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          br9999,
                                                                        ),
                                                                      ),
                                                                  color:
                                                                      darkslategray,
                                                                ),
                                                                child: const Flex(
                                                                  spacing: gap4,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Flex(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      direction:
                                                                          Axis.vertical,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                          height:
                                                                              height10,
                                                                          child: Image(
                                                                            image: AssetImage(
                                                                              'assets/Img-7@2x.png',
                                                                            ),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Flex(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      direction:
                                                                          Axis.vertical,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          'Riddle',
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                fs11,
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            height:
                                                                                1.5,
                                                                            color:
                                                                                lightslategray,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  top: padding4,
                                                  left: padding30,
                                                  bottom: padding24,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: minW44,
                                                      minHeight: minH44,
                                                    ),
                                                child: const Flex(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  direction: Axis.horizontal,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flex(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: width14,
                                                          height: height16,
                                                          child: Image(
                                                            image: AssetImage(
                                                              'assets/Img-8@2x.png',
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: height16,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  height: height80,
                  padding: const EdgeInsets.only(top: 1),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(width: 1, color: white200)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(br24),
                      topRight: Radius.circular(br24),
                    ),
                    color: gray100,
                  ),
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 375,
                        height: height80,
                        padding: const EdgeInsets.only(
                          top: padding18,
                          left: 20.699999999999815,
                          right: 18.200000000000273,
                          bottom: padding18,
                        ),
                        child: Flex(
                          spacing: 25.399999618530273,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: padding25,
                                left: 7.639999866485596,
                                right: 7.639999866485596,
                                bottom: padding25,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: minW44,
                                minHeight: minH44,
                              ),
                              child: const Flex(
                                spacing: gap4,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 17.5,
                                        height: height20,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Img-9@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Alarm',
                                        style: TextStyle(
                                          fontSize: fs10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          letterSpacing: 0.1,
                                          color: mediumslateblue400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: padding25,
                                left: 8.099999999999909,
                                right: 8.200000000000273,
                                bottom: padding25,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: minW44,
                                minHeight: minH44,
                              ),
                              child: const Flex(
                                spacing: gap4,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 15,
                                        height: height20,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Img-10@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Timer',
                                        style: TextStyle(
                                          fontSize: fs10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          letterSpacing: 0.1,
                                          color: lightslategray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height36,
                              constraints: const BoxConstraints(minWidth: 56),
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                direction: Axis.horizontal,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 56,
                                    height: height36,
                                    alignment: AlignmentDirectional.topStart,
                                    child: OverflowBox(
                                      maxHeight: 56,
                                      alignment: Alignment.bottomLeft,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            child: Container(
                                              width: 56,
                                              height: 56,
                                              decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x1F4F6BFF),
                                                    blurRadius: 0,
                                                    spreadRadius: 4,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br9999),
                                                ),
                                                color: white100,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(br9999),
                                              ),
                                              gradient: gradient1,
                                            ),
                                            child: const Flex(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              direction: Axis.horizontal,
                                              children: [
                                                Flex(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  direction: Axis.vertical,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 19.3,
                                                      height: 22,
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/Img-11@2x.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: padding25,
                                left: 2.369999885559082,
                                right: 2.4000000953674316,
                                bottom: padding25,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: minW44,
                                minHeight: minH44,
                              ),
                              child: const Flex(
                                spacing: gap4,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: width20,
                                        height: height20,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Img-12@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Settings',
                                        style: TextStyle(
                                          fontSize: fs10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: lightslategray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: padding25,
                                left: 6.5,
                                right: 6.599999999999909,
                                bottom: padding25,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: minW44,
                                minHeight: minH44,
                              ),
                              child: const Flex(
                                spacing: gap4,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.vertical,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: width20,
                                        height: height20,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Img-13@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flex(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Profile',
                                        style: TextStyle(
                                          fontSize: fs10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          letterSpacing: 0.2,
                                          color: lightslategray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
