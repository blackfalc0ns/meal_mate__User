import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({super.key, required this.hero});

  final OffersHeroEntity hero;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(46),
      child: SizedBox(
        height: 225,
        width: double.infinity,
        child: Image.asset(
          'assets/images/offers/banner_offfer.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
