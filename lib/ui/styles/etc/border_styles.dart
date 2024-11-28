import 'package:flutter/material.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

Border? getBorder(bool condition) => condition
    ? Border.all(
        color: darkModeGreenW100,
        width: 3,
      )
    : null;
