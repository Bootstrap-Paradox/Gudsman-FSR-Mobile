import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganizationCard extends ConsumerStatefulWidget {
  const OrganizationCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizationCardState();
}

class _OrganizationCardState extends ConsumerState<OrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      // width: 100,
      color: Colors.red,
    );
  }
}
