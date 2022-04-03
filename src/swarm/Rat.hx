package swarm;

import h2d.filter.Displacement;

class Rat {

    public var spr : h2d.Object;
    var g : h2d.Graphics;

    // vars
    var speed : Float = 2 * Settings.SCALE;
    var biteRadius : Float = 10 * Settings.SCALE;

    // direction vars
    var flock : Flocking;
    public var direction : Float = Math.random() * 2 * Math.PI;
    public var velocity : h2d.col.Point = new h2d.col.Point();
    public var flockVelocity : h2d.col.Point = new h2d.col.Point();
    public var totalVelocity : h2d.col.Point = new h2d.col.Point();

    public var debugging : Bool;

    // filters
    var normalMap : h2d.Tile;

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
            g.beginFill(Utils.RGBToCol(26, 26, 36, 255));

        normalMap = hxd.Res.normalMap.toTile();
        g.filter = new h2d.filter.Group([
            new h2d.filter.Glow(Utils.RGBToCol(128, 128, 164, 255), 50, 2), 
            new h2d.filter.Displacement(normalMap, 3, 3),
            new h2d.filter.Blur(3)
        ]);
        g.drawCircle(0, 0, 0.1 * Settings.TILE_SIZE * Settings.SCALE);
        g.endFill();

        flock = new Flocking(this);

    }

    public function destroy() {
        spr.remove();
    }

    public function update(returning : Bool) {

        normalMap.scrollDiscrete(1, 1);

        if (returning) {
            var direction = Math.atan2(
                Game.ME.swarm.swarmPixelLocation.y - spr.y + 0.5,
                Game.ME.swarm.swarmPixelLocation.x - spr.x + 0.5
            );
            spr.x += Math.cos(direction) * 3 * Settings.SCALE;
            spr.y += Math.sin(direction) * 3 * Settings.SCALE;
            return;
        }

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

        // If player player is close to rat
        var p = Game.ME.player.center;
        if (distanceFrom(new h2d.col.Point(p.x, p.y)) <= flock.visibilityRadius) {
            speed = 3 * Settings.SCALE;
            if (flock.weightsEnabled) {
                flock.disableWeights();
            }
            // If player is holding fire, the rat will run in the opposite direction (otherwise towards)
            if (Game.ME.player.spellCast) {
                direction = Math.atan2(spr.y - p.y, spr.x - p.x);
            } else {
                direction = Math.atan2(p.y - spr.y, p.x - spr.x);
                // if rat is touching playing
                if (distanceFrom(new h2d.col.Point(p.x, p.y)) <= biteRadius) {
                    if (Game.ME.player.health > 10) {
                        Game.ME.player.health -= 1;
                    }
                } 
            }
        } else {
            speed = 2 * Settings.SCALE;
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