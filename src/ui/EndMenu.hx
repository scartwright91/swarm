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
        g.beginFill(Utils.RGBToCol(14, 14, 18, 255));
        g.drawRect(0, 0, w, h);
        g.endFill();

        txt = new h2d.Text(DefaultFont.get(), menuScene);
        txt.text = "You have been claimed by the swarm";
        txt.scale(6);
        var size = txt.getSize();
        var bds = txt.getBounds();
        txt.x = w / 2 - size.xMax / 2;
        txt.y = h / 3 - size.yMax / 2;
        txt.color.setColor(Utils.RGBToCol(193, 193, 210, 255));

    }

}