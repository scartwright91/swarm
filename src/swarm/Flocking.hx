package swarm;

class Flocking {

    var ent : Rat;

    public var visibilityRadius : Float = 150 * Settings.SCALE;
    public var perceptionRadius : Float = 100 * Settings.SCALE;
    var maxForce : Float = 0.6;

    // forces
    var alignment : h2d.col.Point;
    var cohesion : h2d.col.Point;
    var separation : h2d.col.Point;

    // weights
    public var weightsEnabled : Bool = true;
    public var alignmentWeight : Float = 1;
    public var cohesionWeight : Float = 0.78;
    public var separationWeight : Float = 0.75;

    public function new(rat : Rat) {

        ent = rat;        

        if (rat.debugging) {

            var g = new h2d.Graphics(ent.spr);
            g.beginFill(Utils.RGBToCol(255, 0, 0, 255));
            g.drawCircle(0, 0, visibilityRadius);
            g.endFill();
            g.alpha = 0.3;

            var g = new h2d.Graphics(ent.spr);
            g.beginFill(Utils.RGBToCol(255, 255, 255, 255));
            g.drawCircle(0, 0, perceptionRadius);
            g.endFill();
            g.alpha = 0.3;
        }

    }

    public function calculateFlockingBehaviour() : h2d.col.Point {

        // calculate flocking forces
        alignment = computeAlignment();
        cohesion = computeCohesion();
        separation = computeSeparation();

        // apply weights
        alignment = alignment.multiply(alignmentWeight);
        cohesion = cohesion.multiply(cohesionWeight);
        separation = separation.multiply(separationWeight);

        // combine forces       
        var force = alignment.add(cohesion.add(separation));
        force.normalize();
        force = force.multiply(maxForce);

        return force;
    }

    public function enableWeights() {
        weightsEnabled = true;
        alignmentWeight = Game.ME.swarm.baseAlignmentWeight;
        cohesionWeight = Game.ME.swarm.baseCohesionWeight;
        separationWeight = Game.ME.swarm.baseSeparationWeight;
    }

    public function disableWeights() {
        weightsEnabled = false;
        alignmentWeight = 0;
        cohesionWeight = 0;
        separationWeight = 0;
    }

    function computeAlignment() : h2d.col.Point {
        var steering = new h2d.col.Point(0, 0);
        var position = new h2d.col.Point(ent.spr.x, ent.spr.y);
        var neighbours = 0;

        for (e in Game.ME.swarm.rats) {
            if ((ent != e) && (e.distanceFrom(position) <= perceptionRadius)) {
                steering.x += e.velocity.x;
                steering.y += e.velocity.y;
                neighbours += 1;
            }
        }

        if (neighbours > 0) {
            steering = steering.multiply(1/neighbours);
            steering.normalize();
            steering = steering.add(ent.velocity.multiply(-1));
        }
        
        return steering;
    }

    function computeCohesion() : h2d.col.Point {
        var steering = new h2d.col.Point(0, 0);
        var position = new h2d.col.Point(ent.spr.x, ent.spr.y);
        var neighbours = 0;

        for (e in Game.ME.swarm.rats) {
            if ((ent != e) && (e.distanceFrom(position) <= perceptionRadius)) {            
                steering.x += e.spr.x;
                steering.y += e.spr.y;
                neighbours += 1;
            }
        }

        if (neighbours > 0) {
            steering = steering.multiply(1/neighbours);
            steering = steering.add(position.multiply(-1));
            steering.normalize();
            steering = steering.add(ent.velocity.multiply(-1));
        }
        
        return steering;
    }

    function computeSeparation() : h2d.col.Point {
        var steering = new h2d.col.Point(0, 0);
        var position = new h2d.col.Point(ent.spr.x, ent.spr.y);
        var neighbours = 0;

        for (e in Game.ME.swarm.rats) {
            var d = e.distanceFrom(position);
            if ((ent != e) && (d <= perceptionRadius)) {
                steering.x += (position.x - e.spr.x) / (d * d);
                steering.y += (position.y - e.spr.y) / (d * d);
                neighbours += 1;
            }
        }

        if (neighbours > 0) {
            steering = steering.multiply(1/neighbours);
            steering.normalize();
            steering = steering.add(ent.velocity.multiply(-1));
        }
        
        return steering;
    }

}