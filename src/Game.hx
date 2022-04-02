
import hxd.Key;
import hxd.res.DefaultFont;



class Game {

    public static var ME : Game;

    public var world : World;
    public var nLevels : Int;
    public var levelCounter : Int = 0;
    public var level : Level;

    var obj : h2d.Object;
    var normalMap : h2d.Tile;

    // fps
    var fps : h2d.Text;

    public function new() {

        ME = this;

        // render fps
        fps = new h2d.Text(DefaultFont.get(), Main.ME.gameScene2d);
        fps.text = "";
        fps.scale(2);

        // create level
        // world = new World();
        // level = new Level(world.levels[levelCounter]);

        //Create a custom graphics object by passing a 2d scene reference.
        obj = new h2d.Object(Main.ME.gameScene2d);
        obj.x = Main.ME.windowWidth/2;
        obj.y = Main.ME.windowHeight/2;
        var customGraphics = new h2d.Graphics(obj);
        customGraphics.beginFill(0xEA8220);
        customGraphics.drawRect(0, 0, 300, 200);
        customGraphics.endFill();

        var bmp = new h2d.Bitmap()

        normalMap = hxd.Res.normalMap.toTile();
        obj.filter = new h2d.filter.Displacement(normalMap, 4, 4);

    }

    public function update(dt : Float) {
        normalMap.scrollDiscrete(1.2 * dt * 40, 2.4 * dt * 40);
    }

}