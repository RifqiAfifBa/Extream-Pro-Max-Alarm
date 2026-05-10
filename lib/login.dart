import 'package:AlarmappUIDesignFreebieCommunity/theme/tokens.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0D0F14),

        body: SingleChildScrollView(
          child: Container(
            color: gray300,
            width: double.infinity,
            height: 840,
            padding: const EdgeInsets.only(bottom: 45.700000000000045),
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              direction: Axis.vertical,
              children: [
                Container(
                  width: 375,
                  height: 320,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.0000, 0.0000),
                      radius: 0.80,
                      colors: [Color(0x1A4F6BFF), Color(0x004F6BFF)],
                      stops: [0, 0.7],
                    ),
                  ),
                  child: const Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.horizontal,
                  ),
                ),
                Container(
                  width: 375,
                  height: 474.3,
                  alignment: AlignmentDirectional.topStart,
                  child: OverflowBox(
                    maxHeight: 750.3,
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 375,
                      padding: const EdgeInsets.only(
                        left: padding20,
                        right: padding20,
                        bottom: 40,
                      ),
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: padding32,
                              left: 77.59999999999991,
                              right: 76.40000000000009,
                              bottom: padding32,
                            ),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 115.9,
                                  height: height72,
                                  padding: const EdgeInsets.only(
                                    left: 63.90000000000009,
                                  ),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Container(
                                    width: 52,
                                    height: height72,
                                    padding: const EdgeInsets.only(
                                      bottom: padding20,
                                    ),
                                    alignment: AlignmentDirectional.topStart,
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x66000000),
                                            blurRadius: 16,
                                            spreadRadius: 0,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.fromBorderSide(
                                          BorderSide(width: 1, color: white400),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9999),
                                        ),
                                        color: gray200,
                                      ),
                                      alignment: AlignmentDirectional.center,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          boxShadow: shadowDrop,
                                        ),
                                        child: Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: height20,
                                              decoration: const BoxDecoration(
                                                boxShadow: shadowDrop,
                                              ),
                                              child: const Flex(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 17.5,
                                                    height: height20,
                                                    child: Image(
                                                      image: AssetImage(
                                                        'assets/SVG@2x.png',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    const SizedBox(width: 181, height: 63.3),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: const Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Welcome Back',
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                height: 1.25,
                                                letterSpacing: -0.65,
                                                color: white300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 39.5,
                                      left: 27.9,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          bottom: 0.75,
                                        ),
                                        child: const Flex(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Sign in to continue',
                                              style: TextStyle(
                                                fontSize: fs14,
                                                fontFamily: 'Inter',
                                                height: 1.63,
                                                letterSpacing: 0.1,
                                                color: lightslategray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 335,
                            height: 339,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  width: 335,
                                  padding: const EdgeInsets.all(23),
                                  decoration: const BoxDecoration(
                                    border: Border.fromBorderSide(
                                      BorderSide(width: 1, color: white200),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(24),
                                    ),
                                    color: gray100,
                                  ),
                                  child: Flex(
                                    spacing: 20,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          spacing: gap8,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: padding4,
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
                                                      'Email',
                                                      style: TextStyle(
                                                        fontSize: fs12,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.5,
                                                        letterSpacing: 0.3,
                                                        color: lightslategray,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: TextField(
                                                style: TextStyle(
                                                  fontSize: fs15,
                                                  fontFamily: 'Inter',
                                                  color: lightslategray,
                                                ),
                                                expands: true,
                                                maxLines: null,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: white100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                br16,
                                                              ),
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: white100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                br16,
                                                              ),
                                                            ),
                                                      ),
                                                  fillColor: gray200,
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                    fontSize: fs15,
                                                    fontFamily: 'Inter',
                                                    color: lightslategray,
                                                  ),
                                                  prefixIcon: Container(
                                                    width: 47,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top:
                                                              19.700000000000003,
                                                          left: padding20,
                                                          right: 12,
                                                        ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: Container(
                                                      width: 15,
                                                      height: height15,
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxHeight: 15,
                                                          ),
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/Img@2x.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  prefixIconConstraints:
                                                      BoxConstraints(
                                                        maxWidth: 47,
                                                      ),
                                                  hintText: "you@example.com",
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                        top: 0,
                                                        bottom: 0,
                                                      ),
                                                  constraints:
                                                      BoxConstraints.expand(
                                                        width: 287,
                                                        height: 54.5,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Flex(
                                          spacing: gap8,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: padding4,
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
                                                      'Password',
                                                      style: TextStyle(
                                                        fontSize: fs12,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.5,
                                                        letterSpacing: 0.3,
                                                        color: lightslategray,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: TextField(
                                                style: TextStyle(
                                                  fontSize: fs15,
                                                  fontFamily: 'Inter',
                                                  color: lightslategray,
                                                ),
                                                expands: true,
                                                maxLines: null,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: white100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                br16,
                                                              ),
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: white100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                br16,
                                                              ),
                                                            ),
                                                      ),
                                                  fillColor: gray200,
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                    fontSize: fs15,
                                                    fontFamily: 'Inter',
                                                    color: lightslategray,
                                                  ),
                                                  prefixIcon: Container(
                                                    width: 45.1,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 19.7,
                                                          left: padding20,
                                                          right: 12,
                                                        ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: Container(
                                                      width: 13.1,
                                                      height: height15,
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxHeight: 15,
                                                          ),
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/Img-1@2x.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  prefixIconConstraints:
                                                      BoxConstraints(
                                                        maxWidth: 45.1,
                                                      ),
                                                  suffixIcon: Container(
                                                    width: 36.9,
                                                    height: 54.5,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 19.7,
                                                          right: padding20,
                                                        ),
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topEnd,
                                                    child: Container(
                                                      width: 16.9,
                                                      height: height15,
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxHeight: 15,
                                                          ),
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/Img-2@2x.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  suffixIconConstraints:
                                                      BoxConstraints(
                                                        maxWidth: 36.9,
                                                      ),
                                                  hintText:
                                                      "Enter your password",
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                        top: 0,
                                                        bottom: 0,
                                                      ),
                                                  constraints:
                                                      BoxConstraints.expand(
                                                        width: 287,
                                                        height: 54.5,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height10,
                                        width: double.infinity,
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Container(
                                          width: 287,
                                          height: height10,
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: OverflowBox(
                                            maxHeight: 18,
                                            alignment: Alignment.bottomLeft,
                                            child: const SizedBox(
                                              width: 287,
                                              child: SizedBox(
                                                height: height18,
                                                width: double.infinity,
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                    fontSize: fs12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.5,
                                                    letterSpacing: 0.1,
                                                    color: mediumslateblue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 335,
                                  height: 80,
                                  alignment: AlignmentDirectional.topStart,
                                  child: OverflowBox(
                                    maxHeight: 80,
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      width: 335,
                                      padding: const EdgeInsets.only(top: 24),
                                      child: Flex(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x594F6BFF),
                                                  blurRadius: 32,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 8),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                transform: GradientRotation(
                                                  3.14 * 0.28,
                                                ),
                                                colors: [
                                                  Color(0xFF4F6BFF),
                                                  Color(0xFF6B8FFF),
                                                ],
                                                stops: [0, 1],
                                              ),
                                            ),
                                            constraints: const BoxConstraints(
                                              minHeight: 56,
                                            ),
                                            child: ElevatedButton.icon(
                                              icon: Image(
                                                image: AssetImage(
                                                  "assets/Img-3@2x.png",
                                                ),
                                              ),
                                              iconAlignment: IconAlignment.end,
                                              label: Text(
                                                "Sign In",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.5,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                foregroundColor: white300,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(br16),
                                                      ),
                                                ),
                                                padding: EdgeInsets.zero,
                                                fixedSize: Size(
                                                  double.infinity,
                                                  56,
                                                ),
                                                minimumSize: Size(335, 56),
                                              ),
                                              onPressed: () {},
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
                          Container(
                            padding: const EdgeInsets.only(top: 28),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Flex(
                                    spacing: 16,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: darkslategray,
                                          height: height1,
                                        ),
                                      ),
                                      const Flex(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'or continue with',
                                            style: TextStyle(
                                              fontSize: fs12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              height: 1.5,
                                              color: lightslategray,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: darkslategray,
                                          height: height1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: padding20),
                            width: double.infinity,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Flex(
                                    spacing: gap12,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minHeight: 52,
                                          ),
                                          child: ElevatedButton.icon(
                                            icon: Image(
                                              image: AssetImage(
                                                "assets/SVG-1@2x.png",
                                              ),
                                            ),
                                            iconAlignment: IconAlignment.start,
                                            label: Text(
                                              "Google",
                                              style: TextStyle(
                                                fontSize: fs14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: gray200,
                                              foregroundColor: white300,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br16),
                                                ),
                                              ),
                                              side: BorderSide(
                                                width: 1,
                                                color: white100,
                                              ),
                                              padding: EdgeInsets.only(
                                                top: padding15,
                                                left: 0,
                                                right: 0,
                                                bottom: padding15,
                                              ),
                                              fixedSize: Size(
                                                double.infinity,
                                                53,
                                              ),
                                              minimumSize: Size(161.5, 53),
                                              elevation: 0,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            minHeight: 52,
                                          ),
                                          child: ElevatedButton.icon(
                                            icon: Image(
                                              image: AssetImage(
                                                "assets/Img-4@2x.png",
                                              ),
                                            ),
                                            iconAlignment: IconAlignment.start,
                                            label: Text(
                                              "Apple",
                                              style: TextStyle(
                                                fontSize: fs14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: gray200,
                                              foregroundColor: white300,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br16),
                                                ),
                                              ),
                                              side: BorderSide(
                                                width: 1,
                                                color: white100,
                                              ),
                                              padding: EdgeInsets.only(
                                                top: padding15,
                                                left: 0,
                                                right: 0,
                                                bottom: padding15,
                                              ),
                                              fixedSize: Size(
                                                double.infinity,
                                                53,
                                              ),
                                              minimumSize: Size(161.5, 53),
                                              elevation: 0,
                                            ),
                                            onPressed: () {},
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
                            padding: const EdgeInsets.only(top: padding32),
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flex(
                                  spacing: 4.010000228881836,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  direction: Axis.horizontal,
                                  mainAxisSize: MainAxisSize.min,
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
                                          width: 155.9,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Don\'t have an account?',
                                              style: TextStyle(
                                                fontSize: fs14,
                                                fontFamily: 'Inter',
                                                height: 1.5,
                                                color: lightslategray,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: fs14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mediumslateblue,
                                        padding: EdgeInsets.only(
                                          left: 3,
                                          right: 3,
                                        ),
                                        fixedSize: Size(double.infinity, 21),
                                        minimumSize: Size(54, 21),
                                        elevation: 0,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      onPressed: () {},
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
