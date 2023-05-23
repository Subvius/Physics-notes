
import 'package:flutter/cupertino.dart';

goToScreen(Widget screen, BuildContext context){
    Navigator.of(context).push(CupertinoPageRoute(builder: (_)=> screen ));
}
goToScreenAsReplacement(Widget screen, BuildContext context){
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_)=> screen ));
}
