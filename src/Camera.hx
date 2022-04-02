class Camera {

    // Target to follow
    public var target : h2d.Object;
    var scroller : h2d.Object;
    var level : Level;

    // World size
    public var levelWid : Int;
    public var levelHei : Int;

    public function new(t:h2d.Object) {

        // init target object and scroller
        target = t;
        scroller = Game.ME.scroller;
        level = Game.ME.level;

        // init level size
        levelWid = level.pxWid;
        levelHei = level.pxHei;
    }

    public function update() {
        var winWid = Main.ME.windowWidth;
        var winHei = Main.ME.windowHeight;
        // Apply camera
        scroller.x = winWid * 0.5 - target.x;
        scroller.y = winHei * 0.5 - target.y;
        // Clamp camera to bounds
        if (winWid < levelWid)
            scroller.x = fclamp(scroller.x, winWid - levelWid, 0);
        if (winHei < levelHei)
            scroller.y = fclamp(scroller.y, winHei - levelHei, 0);
    }

	inline public static function fclamp(x:Float, min:Float, max:Float):Float
        {
            return (x < min) ? min : (x > max) ? max : x;
        }

}