package swarm;

class Swarm {

    public var rats : Array<Rat> = [];

    // flocking parameters
    public var baseAlignmentWeight : Float = 1;
    public var baseCohesionWeight : Float = 0.78;
    public var baseSeparationWeight : Float = 0.75;

    public function new () {
        addSwarm();
    }

    public function update() {
        for (rat in rats) {
            rat.update();
        }
    }

    public function addSwarm() {
        var ind = Std.int(Math.random() * Game.ME.level.spawnPoints.length);
        var spawnLocation = Game.ME.level.spawnPoints[ind];
        for (_ in 0...50) {
            var offsetx = Math.random() * Settings.TILE_SIZE * Settings.SCALE;
            var offsety = Math.random() * Settings.TILE_SIZE * Settings.SCALE;
            var rat = new Rat(spawnLocation.x + offsetx, spawnLocation.y + offsety, false);
            rats.push(rat);
        }
        rats.push(new Rat(spawnLocation.x, spawnLocation.y, true));
    }

}