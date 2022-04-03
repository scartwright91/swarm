import h2d.Bitmap;
import h3d.mat.Texture;


class Visibility {

    public var visibilityTexture : h3d.mat.Texture;
    var visibilityBitmap : h2d.Bitmap;
    var g : h2d.Graphics;

    public function new () {

        var w = Std.int(Main.ME.windowWidth);
        var h = Std.int(Main.ME.windowHeight);

        visibilityTexture = new Texture(w, h, [Target]);
        visibilityBitmap = new Bitmap(h2d.Tile.fromTexture(visibilityTexture));
        
        var testShader = new shaders.TestShader(visibilityTexture);
        visibilityBitmap.addShader(testShader);

        Main.ME.gameScene2d.addChild(visibilityBitmap);

        g = new h2d.Graphics();
    }

    public function redraw() {
        visibilityTexture.clear(0, 1);
        g.x = Main.ME.windowWidth/2;
        g.y = Main.ME.windowHeight/2;
        g.clear();
        g.beginFill(Utils.RGBToCol(255, 255, 255, 255));
        g.drawCircle(
            Settings.TILE_SIZE * Settings.SCALE/2,
            Settings.TILE_SIZE * Settings.SCALE/2,
            Game.ME.player.visibilityRadius
        );
        g.endFill();
        g.drawTo(visibilityTexture);
    }


}