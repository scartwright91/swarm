package swarm;

class Swarm {

    public var rats : Array<Rat> = [];

    // flocking parameters
    public var baseAlignmentWeight : Float = 1;
    public var baseCohesionWeight : Float = 0.78;
    public var baseSeparationWeight : Float = 0.75;

    public function new () {

        for (_ in 0...50) {
            var x = Math.random() * Game.ME.level.gridLengthX;
            var y = Math.random() * Game.ME.level.gridLengthY;
            var rat = new Rat(x, y, false);
            rats.push(rat);
        }
        rats.push(new Rat(10, 10, true));
    }

    public function update() {
        for (rat in rats) {
            rat.update();
        }
    }

}