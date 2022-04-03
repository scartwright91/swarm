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

    var normalMap : h2d.Tile;

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
        
        normalMap = hxd.Res.normalMap.toTile();
        var glogo = new h2d.Graphics(g);
        var logo = hxd.Res.logo.toTile();
        glogo.drawTile(0, 0, logo);
        glogo.filter = new h2d.filter.Group([
            new h2d.filter.Glow(Utils.RGBToCol(230, 230, 236, 255), 50, 2),
            new h2d.filter.Displacement(normalMap, 3, 3),
            //new h2d.filter.Blur(3)
        ]);
        glogo.scale(4);
        glogo.x = w / 2 - glogo.getSize().xMax/2;

        var play = new h2d.Text(DefaultFont.get(), menuScene);
        play.scale(6);
        play.text = "Click here to play";
        play.x = w / 2 - play.getSize().xMax/2;
        play.y = 3 * h / 4;
        play.color.setColor(Utils.RGBToCol(193, 193, 210, 255));

        var controlsText = new h2d.Text(DefaultFont.get(), menuScene);
        controlsText.scale(5);
        controlsText.text = "WASD to move; SPACE to cast spell";
        controlsText.x = w / 2 - controlsText.getSize().xMax/2;
        controlsText.y = h / 2;
        controlsText.color.setColor(Utils.RGBToCol(193, 193, 210, 255));

        // create interactive box around text
        var i = new h2d.Interactive(play.textWidth, play.textHeight, play);
        i.onClick = function(_) {
            Main.ME.enterGame();
        }

    }

    public function update() {
        normalMap.scrollDiscrete(2, 2);
    }

    function resizeMenu() {
        w = hxd.Window.getInstance().width;
        h = hxd.Window.getInstance().height;
    }

}