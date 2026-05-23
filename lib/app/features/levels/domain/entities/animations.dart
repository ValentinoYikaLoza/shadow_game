enum Directions { right, left }

abstract class Animations {
  final List<String> images;
  final int frames;
  final bool loop;
  final double fps;

  const Animations({
    required this.images,
    required this.frames,
    required this.loop,
    required this.fps,
  });
}

class PlayerAnimation extends Animations {
  const PlayerAnimation(
    List<String> images,
    int frames,
    bool loop,
    double fps,
  ) : super(
          images: images,
          frames: frames,
          loop: loop,
          fps: fps,
        );

  static const stay = PlayerAnimation(
    [
      'assets/frames/player/stay/frame_0.png',
      'assets/frames/player/stay/frame_1.png',
      'assets/frames/player/stay/frame_2.png',
      'assets/frames/player/stay/frame_3.png',
    ],
    4,
    true,
    0.2,
  );

  static const walk = PlayerAnimation(
    [
      'assets/frames/player/walk/frame_0.png',
      'assets/frames/player/walk/frame_1.png',
      'assets/frames/player/walk/frame_2.png',
      'assets/frames/player/walk/frame_3.png',
      'assets/frames/player/walk/frame_4.png',
      'assets/frames/player/walk/frame_5.png',
      'assets/frames/player/walk/frame_6.png',
      'assets/frames/player/walk/frame_7.png',
    ],
    8,
    true,
    0.1,
  );

  static const attack = PlayerAnimation(
    [
      'assets/frames/player/attack/frame_0.png',
      'assets/frames/player/attack/frame_1.png',
      'assets/frames/player/attack/frame_2.png',
      'assets/frames/player/attack/frame_3.png',
    ],
    4,
    false,
    0.05,
  );

  static const dance = PlayerAnimation(
    [
      'assets/frames/player/dance/frame_0.png',
      'assets/frames/player/dance/frame_1.png',
      'assets/frames/player/dance/frame_2.png',
      'assets/frames/player/dance/frame_3.png',
      'assets/frames/player/dance/frame_4.png',
      'assets/frames/player/dance/frame_5.png',
      'assets/frames/player/dance/frame_6.png',
      'assets/frames/player/dance/frame_7.png',
      'assets/frames/player/dance/frame_8.png',
      'assets/frames/player/dance/frame_9.png',
    ],
    10,
    true,
    0.2,
  );

  static const jump = PlayerAnimation(
    [
      'assets/frames/player/jump/frame_0.png',
      'assets/frames/player/jump/frame_1.png',
      'assets/frames/player/jump/frame_2.png',
      'assets/frames/player/jump/frame_3.png',
      'assets/frames/player/jump/frame_4.png',
    ],
    5,
    true,
    0.1,
  );
}

class ShadowAnimation extends Animations {
  const ShadowAnimation(
    List<String> images,
    int frames,
    bool loop,
    double fps,
  ) : super(
          images: images,
          frames: frames,
          loop: loop,
          fps: fps,
        );

  static const sit = ShadowAnimation(
    [
      'assets/frames/shadow/sit/frame_0.png',
      'assets/frames/shadow/sit/frame_1.png',
      'assets/frames/shadow/sit/frame_2.png',
      'assets/frames/shadow/sit/frame_3.png',
      'assets/frames/shadow/sit/frame_4.png',
      'assets/frames/shadow/sit/frame_5.png',
    ],
    6,
    true,
    0.2,
  );

  static const walk = ShadowAnimation(
    [
      'assets/frames/shadow/walk/frame_0.png',
      'assets/frames/shadow/walk/frame_1.png',
      'assets/frames/shadow/walk/frame_2.png',
      'assets/frames/shadow/walk/frame_3.png',
    ],
    4,
    true,
    0.15,
  );

  static const bark = ShadowAnimation(
    [
      'assets/frames/shadow/bark/frame_0.png',
      'assets/frames/shadow/bark/frame_1.png',
      'assets/frames/shadow/bark/frame_2.png',
      'assets/frames/shadow/bark/frame_3.png',
      'assets/frames/shadow/bark/frame_4.png',
      'assets/frames/shadow/bark/frame_5.png',
      'assets/frames/shadow/bark/frame_6.png',
      'assets/frames/shadow/bark/frame_7.png',
    ],
    8,
    true,
    0.1,
  );
}

