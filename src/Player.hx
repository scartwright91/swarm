import h2d.Graphics;
import hxd.Key;
import h2d.Object;


enum Facing {
    Forward;
    Back;
    Left;
    Right;
}


class Player {

    public var spr : h2d.Object;
    public var g : h2d.Graphics;
    public var reflection : Graphics;

    // player vars
    public var health : Float = 100;
    var energy : Float = 85;
    var magic : Float = 100;
    var healthBar : h2d.Graphics;
    var energyBar : h2d.Graphics;
    var magicBar : h2d.Graphics;

    public var visibilityRadius : Float = 200 * Settings.SCALE;

    // location vars
    var tile : h2d.col.IPoint;
    public var center : h2d.col.Point;

    // movement vars
    var dx : Float = 0;
    var dy : Float = 0;
    var speed : Float = 8;

    // animation
    var animations : Map<String, Array<h2d.Tile>>;
    var orientation : Facing;
    var frame : Int = 0;
    var animationTimer : Float = hxd.Timer.lastTimeStamp;

    // spell
    var spellFrame : Int = 0;
    var spellImages : Array<h2d.Tile>;
    var spell : h2d.Graphics;
    public var spellCast : Bool = false;
    var spellDuration : Float;
    var magicRecoverRate : Float = 0.15;

    public function new(x, y) {

        spr = new h2d.Object();
        Game.ME.scroller.add(spr, Settings.ENTITY_LAYER);
        spr.x = x * Settings.TILE_SIZE * Settings.SCALE;
        spr.y = y * Settings.TILE_SIZE * Settings.SCALE;
        center = new h2d.col.Point(
            (spr.x + Settings.TILE_SIZE * Settings.SCALE)/2,
            (spr.y + Settings.TILE_SIZE * Settings.SCALE)/2
        );

        tile = new h2d.col.IPoint(x, y);

        animations = readAnimations();

        spellImages = [
            hxd.Res.spell_png.toTile(),
            hxd.Res.spell1.toTile(),
            hxd.Res.spell2.toTile(),
            hxd.Res.spell3.toTile()
        ];

        g = new h2d.Graphics(spr);
        g.drawTile(0, 0, animations["forward"][0]);

        createHealthAndEnergy();

    }

    public function update() {

        if (health <= 0) {
            Main.ME.completeGame();
        }

        if (visibilityRadius > 100)
            visibilityRadius -= 0.1;

        if ((magic < 100)) {
            magic += magicRecoverRate;
            if (magic > 100)
                magic = 100;
        }

        drawHealthAndEnergy();

        if (Key.isReleased(Key.B)) {
            Game.ME.swarm.addSwarm();
        }

        if ((Key.isPressed(Key.SPACE)) && (magic == 100)) {
            castSpell();
        }

        if (spellCast) {
            var diff = hxd.Timer.lastTimeStamp - spellDuration;
            if (diff > 1) {
                spellCast = false;
                spr.removeChild(spell);
            }
        }

        // movement
        dx = dy = 0;

        if (Key.isDown(Key.A)) {
            dx = -(speed * energy/100);
            orientation = Left;
        }
        if (Key.isDown(Key.D)) {
            dx = (speed * energy/100);
            orientation = Right;
        }
        if (Key.isDown(Key.W)) {
            dy = -(speed * energy/100);
            orientation = Back;
        }
        if (Key.isDown(Key.S)) {
            dy = (speed * energy/100);
            orientation = Forward;
        }

        if ((dx != 0) || (dy != 0)) {
            animate();
        }

        // TODO:
        // clamp diagonal direction speed
        // use delta time in speed var

        spr.x += dx;
        spr.y += dy;

        if (spr.x < Settings.TILE_SIZE * Settings.SCALE) {
            spr.x = Settings.TILE_SIZE * Settings.SCALE;
        }
        if (spr.x > Game.ME.level.pxWid - 2 * (Settings.TILE_SIZE * Settings.SCALE)) {
            spr.x = Game.ME.level.pxWid - 2 * (Settings.TILE_SIZE * Settings.SCALE);
        }
        if (spr.y < Settings.TILE_SIZE * Settings.SCALE) {
            spr.y = Settings.TILE_SIZE * Settings.SCALE;
        }
        if (spr.y > Game.ME.level.pxHei - 2 * (Settings.TILE_SIZE * Settings.SCALE)) {
            spr.y = Game.ME.level.pxHei - 2 * (Settings.TILE_SIZE * Settings.SCALE);
        }

        center = new h2d.col.Point(
            spr.x + (Settings.TILE_SIZE * Settings.SCALE)/2,
            spr.y + (Settings.TILE_SIZE * Settings.SCALE)/2
        );

        tile = posToTile(spr.x, spr.y);

    }

