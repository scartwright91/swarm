package swarm;

class Rat {

    public var spr : h2d.Object;
    var g : h2d.Graphics;

    public function new(x:Float, y:Float) {
        spr = new h2d.Object();
        Game.ME.scroller.add(spr, Settings.ENTITY_LAYER);
    }

}