import 'package:gumby_project/models/sector.dart';

class SectorRepo {

  List<Sector> getSectors() {
    return [
      Sector(
        id: 'A',
        name: 'Discount Half Dome',
        imageUrl: 'https://i.imgur.com/4WildHn.jpg',
        thumbnailUrl: 'https://i.imgur.com/BhewMAD.jpg',
      ),
      Sector(
        id: 'B',
        name: 'Smoll Woll',
        imageUrl: 'https://i.imgur.com/3aW8sgf.jpg',
        thumbnailUrl: 'https://i.imgur.com/D8Np38o.jpg',
      ),
      Sector(
        id: 'C',
        name: 'Prow Right',
        imageUrl: 'https://i.imgur.com/Skcngb6.jpg',
        thumbnailUrl: 'https://i.imgur.com/ZIDpuFi.jpg',
      ),
      Sector(
        id: 'D',
        name: 'Prow Left',
        imageUrl: 'https://i.imgur.com/ltSiAWx.jpg',
        thumbnailUrl: 'https://i.imgur.com/fMsGVNq.jpg',
      ),
      Sector(
        id: 'E',
        name: 'The Almost Vertical',
        imageUrl: 'https://i.imgur.com/B8gutrA.jpg',
        thumbnailUrl: 'https://i.imgur.com/z7uoVs3.jpg',
      ),
      Sector(
        id: 'F',
        name: 'Egg Wall',
        imageUrl: 'https://i.imgur.com/7cVwLHe.jpg',
        thumbnailUrl: 'https://i.imgur.com/1DJvXL1.jpg',
      ),
      Sector(
        id: 'G',
        name: 'Slab City',
        imageUrl: 'https://i.imgur.com/eYfkijX.jpg',
        thumbnailUrl: 'https://i.imgur.com/G3sprPl.jpg',
      ),
      Sector(
        id: 'H',
        name: 'Budget El Cap',
        imageUrl: 'https://i.imgur.com/8cOYvpt.jpg',
        thumbnailUrl: 'https://i.imgur.com/M0oHIJo.jpg',
      ),
    ];
  }
}
