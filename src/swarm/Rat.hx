package swarm;

class Rat {

    public var spr : h2d.Object;
    var g : h2d.Graphics;

    // vars
    var speed : Float = 1;

    // direction vars
    var flock : Flocking;
    public var direction : Float = Math.random() * 2 * Math.PI;
    public var velocity : h2d.col.Point = new h2d.col.Point();
    public var flockVelocity : h2d.col.Point = new h2d.col.Point();
    public var totalVelocity : h2d.col.Point = new h2d.col.Point();

    public var debugging : Bool;

    public function new(x:Float, y:Float, debug:Bool) {

        debugging = debug;

        spr = new h2d.Object();
        Game.ME.scroller.add(spr, Settings.ENTITY_LAYER);
        spr.x = x * Settings.TILE_SIZE * Settings.SCALE;
        spr.y = y * Settings.TILE_SIZE * Settings.SCALE;

        g = new h2d.Graphics(spr);
        if (debugging)
            g.beginFill(Utils.RGBToCol(255, 0, 0, 255));
        else 
            g.beginFill(Utils.RGBToCol(255, 255, 0, 255));

        g.drawCircle(0, 0, 0.2 * Settings.TILE_SIZE * Settings.SCALE);
        g.endFill();

        flock = new Flocking(this);

    }

    public function update() {

        // base direction velocity
        velocity = new h2d.col.Point(Math.cos(direction), Math.sin(direction));

        // flock force
        flockVelocity = flock.calculateFlockingBehaviour();

        totalVelocity = velocity.add(flockVelocity);
        totalVelocity.normalize();

        // update direction
        direction = Math.atan2(totalVelocity.y, totalVelocity.x);

        spr.x += totalVelocity.x * speed;
        spr.y += totalVelocity.y * speed;

        // if player is close, move towards player
        var p = Game.ME.player.spr;
        if (distanceFrom(new h2d.col.Point(p.x, p.y)) <= flock.visibilityRadius) {
            speed = 2;
            if (flock.weightsEnabled) {
                flock.disableWeights();
            }
            direction = Math.atan2(p.y - spr.y, p.x - spr.x);
        } else {
            speed = 1;
            if (!flock.weightsEnabled) {
                flock.enableWeights();
            }
        }

        if (spr.x < Settings.TILE_SIZE * Settings.SCALE) {
            spr.x = Game.ME.level.pxWid - (Settings.TILE_SIZE * Settings.SCALE);
        }
        if (spr.x > Game.ME.level.pxWid - (Settings.TILE_SIZE * Settings.SCALE)) {
            spr.x = Settings.TILE_SIZE * Settings.SCALE;
        }
        if (spr.y < Settings.TILE_SIZE * Settings.SCALE) {
            spr.y = Game.ME.level.pxHei - (Settings.TILE_SIZE * Settings.SCALE);
        }
        if (spr.y > Game.ME.level.pxHei - (Settings.TILE_SIZE * Settings.SCALE)) {
            spr.y = Settings.TILE_SIZE * Settings.SCALE;
        }

    }

    public function distanceFrom(position : h2d.col.Point) : Float {
        return Math.sqrt(Math.pow(spr.x - position.x, 2) + Math.pow(spr.y - position.y, 2));
    }

}