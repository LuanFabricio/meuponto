import 'package:flutter/material.dart';

int getDeltaTime(final TimeOfDay start, final TimeOfDay end) {
    return (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
}