class SpiderAnimation extends Animations {
  const SpiderAnimation(
    List<String> images,
    int frames,
    bool loop,
    double fps,
  ) : super(
          images: images,
          frames: frames,
          loop: loop,
          fps: fps,
        );

  static const stay = SpiderAnimation(
    [
      'assets/frames/spider/stay/frame_0.png',
      'assets/frames/spider/stay/frame_1.png',
      'assets/frames/spider/stay/frame_2.png',
      'assets/frames/spider/stay/frame_3.png',
      'assets/frames/spider/stay/frame_4.png',
    ],
    5,
    true,
    0.1,
  );

  static const walk = SpiderAnimation(
    [
      'assets/frames/spider/walk/frame_0.png',
      'assets/frames/spider/walk/frame_1.png',
      'assets/frames/spider/walk/frame_2.png',
      'assets/frames/spider/walk/frame_3.png',
    ],
    4,
    true,
    0.2,
  );

  static const attack = SpiderAnimation(
    [
      'assets/frames/spider/attack/frame_00.png',
      'assets/frames/spider/attack/frame_01.png',
      'assets/frames/spider/attack/frame_02.png',
      'assets/frames/spider/attack/frame_03.png',
      'assets/frames/spider/attack/frame_04.png',
      'assets/frames/spider/attack/frame_05.png',
      'assets/frames/spider/attack/frame_06.png',
      'assets/frames/spider/attack/frame_07.png',
      'assets/frames/spider/attack/frame_08.png',
      'assets/frames/spider/attack/frame_09.png',
      'assets/frames/spider/attack/frame_10.png',
      'assets/frames/spider/attack/frame_11.png',
      'assets/frames/spider/attack/frame_12.png',
      'assets/frames/spider/attack/frame_13.png',
      'assets/frames/spider/attack/frame_14.png',
      'assets/frames/spider/attack/frame_15.png',
    ],
    16,
    true,
    0.08,
  );

  static const die = SpiderAnimation(
    [
      'assets/frames/spider/die/frame_00.png',
      'assets/frames/spider/die/frame_01.png',
      'assets/frames/spider/die/frame_02.png',
      'assets/frames/spider/die/frame_03.png',
      'assets/frames/spider/die/frame_04.png',
      'assets/frames/spider/die/frame_05.png',
      'assets/frames/spider/die/frame_06.png',
      'assets/frames/spider/die/frame_07.png',
      'assets/frames/spider/die/frame_08.png',
      'assets/frames/spider/die/frame_09.png',
      'assets/frames/spider/die/frame_10.png',
      'assets/frames/spider/die/frame_11.png',
      'assets/frames/spider/die/frame_12.png',
      'assets/frames/spider/die/frame_13.png',
      'assets/frames/spider/die/frame_14.png',
      'assets/frames/spider/die/frame_15.png',
      'assets/frames/spider/die/frame_16.png',
    ],
    17,
    false,
    0.05,
  );
}

class CoinAnimation extends Animations {
  const CoinAnimation(
    List<String> images,
    int frames,
    bool loop,
    double fps,
  ) : super(
          images: images,
          frames: frames,
          loop: loop,
          fps: fps,
        );

  static const looping = CoinAnimation(
    [
      'assets/frames/objects/coin/frame_0.png',
      'assets/frames/objects/coin/frame_1.png',
      'assets/frames/objects/coin/frame_2.png',
      'assets/frames/objects/coin/frame_3.png',
      'assets/frames/objects/coin/frame_4.png',
      'assets/frames/objects/coin/frame_5.png',
      'assets/frames/objects/coin/frame_6.png',
      'assets/frames/objects/coin/frame_7.png',
      'assets/frames/objects/coin/frame_8.png',
      'assets/frames/objects/coin/frame_9.png',
    ],
    10,
    true,
    0.1,
  );

  static const waiting = CoinAnimation(
    [
      'assets/frames/objects/coin/frame_0.png',
      'assets/frames/objects/coin/frame_1.png',
      'assets/frames/objects/coin/frame_2.png',
      'assets/frames/objects/coin/frame_3.png',
      'assets/frames/objects/coin/frame_4.png',
      'assets/frames/objects/coin/frame_5.png',
      'assets/frames/objects/coin/frame_6.png',
      'assets/frames/objects/coin/frame_7.png',
      'assets/frames/objects/coin/frame_8.png',
      'assets/frames/objects/coin/frame_9.png',
    ],
    10,
    true,
    0.1,
  );
}
