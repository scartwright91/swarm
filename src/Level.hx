class Level {

    public var gridLengthX : Int;
    public var gridLengthY : Int;
    public var offsetX : Float;
    public var offsetY : Float;

    public var grid : Array<Array<Dynamic>>;

	public var level : World.World_Level;

    public var playerStartX : Int;
    public var playerStartY : Int;
    public var finishX : Int;
    public var finishY : Int;

    public function new(l:World.World_Level) {

		level = l;

        gridLengthX = level.l_StrongTiles.cWid;
        gridLengthY = level.l_StrongTiles.cHei;

        Main.ME.gameScene3d.camera.target.set(gridLengthY/2, gridLengthX/2, -5);
        Main.ME.gameScene3d.camera.pos.set(gridLengthY/2, gridLengthX/2, 28);

    }

}