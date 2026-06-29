import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({super.key, required this.hero});

  final OffersHeroEntity hero;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.asset(
        'assets/images/offers/banner_offfer.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
