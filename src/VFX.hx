import h2d.Object;
import h2d.Layers;
import shaders.VisibleShader;
import h2d.Bitmap;
import h3d.mat.Texture;


class VFX {

    var visibilityTexture : h3d.mat.Texture;
    var visibilityBitmap : h2d.Bitmap;

    var reflectionTexture : h3d.mat.Texture;
    var reflectionBitmap : h2d.Bitmap;

    var visbility : h2d.Graphics;
    var reflection : h2d.Graphics;

    public function new () {

        createVisibilityTexture();
        // // reflection
        // reflectionTexture = new Texture(w, h, [Target]);
        // reflectionBitmap = new Bitmap(h2d.Tile.fromTexture(reflectionTexture));
        // //Main.ME.gameScene2d.addChild(reflectionBitmap);
        // reflection = new h2d.Graphics();
    }

    public function drawVisibility() {
        visibilityTexture.clear(0, 1);
        visbility.x = Main.ME.windowWidth/2;
        visbility.y = Main.ME.windowHeight/2;
        visbility.clear();
        visbility.beginFill(Utils.RGBToCol(255, 255, 255, 255));
        visbility.drawCircle(
            Settings.TILE_SIZE * Settings.SCALE/2,
            Settings.TILE_SIZE * Settings.SCALE/2,
            Game.ME.player.visibilityRadius
        );
        visbility.endFill();
        visbility.drawTo(visibilityTexture);
    }

    public function createVisibilityTexture() {

        var win = hxd.Window.getInstance();
        var w = Std.int(win.width);
        var h = Std.int(win.height);

        // visibility
        Main.ME.gameScene2d.removeChild(visibilityBitmap);
        visibilityTexture = new Texture(w, h, [Target]);
        visibilityBitmap = new Bitmap(h2d.Tile.fromTexture(visibilityTexture));
        var testShader = new shaders.VisibleShader(visibilityTexture);
        visibilityBitmap.addShader(testShader);
        Main.ME.gameScene2d.addChild(visibilityBitmap);
        visbility = new h2d.Graphics();
    }

    public function drawReflection() {
        reflectionTexture.clear(0, 1);
        reflection.clear();
        var pg = Game.ME.player.reflection;
        pg.drawTo(reflectionTexture);
    }

}