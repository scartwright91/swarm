class Level {

    public var level : World.World_Level;

    public var collisionGrid : Array<Array<Int>>;

    public var gridLengthX : Int;
    public var gridLengthY : Int;

    public var pxWid : Int;
    public var pxHei : Int;

    public function new(l:World.World_Level) {

        level = l;

        gridLengthX = level.l_IntGrid.cWid;
        gridLengthY = level.l_IntGrid.cHei;

        pxWid = level.pxWid;
        pxHei = level.pxHei;

        createCollisionGrid();
        createLevel();

    }

    function createCollisionGrid() {
        collisionGrid = [for (x in 0...gridLengthX) [for (y in 0...gridLengthY) 0]];
        for (x in 0...gridLengthX) {
            for (y in 0...gridLengthY) {
                var w = level.l_IntGrid.hasValue(x, y);
                if (w) {
                    collisionGrid[x][y] = 1;
                }
            }
        }
    }

    function createLevel() {

        for (x in 0...gridLengthX) {
            for (y in 0...gridLengthY) {

                if (collisionGrid[x][y] == 1) {

                    var obj = new h2d.Object();
                    Game.ME.scroller.add(obj, Settings.OBJECT_LAYER);
                    obj.x = x * Settings.TILE_SIZE * Settings.SCALE;
                    obj.y = y * Settings.TILE_SIZE * Settings.SCALE;
                    var customGraphics = new h2d.Graphics(obj);
                    customGraphics.beginFill(0xEA8220);
                    customGraphics.drawRect(0, 0, Settings.TILE_SIZE * Settings.SCALE, Settings.TILE_SIZE * Settings.SCALE);
                    customGraphics.endFill();

                }

            }
        }

    }

}