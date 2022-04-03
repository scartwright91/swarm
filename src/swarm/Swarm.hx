package swarm;

class Swarm {

    public var swarms : Array<Array<Rat>> = [];
    public var rats : Array<Rat> = [];

    var swarmSprites : h2d.SpriteBatch;

    // swarm vars
    var swarmTimer : Float;
    var wave = 1;
    var activeSwarm : Bool = false;
    var addingSwarm : Bool = false;
    var returningSwarm : Bool = false;
    public var swarmLocations : Array<h2d.col.Point>;
    public var swarmPixelLocations : Array<h2d.col.Point>;

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
        if ((returningSwarm) && (rats.length == 0)) {
            returningSwarm = false;
            activeSwarm = false;
            wave += 1;
            if (wave > 2)
                wave = 2;
        }
        if ((addingSwarm) && (rats.length <= 49 * (wave))) {
            for (w in 0...wave) {
                var swarmLoc = swarmLocations[w];
                var rat = new Rat(swarmLoc.x, swarmLoc.y, false, w);
                swarms[w].push(rat);
                rats.push(rat);
            }
            if (rats.length > 49 * (wave))
                addingSwarm = false;
        }
        for (swarm in swarms) {
            for (rat in swarm) {
                rat.update(returningSwarm);
                if ((returningSwarm) && (rat.distanceFrom(swarmPixelLocations[rat.swarm]) < 10)) {
                    rat.destroy();
                    swarm.remove(rat);
                    rats.remove(rat);
                }
            }
        }
    }

    public function addSwarm() {
        swarms = [];
        rats = [];
        swarmLocations = [];
        swarmPixelLocations = [];
        for (w in 0...wave) {
            // pick random swarm location
            var ind = Std.int(Math.random() * Game.ME.level.spawnPoints.length);
            var swarmLocation = Game.ME.level.spawnPoints[ind];
            var swarmPixelLocation = new h2d.col.Point(
                swarmLocation.x * Settings.TILE_SIZE * Settings.SCALE + 0.5 * (Settings.TILE_SIZE * Settings.SCALE),
                swarmLocation.y * Settings.TILE_SIZE * Settings.SCALE + 0.5 * (Settings.TILE_SIZE * Settings.SCALE)
            );
            swarmLocations.push(swarmLocation);
            swarmPixelLocations.push(swarmPixelLocation);
            swarms[w] = [];
            // set swarm variables
            addingSwarm = true;
            swarmTimer = hxd.Timer.lastTimeStamp;
            activeSwarm = true;
        }
    }

    function returnSwarm() {
        returningSwarm = true;
    }

    function countRats() : Int {
        var nrats = 0;
        for (idx in 0...swarms.length) {
            nrats += swarms[idx].length;
        }
        return nrats;
    }

}