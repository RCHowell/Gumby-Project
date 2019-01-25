import 'package:gumby_project/models/route.dart';

class RouteRepo {

  Future<List<Route>> getRoutesForSector(String key) {
    return Future.delayed(Duration(seconds: 2), () {
      return [
        Route(
          name: 'Silence',
          grade: 'V1',
          setter: 'Adam Ondra',
          rating: 1.0,
          description: 'Heinous moves to even more heinous holds. Eat your Wheaties, kids. Could be downgraded',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
        Route(
          name: 'Burden of Dreams',
          grade: 'V17',
          setter: 'Nalle Huka?',
          rating: -2.0,
          description: 'A testament to pain',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
        Route(
          name: 'The Process',
          grade: 'V14',
          setter: 'Daniel Woods',
          rating: 3.0,
          description: 'Just trust your feet and pray. Casual V7 slab topout',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
        Route(
          name: 'Pink One',
          grade: 'V3',
          setter: 'Conner',
          rating: 2.3,
          description: 'Low quality. Contrived. Pull harder. V9 in your gym.',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
        Route(
          name: 'Linear Algebra Done Right',
          grade: 'V6',
          setter: 'Axler',
          rating: 0.6,
          description: 'Maybe not the best route, but it gets the job done.',
          imageUrl: 'https://i.ytimg.com/vi/CHE5ssb2aBs/maxresdefault.jpg',
        ),
      ];
    });
  }

}
