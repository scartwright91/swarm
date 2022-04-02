package ui;

import hxd.Window;
import hxd.res.DefaultFont;
import h2d.Text;



class EndMenu {

    var txt : Text;
    public var menuScene : h2d.Scene;
    var g : h2d.Graphics;

    public function new() {
        // create menu scene and text
        var w = Window.getInstance().width;
        var h = Window.getInstance().height;
        menuScene = new h2d.Scene();

        g = new h2d.Graphics(menuScene);
        g.beginFill(0xEA8220);
        g.drawRect(0, 0, w, h);
        g.endFill();

        txt = new h2d.Text(DefaultFont.get(), menuScene);
        txt.x = w / 4;
        txt.y = h / 2;
        txt.text = "Thanks for playing!";
        txt.color.setColor(Utils.RGBToCol(0, 0, 0, 255));
        txt.scale(6);

    }

}