    function animate() {
        var now = hxd.Timer.lastTimeStamp;
        if (now - animationTimer > 0.2) {
            g.clear();
            animationTimer = now;
            if (orientation == Forward) {
                frame += 1;
                if (frame > 2)
                    frame = 0;
                g.drawTile(0, 0, animations["forward"][frame]);
            } else if (orientation == Back) {
                frame += 1;
                if (frame > 2)
                    frame = 0;
                g.drawTile(0, 0, animations["back"][frame]);
            } else if (orientation == Left) {
                frame += 1;
                if (frame > 2)
                    frame = 0;
                g.drawTile(0, 0, animations["left"][frame]);
            } else if (orientation == Right) {
                frame += 1;
                if (frame > 2)
                    frame = 0;
                g.drawTile(0, 0, animations["right"][frame]);
            }
        }
    }

    function posToTile(x:Float, y:Float) : h2d.col.IPoint {
        var tx = Std.int(spr.x / (Settings.TILE_SIZE * Settings.SCALE));
        var ty = Std.int(spr.y / (Settings.TILE_SIZE * Settings.SCALE));
        return new h2d.col.IPoint(tx, ty);
    }

    function castSpell() {
        spell = new h2d.Graphics(spr);
        spell.filter = new h2d.filter.Group([
            new h2d.filter.Glow(Utils.RGBToCol(230, 230, 236, 255), 50, 2),
            // new h2d.filter.Displacement(disp, 3, 3),
            new h2d.filter.Blur(3),
            //new h2d.filter.DropShadow(8, Math.PI / 4)
        ]);

        spell.drawTile(
            (Settings.TILE_SIZE * Settings.SCALE)/2-200,
            (Settings.TILE_SIZE * Settings.SCALE)/2-200,
        spellImages[spellFrame]
        );
        spellCast = true;
        spellDuration = hxd.Timer.lastTimeStamp;
        spellFrame = 0;
        magic = 0;
    }

    public function createHealthAndEnergy() {

        healthBar = new h2d.Graphics(Main.ME.gameScene2d);
        // energyBar = new h2d.Graphics(Main.ME.gameScene2d);
        magicBar = new h2d.Graphics(Main.ME.gameScene2d);

        var w = Main.ME.windowWidth * 0.15;
        var h = Main.ME.windowHeight * 0.03;

        healthBar.x = Main.ME.windowWidth * 0.02;
        healthBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.15;
        healthBar.beginFill(Utils.RGBToCol(255, 0, 0, 255));
        healthBar.drawRect(0, 0, w, h);
        healthBar.endFill();

        // energyBar.x = Main.ME.windowWidth * 0.02;
        // energyBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.1;
        // energyBar.beginFill(Utils.RGBToCol(0, 0, 255, 255));
        // energyBar.drawRect(0, 0, w, h);
        // energyBar.endFill();

        magicBar.x = Main.ME.windowWidth * 0.02;
        magicBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.05;
        magicBar.beginFill(Utils.RGBToCol(255, 255, 0, 255));
        magicBar.drawRect(0, 0, w, h);
        magicBar.endFill();

    }

    function drawHealthAndEnergy() {

        var w = Main.ME.windowWidth * 0.15;
        var h = Main.ME.windowHeight * 0.03;

        healthBar.clear();
        healthBar.x = Main.ME.windowWidth * 0.02;
        healthBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.15;
        healthBar.beginFill(Utils.RGBToCol(255, 0, 0, 255));
        healthBar.drawRect(0, 0, w * health/100, h);
        healthBar.endFill();

        // energyBar.clear();
        // energyBar.x = Main.ME.windowWidth * 0.02;
        // energyBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.1;
        // energyBar.beginFill(Utils.RGBToCol(0, 0, 255, 255));
        // energyBar.drawRect(0, 0, w * energy / 100, h);
        // energyBar.endFill();

        magicBar.clear();
        magicBar.x = Main.ME.windowWidth * 0.02;
        magicBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.1;
        magicBar.beginFill(Utils.RGBToCol(255, 255, 0, 255));
        magicBar.drawRect(0, 0, w * magic / 100, h);
        if (magic < 100) {
            magicBar.alpha = 0.3;
        } else {
            magicBar.alpha = 1.0;
        }
        magicBar.endFill();

    }

    function readAnimations() : Map<String, Array<h2d.Tile>> {
        var forwardAnim = [
            hxd.Res.player.player_forward1.toTile(),
            hxd.Res.player.player_forward2.toTile(),
            hxd.Res.player.player_forward3.toTile()
        ];
        var sideRightAnim = [
            hxd.Res.player.player_side_right1.toTile(),
            hxd.Res.player.player_side_right2.toTile(),
            hxd.Res.player.player_side_right3.toTile()
        ];
        var sideLeftAnim = [
            hxd.Res.player.player_side_left1.toTile(),
            hxd.Res.player.player_side_left2.toTile(),
            hxd.Res.player.player_side_left3.toTile()
        ];
        var backAnim = [
            hxd.Res.player.player_back1.toTile(),
            hxd.Res.player.player_back2.toTile(),
            hxd.Res.player.player_back3.toTile()
        ];
        var anims = [
            "forward" => forwardAnim,
            "right" => sideRightAnim,
            "left" => sideLeftAnim,
            "back" => backAnim
        ];
        return anims;
    }

    public function distanceFrom(position : h2d.col.Point) : Float {
        return Math.sqrt(Math.pow(spr.x - position.x, 2) + Math.pow(spr.y - position.y, 2));
    }

}