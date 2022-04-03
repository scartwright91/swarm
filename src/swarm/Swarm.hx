package swarm;

class Swarm {

    public var rats : Array<Rat> = [];

    // swarm vars
    var swarmTimer : Float;
    var wave = 1;
    var activeSwarm : Bool = false;
    var addingSwarm : Bool = false;
    var returningSwarm : Bool = false;
    public var swarmLocation : h2d.col.Point;
    public var swarmPixelLocation : h2d.col.Point;

    // flocking parameters
    public var baseAlignmentWeight : Float = 1;
    public var baseCohesionWeight : Float = 0.78;
    public var baseSeparationWeight : Float = 0.75;

    public function new () {

    }

    public function update() {
        if (activeSwarm && (hxd.Timer.lastTimeStamp - swarmTimer > 30) && !returningSwarm) {
            returnSwarm();
        }
        if ((returningSwarm) && rats.length == 0) {
            returningSwarm = false;
            activeSwarm = false;
        }
        if ((addingSwarm) && (rats.length <= 100)) {
            var rat = new Rat(swarmLocation.x, swarmLocation.y, false);
            rats.push(rat);
        }
        for (rat in rats) {
            rat.update(returningSwarm);
            if ((returningSwarm) && rat.distanceFrom(swarmPixelLocation) < 10) {
                rat.destroy();
            }
        }
    }

    public function addSwarm() {
        var ind = Std.int(Math.random() * Game.ME.level.spawnPoints.length);
        swarmLocation = Game.ME.level.spawnPoints[ind];
        swarmPixelLocation = new h2d.col.Point(
            swarmLocation.x * Settings.TILE_SIZE * Settings.SCALE + 0.5 * (Settings.TILE_SIZE * Settings.SCALE),
            swarmLocation.y * Settings.TILE_SIZE * Settings.SCALE + 0.5 * (Settings.TILE_SIZE * Settings.SCALE)
        );
        addingSwarm = true;
        wave += 1;
        swarmTimer = hxd.Timer.lastTimeStamp;
        activeSwarm = true;
    }

    function returnSwarm() {
        returningSwarm = true;
    }

}