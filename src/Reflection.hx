import h2d.Bitmap;
import h3d.mat.Texture;
import h3d.Engine;

class Reflection {

    var reflectionTexture : h3d.mat.Texture;
    var reflectionBitmap : h2d.Bitmap;

    public function new () {

        var win = hxd.Window.getInstance();
        var w = Std.int(win.width);
        var h = Std.int(win.height);

        reflectionTexture = new Texture(w, h, [Target]);
        reflectionBitmap = new Bitmap(h2d.Tile.fromTexture(reflectionTexture));
        Main.ME.s2d.addChild(reflectionBitmap);
        reflectionBitmap.x = 0;
        reflectionBitmap.y = 0;

    }

    public function render(e:Engine) {
        e.pushTarget(reflectionTexture);
        e.clear(0, 1);
        Main.ME.reflectionScene.addChild(Game.ME.player.spr);
        Main.ME.reflectionScene.render(e);
        e.popTarget();
        Game.ME.scroller.add(Game.ME.player.spr, Settings.ENTITY_LAYER);
    }


}