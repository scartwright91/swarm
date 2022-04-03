import h2d.col.Point;
import h2d.Object;


class LightOrb {

    var spr : Object;
    public var pos : h2d.col.Point;
    var g : h2d.Graphics;

    public function new(x:Float, y:Float) {
        spr = new h2d.Object();
        Game.ME.scroller.add(spr, Settings.ENTITY_LAYER);
        spr.x = x * Settings.TILE_SIZE * Settings.SCALE;
        spr.y = y * Settings.TILE_SIZE * Settings.SCALE;

        pos = new h2d.col.Point(spr.x, spr.y);

        var orb = hxd.Res.light_orb.toTile();
        g = new h2d.Graphics(spr);
        g.filter = new h2d.filter.Group([
            new h2d.filter.Glow(Utils.RGBToCol(230, 230, 236, 255), 50, 2),
            new h2d.filter.Blur(3)
        ]);
        g.drawTile(0, 0, orb);
    }

    public function destroy() {
        Game.ME.player.visibilityRadius = 200 * Settings.SCALE;
        spr.remove();
    }

}