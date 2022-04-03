class Cloud {
    
    var spr : h2d.Object;
    var g : h2d.Graphics;
    var speed : Float;

    public function new(x, y) {
        var cloud1 = hxd.Res.clouds.cloud1.toTile();
        var cloud2 = hxd.Res.clouds.cloud2.toTile();

        spr = new h2d.Object();
        Game.ME.scroller.add(spr, 2);
        spr.x = x;
        spr.y = y;

        speed = Math.random() > 0.5 ? 1 : 1.5;

        g = new h2d.Graphics(spr);
        g.drawTile(0, 0, Math.random() > 0.5 ? cloud1 : cloud2);
        g.scale(1 + Math.random());
        g.alpha = 0.3;
    }

    public function update() {
        spr.x += speed;
        if (spr.x > Game.ME.level.pxWid) {
            spr.x = -g.getSize().xMax;
        }
    }

}