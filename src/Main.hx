
import hxd.res.DefaultFont;

@:access(h2d.Scene)
class Main extends hxd.App {

    public static var ME : Main;
    public var game : Game;
    public var menu : ui.StartMenu;
    public var end : ui.EndMenu;
    public var menuRunning : Bool;
    public var gameFinished : Bool = false;
    public var delta : Float = 0;
    public var windowWidth : Float;
    public var windowHeight : Float;

    // scenes
    public var gameScene2d : h2d.Scene;
    public var gameScene3d : h3d.scene.Scene;

    // fps
    var fps : h2d.Text;

    // debugging
	var fui : h2d.Flow;

    override function init() {

        ME = this;

        gameScene2d = s2d;
        gameScene3d = s3d;

        // Create menu and set the scene
        menu = new ui.StartMenu();
        end = new ui.EndMenu();

        hxd.Window.getInstance().addResizeEvent(resizeWindow);

        windowWidth = hxd.Window.getInstance().width;
        windowHeight = hxd.Window.getInstance().height;
        
        menuRunning = true;
        setScene(menu.menuScene);

        game = new Game();

        // render fps
        fps = new h2d.Text(DefaultFont.get(), gameScene2d);
        fps.text = "";
        fps.scale(2);

        // debugging
		fui = new h2d.Flow(gameScene2d);
		fui.layout = Vertical;
		fui.verticalSpacing = 5;
		fui.padding = 10;

        addSlider("Alignment", function() return game.swarm.baseAlignmentWeight, function(v) game.swarm.baseAlignmentWeight = v, 0, 1);
        addSlider("Cohesion", function() return game.swarm.baseCohesionWeight, function(v) game.swarm.baseCohesionWeight = v, 0, 1);
        addSlider("Separation", function() return game.swarm.baseSeparationWeight, function(v) game.swarm.baseSeparationWeight = v, 0, 1);

    }

    override function update(dt:Float) {
        if (!menuRunning) {
            fps.text = "FPS: " + Std.int(1 / dt);
            game.update(dt);
        }
    }

    public function enterGame() {
        menuRunning = false;
        //s2d.events.defaultCursor = hxd.Cursor.Hide;
        setScene(gameScene2d, false);
    }

    public function enterMenu() {
        menuRunning = true;
        s2d.events.defaultCursor = hxd.Cursor.Default;
        setScene(menu.menuScene, false);
    }

    public function completeGame() {
        menuRunning = true;
        gameFinished = true;
        s2d.events.defaultCursor = hxd.Cursor.Default;
        setScene(end.menuScene, false);
    }

    function resizeWindow() {
        windowWidth = hxd.Window.getInstance().width;
        windowHeight = hxd.Window.getInstance().height;
    }

	function addSlider( label : String, get : Void -> Float, set : Float -> Void, min : Float = 0., max : Float = 1. ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(hxd.res.DefaultFont.get(), f);
		tf.text = label;
		tf.maxWidth = 70;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(hxd.res.DefaultFont.get(), f);
		tf.text = "" + hxd.Math.fmt(sli.value);
		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};
		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);
			if( Math.isNaN(v) ) return;
			sli.value = v;
			set(v);
		};
		return sli;
	}

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}
