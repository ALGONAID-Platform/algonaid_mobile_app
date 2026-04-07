import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [CachedNetworkImage(imageUrl: Images.onboarding1)],
      ),
    );
  }
}
