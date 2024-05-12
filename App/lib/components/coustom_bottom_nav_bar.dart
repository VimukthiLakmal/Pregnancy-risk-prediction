import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pregnancy/screens/cal_home.dart';
import 'package:pregnancy/screens/home.dart';
import 'package:pregnancy/screens/predict.dart';
import '../helper/enums.dart';


class CustomBottomNavBar extends StatefulWidget {
  final MenuState? selectedMenu;

  const CustomBottomNavBar({super.key, required this.selectedMenu});
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late MenuState _selectedMenuState;

  @override
  void initState() {
    _selectedMenuState = widget.selectedMenu!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color.fromARGB(255, 128, 126, 126);
    // ignore: constant_identifier_names
    const Color ActiveIconColor = Color.fromARGB(255, 238, 118, 154);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Color.fromARGB(232, 250, 250, 250),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: Color.fromARGB(90, 22, 0, 43).withOpacity(0.08),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Transform.scale(
                  scale: MenuState.home == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Conversation.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.home == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomeScreen()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.calandar == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Bell.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.calandar == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const CalHome()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.predict == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Plus Icon.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.predict == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const PredictScreen()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.todo == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Mail.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.todo == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => const Register()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.info == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Star Icon.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.info == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => const LogOutScreen()))
                    },
                  )),
              // Transform.scale(
              //     scale: MenuState.logout == _selectedMenuState ? 1.5 : 1.3,
              //     child: IconButton(
              //       icon: SvgPicture.asset(
              //         "assets/icons/Star Icon.svg",
              //         // ignore: deprecated_member_use
              //         color: MenuState.logout == _selectedMenuState
              //             ? ActiveIconColor
              //             : inActiveIconColor,
              //       ),
              //       onPressed: () => {
              //         // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //         //     builder: (context) => const LogOutScreen()))
              //       },
              //     ))
            ],
          )),
    );
  }
}
