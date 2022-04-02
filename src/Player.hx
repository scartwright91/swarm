import h2d.Graphics;
import hxd.Key;
import h2d.Object;


class Player {

    public var spr : h2d.Object;
    var g : h2d.Graphics;

    // player vars
    public var health : Float = 100;
    var energy : Float = 100;
    var magic : Float = 100;
    var healthBar : h2d.Graphics;
    var energyBar : h2d.Graphics;
    var magicBar : h2d.Graphics;

    // location vars
    var tile : h2d.col.IPoint;
    public var center : h2d.col.Point;

    // movement vars
    var dx : Float = 0;
    var dy : Float = 0;
    var speed : Float = 8;

    // spell
    var spellFrame : Int = 0;
    var spellImages : Array<h2d.Tile>;
    var spell : h2d.Graphics;
    public var spellCast : Bool = false;
    var spellDuration : Float;
    var magicRecoverRate : Float = 1;

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

        spellImages = [
            hxd.Res.spell1.toTile(),
            hxd.Res.spell2.toTile(),
            hxd.Res.spell3.toTile()
        ];
        var img = hxd.Res.player_png.toTile();
        g = new h2d.Graphics(spr);
        g.drawTile(0, 0, img);

        createHealthAndEnergy();

    }

    public function update() {

        if (energy > 20)
            energy -= 0.01;

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
            if ((spellFrame == 0) && (diff > 0.1)) {
                spellFrame += 1;
                spell.drawTile(
                    (Settings.TILE_SIZE * Settings.SCALE)/2-200,
                    (Settings.TILE_SIZE * Settings.SCALE)/2-200,
                spellImages[spellFrame]
                );
            }
            if ((spellFrame == 1) && (diff > 0.2)) {
                spellFrame += 1;
                spell.drawTile(
                    (Settings.TILE_SIZE * Settings.SCALE)/2-200,
                    (Settings.TILE_SIZE * Settings.SCALE)/2-200,
                spellImages[spellFrame]
                );
            }
            if (diff > 1) {
                spellCast = false;
                spr.removeChild(spell);
            }
        }

        // movement
        dx = dy = 0;

        if (Key.isDown(Key.A)) {
            dx = -(speed * energy/100);
        }
        if (Key.isDown(Key.D)) {
            dx = (speed * energy/100);
        }
        if (Key.isDown(Key.W)) {
            dy = -(speed * energy/100);
        }
        if (Key.isDown(Key.S)) {
            dy = (speed * energy/100);
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

    function posToTile(x:Float, y:Float) : h2d.col.IPoint {
        var tx = Std.int(spr.x / (Settings.TILE_SIZE * Settings.SCALE));
        var ty = Std.int(spr.y / (Settings.TILE_SIZE * Settings.SCALE));
        return new h2d.col.IPoint(tx, ty);
    }

    function castSpell() {
        spell = new h2d.Graphics(spr);
        spell.drawTile(
            (Settings.TILE_SIZE * Settings.SCALE)/2-200,
            (Settings.TILE_SIZE * Settings.SCALE)/2-200,
        spellImages[spellFrame]
        );
        spellCast = true;
        spellDuration = hxd.Timer.lastTimeStamp;
        spellFrame = 0;
        magic = 0;
        magicRecoverRate *= 0.5;
    }

    function createHealthAndEnergy() {

        healthBar = new h2d.Graphics(Main.ME.gameScene2d);
        energyBar = new h2d.Graphics(Main.ME.gameScene2d);
        magicBar = new h2d.Graphics(Main.ME.gameScene2d);

        var w = Main.ME.windowWidth * 0.15;
        var h = Main.ME.windowHeight * 0.03;

        healthBar.x = Main.ME.windowWidth * 0.02;
        healthBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.15;
        healthBar.beginFill(Utils.RGBToCol(255, 0, 0, 255));
        healthBar.drawRect(0, 0, w, h);
        healthBar.endFill();

        energyBar.x = Main.ME.windowWidth * 0.02;
        energyBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.1;
        energyBar.beginFill(Utils.RGBToCol(0, 0, 255, 255));
        energyBar.drawRect(0, 0, w, h);
        energyBar.endFill();

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

        energyBar.clear();
        energyBar.x = Main.ME.windowWidth * 0.02;
        energyBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.1;
        energyBar.beginFill(Utils.RGBToCol(0, 0, 255, 255));
        energyBar.drawRect(0, 0, w * energy / 100, h);
        energyBar.endFill();

        magicBar.clear();
        magicBar.x = Main.ME.windowWidth * 0.02;
        magicBar.y = Main.ME.windowHeight - Main.ME.windowHeight * 0.05;
        magicBar.beginFill(Utils.RGBToCol(255, 255, 0, 255));
        magicBar.drawRect(0, 0, w * magic / 100, h);
        magicBar.endFill();

    }

}