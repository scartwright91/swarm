import hxd.Key;
import h2d.Object;

class Player {

    public var spr : h2d.Object;
    var g : h2d.Graphics;

    // location vars
    var tile : h2d.col.IPoint;
    var tileX : Int;
    var tileY : Int;

    // movement vars
    var dx : Float = 0;
    var dy : Float = 0;
    var speed : Float = 8;

    public function new(x, y) {

        spr = new h2d.Object();
        Game.ME.scroller.add(spr, Settings.ENTITY_LAYER);
        spr.x = x * Settings.TILE_SIZE * Settings.SCALE;
        spr.y = y * Settings.TILE_SIZE * Settings.SCALE;

        tile = new h2d.col.IPoint(x, y);
        tileX = x;
        tileY = y;

        g = new h2d.Graphics(spr);
        g.beginFill(Utils.RGBToCol(255, 0, 0, 255));
        g.drawRect(0, 0, Settings.TILE_SIZE * Settings.SCALE, Settings.TILE_SIZE * Settings.SCALE);
        g.endFill();

    }

    public function update() {

        dx = dy = 0;

        if (Key.isDown(Key.A)) {
            dx = -speed;
        }
        if (Key.isDown(Key.D)) {
            dx = speed;
        }
        if (Key.isDown(Key.W)) {
            dy = -speed;
        }
        if (Key.isDown(Key.S)) {
            dy = speed;
        }

        // TODO:
        // clamp diagonal direction speed
        // use delta time in speed var

        spr.x += dx;
        spr.y += dy;

        tile = posToTile(spr.x, spr.y);

    }

    function posToTile(x:Float, y:Float) : h2d.col.IPoint {
        var tx = Std.int(spr.x / (Settings.TILE_SIZE * Settings.SCALE));
        var ty = Std.int(spr.y / (Settings.TILE_SIZE * Settings.SCALE));
        return new h2d.col.IPoint(tx, ty);
    }

}