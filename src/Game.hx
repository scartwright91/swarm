import swarm.Swarm;

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

    public var swarm : Swarm;
    // vfx
    public var reflection : Reflection; 

    public function new() {

        ME = this;

        scroller = new h2d.Layers(Main.ME.gameScene2d);

        // create level
        world = new World();
        level = new Level(world.levels[levelCounter]);

        player = new Player(10, 10);
        camera = new Camera(player.spr);

        swarm = new Swarm();

        // vfx
        //reflection = new Reflection();

    }

    public function update(dt : Float) {
        player.update();
        camera.update();
        swarm.update();
        level.update();
    }

}