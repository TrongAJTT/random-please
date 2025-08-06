import 'package:flutter/material.dart';

class SectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget content;
  final Color? iconColor;

  const SectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.content,
    this.iconColor,
  });
}
