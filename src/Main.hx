
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
    public var reflectionScene : h2d.Scene; 

    // music
    var music : hxd.res.Sound;

    // fps
    var fps : h2d.Text;

    override function init() {

        ME = this;

        music = hxd.Res.sound.music;
        music.play(true, 0.5);

        gameScene2d = s2d;
        reflectionScene = new h2d.Scene();

        // Create menu and set the scene
        menu = new ui.StartMenu();
        end = new ui.EndMenu();

        resizeWindow();
        hxd.Window.getInstance().addResizeEvent(resizeWindow);
        
        menuRunning = true;
        setScene(menu.menuScene);

        // render fps
        fps = new h2d.Text(DefaultFont.get(), gameScene2d);
        fps.text = "";
        fps.scale(2);

    }

    override function update(dt:Float) {
        if (!menuRunning) {
            fps.text = "FPS: " + Std.int(1 / dt);
            game.update(dt);
        } else if (!gameFinished) {
            menu.update();
        }
    }

    override function render(e:h3d.Engine) {
		s2d.render(e);
    }

    public function enterGame() {
        menuRunning = false;
        game = new Game();
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

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}
