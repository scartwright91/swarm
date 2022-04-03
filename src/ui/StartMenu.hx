package ui;

import hxd.Window;
import hxd.res.DefaultFont;
import h2d.Text;

class StartMenu {

    var txt : Text;
    public var menuScene : h2d.Scene;
    var i : h2d.Interactive;
    var g : h2d.Graphics;

    var w : Float;
    var h : Float;

    public function new() {

        // create menu scene and text
        w = Window.getInstance().width;
        h = Window.getInstance().height;

        menuScene = new h2d.Scene();

        //specify a color we want to draw with
        var g = new h2d.Graphics(menuScene);
        g.beginFill(Utils.RGBToCol(14, 14, 18, 255));
        g.drawRect(0, 0, w, h);
        g.endFill();

        hxd.Window.getInstance().addResizeEvent(resizeMenu);      

        var play = new h2d.Text(DefaultFont.get(), menuScene);
        play.text = "Click here to play";
        play.x = w / 10;
        play.y = h / 4;
        play.color.setColor(Utils.RGBToCol(193, 193, 210, 255));
        play.scale(6);

        // create interactive box around text
        var i = new h2d.Interactive(play.textWidth, play.textHeight, play);
        i.onClick = function(_) {
            Main.ME.enterGame();
        }

    }

    function resizeMenu() {
        w = hxd.Window.getInstance().width;
        h = hxd.Window.getInstance().height;
    }

}