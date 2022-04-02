class Game {

    public static var ME : Game;

    // world
    public var world : World;
    public var nLevels : Int;
    public var levelCounter : Int = 0;
    public var level : Level;
    public var scroller : h2d.Layers;

    public var player : Player;
    public var camera : Camera;

    public function new() {

        ME = this;

        scroller = new h2d.Layers(Main.ME.gameScene2d);

        // create level
        world = new World();
        level = new Level(world.levels[levelCounter]);

        player = new Player(10, 10);
        camera = new Camera(player.spr);

        //Create a custom graphics object by passing a 2d scene reference.
        // obj = new h2d.Object(Main.ME.gameScene2d);
        // obj.x = Main.ME.windowWidth/2;
        // obj.y = Main.ME.windowHeight/2;
        // var customGraphics = new h2d.Graphics(obj);
        // customGraphics.beginFill(0xEA8220);
        // customGraphics.drawRect(0, 0, 300, 200);
        // customGraphics.endFill();

        // normalMap = hxd.Res.normalMap.toTile();
        // obj.filter = new h2d.filter.Displacement(normalMap, 4, 4);

    }

    public function update(dt : Float) {
        player.update();
        camera.update();
        // normalMap.scrollDiscrete(1.2 * dt * 40, 2.4 * dt * 40);
    }

}