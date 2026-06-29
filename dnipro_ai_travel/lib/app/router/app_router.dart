import 'package:go_router/go_router.dart';

import '../../features/navigation/main_navigation.dart';
import '../../features/places/domain/place_entity.dart';
import '../../features/places/presentation/screens/place_detail_screen.dart';
import '../../features/companion/presentation/screens/companion_chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigation(),
    ),
    GoRoute(
      path: '/place',
      builder: (context, state) {
        final place = state.extra as PlaceEntity;
        return PlaceDetailScreen(place: place);
      },
    ),
    GoRoute(
      path: '/companion/chat',
      builder: (_, __) => const CompanionChatScreen(),
    ),
  ],
);