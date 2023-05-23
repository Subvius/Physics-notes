import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Map<String, Color> COLORS = {
  "background": const Color(0xff1d2733),
  "spacer": const Color(0xff151d26),
  "header": const Color(0xff212d3b),
  "icons": const Color(0xff7d8b98),
  "title": const Color(0xff6eb1e5),
  "section": const Color(0xff3d6a97),
};

class Palette {
  final String theme;
  final Color background;
  final Color chatBackground;
  final Color header;
  final Color userName;
  final Color avatar;
  final Color text;
  final Color title;
  final Color subTitle;
  final Color spacer;
  final Color icons;
  final Color section;

  const Palette({
    required this.theme,
    required this.chatBackground,
    required this.avatar,
    required this.background,
    required this.header,
    required this.userName,
    required this.text,
    required this.title,
    required this.subTitle,
    required this.spacer,
    required this.icons,
    required this.section,
  });
}

// ignore: constant_identifier_names
const DarkTheme = Palette(
  chatBackground: Color(0xff111b29),
  avatar: Color(0xff6eb1e5),
  userName: Colors.white,
  theme: "dark",
  background: Color(0xff1d2733),
  header: Color(0xff212d3b),
  text: Colors.white,
  title: Color(0xff6eb1e5),
  subTitle: Colors.white60,
  spacer: Color(0xff151d26),
  icons: Color(0xff7d8b98),
  section: Color(0xff202c39),
);
