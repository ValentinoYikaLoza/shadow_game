abstract class Sprites {
  final List<String> images;

  const Sprites({required this.images});
}

class DoorSprite extends Sprites {
  const DoorSprite(List<String> images) : super(images: images);

  static const open =
      DoorSprite(['assets/images/level_one/door/open_door.png']);

  static const close =
      DoorSprite(['assets/images/level_one/door/close_door.png']);
}

class ChestSprite extends Sprites {
  const ChestSprite(List<String> images) : super(images: images);

  static const open =
      ChestSprite(['assets/images/level_one/chest/open_chest.png']);

  static const close =
      ChestSprite(['assets/images/level_one/chest/close_chest.png']);
}
