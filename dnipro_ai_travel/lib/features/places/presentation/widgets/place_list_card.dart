import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/place_entity.dart';

class PlaceListCard extends StatelessWidget {
  final PlaceEntity place;

  const PlaceListCard({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    const locale = 'en';

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => context.push('/place', extra: place),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.place_rounded,
                color: Color(0xFF1677FF),
                size: 34,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.localizedName(locale),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.localizedDescription(locale),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'AI Score ${place.aiScore}',
                    style: const TextStyle(
                      color: Color(0xFF1677FF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}