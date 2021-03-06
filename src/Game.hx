import swarm.Swarm;
import hxd.res.DefaultFont;

class Game {

    public static var ME : Game;

    // world
    public var world : World;
    public var nLevels : Int;
    public var levelCounter : Int = 0;
    public var level : Level;
    public var scroller : h2d.Layers;

    public var player : Player;
    public var camera : Camera;

    public var swarmInfo : h2d.Text;
    public var swarmStarted : Bool = false;
    public var swarmCountdown : Float;
    public var swarmTimer : Float;
    public var swarm : Swarm;

    var lightOrbs : Array<LightOrb> = [];

    // vfx
    public var vfx : VFX;
    var clouds : Array<Cloud>;

    // sfx
    public var spellSFX : hxd.res.Sound;
    public var rumbleSFX : hxd.res.Sound;

    // score
    var wavesSurvived : Int;
    var scoreInfo : h2d.Text;

    public function new() {

        ME = this;

        scroller = new h2d.Layers(Main.ME.gameScene2d);

        // vfx
        vfx = new VFX();

        // sfx
        spellSFX = hxd.Res.sound.spell;
        spellSFX.getData();
        spellSFX.play(false, 0);

        // create level
        world = new World();
        level = new Level(world.levels[levelCounter]);

        clouds = [];
        for (idx in 0...20) {
            var x = Std.int(Math.random() * 2 * level.pxWid - level.pxWid);
            var y = Std.int(Math.random() * level.pxHei);
            var c = new Cloud(x, y);
            clouds.push(c);
        }

        player = new Player(10, 10);
        camera = new Camera(player.spr);

        swarm = new Swarm();
        swarmCountdown = hxd.Timer.lastTimeStamp;

        createInfoBoxes();

        // set resizing function
        hxd.Window.getInstance().addResizeEvent(resize);

    }

    public function update(dt : Float) {

        var now = hxd.Timer.lastTimeStamp;
        scoreInfo.text = 'Waves survived: ' + Std.string(swarm.wave - 1);
        
        player.update();
        camera.update();
        swarm.update();
        level.update();
        vfx.drawVisibility();

        for (cloud in clouds)
            cloud.update();

        for (orb in lightOrbs) {
            if (player.distanceFrom(orb.pos) < 50) {
                lightOrbs.remove(orb);
                orb.destroy();
            } 
        }

        if (!swarmStarted) {
            if (now - swarmCountdown > 10) {
                createLightOrbs();
                swarm.addSwarm();
                swarmStarted = true;
                swarmInfo.text = 'Avoid the swarm!';
            } else {
                swarmInfo.text = 'Swarm coming in ' + Std.string(10 - Std.int(now - swarmCountdown));
            }
        }

    }

    function createInfoBoxes() {
        // info
        swarmInfo = new h2d.Text(DefaultFont.get(), Main.ME.gameScene2d);
        swarmInfo.scale(4);
        swarmInfo.color.setColor(Utils.RGBToCol(230, 230, 236, 255));

        scoreInfo = new h2d.Text(DefaultFont.get(), Main.ME.gameScene2d);
        scoreInfo.y = 50;
        scoreInfo.scale(4);
        scoreInfo.color.setColor(Utils.RGBToCol(230, 230, 236, 255));
    }

    function createLightOrbs() {
        if (lightOrbs.length > 0) {
            for (orb in lightOrbs) {
                orb.destroy();
                lightOrbs.remove(orb);
            }
        }
        for (idx in 0...4) {
            var lightOrb = new LightOrb(
                2 + Math.random() * (level.gridLengthX - 2), 
                2 + Math.random() * (level.gridLengthY - 2)
            );
            lightOrbs.push(lightOrb);
        }
    }

    function resize() {
        vfx.createVisibilityTexture();
        player.createHealthAndEnergy();
        createInfoBoxes();
    }

}