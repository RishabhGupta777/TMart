import 'package:flutter/material.dart';

int calculateDiscount(String realPrice, String salePrice) {
  final real = double.tryParse(realPrice) ?? 0.0;
  final sale = double.tryParse(salePrice) ?? 0.0;

  if (real > 0) {
    return (((real - sale) * 100) / real).round();
  } else {
    return 0;
  }
}
