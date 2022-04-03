import h3d.mat.Texture;
import h2d.col.Point;

class Level {

    public var level : World.World_Level;

    public var collisionGrid : Array<Array<Int>>;
    public var spawnPoints : Array<h2d.col.Point> = [];

    public var gridLengthX : Int;
    public var gridLengthY : Int;

    public var pxWid : Int;
    public var pxHei : Int;

    // tilegroups
    var tiles : h2d.TileGroup;
    var water : h2d.TileGroup;
    var walls : h2d.TileGroup;

    // filters
    public var normalMap : h2d.Tile;

    public function new(l:World.World_Level) {

        level = l;

        gridLengthX = level.l_Floor.cWid;
        gridLengthY = level.l_Floor.cHei;

        pxWid = Std.int(level.pxWid * Settings.SCALE);
        pxHei = Std.int(level.pxHei * Settings.SCALE);

        createLevel();

    }

    public function update() {
        //normalMap.scrollDiscrete(0.5, 0.5);
    }

    function createLevel() {

        var tileset = hxd.Res.tileset_png.toTile();
        tiles = new h2d.TileGroup(tileset);
        Game.ME.scroller.add(tiles, Settings.BG_LAYER);

		for( autoTile in level.l_Floor.autoTiles ) {
			var tile = level.l_Floor.tileset.getAutoLayerTile(autoTile);
            tile.scaleToSize(tile.width * Settings.SCALE, tile.height * Settings.SCALE);
			tiles.add(autoTile.renderX * Settings.SCALE , autoTile.renderY * Settings.SCALE, tile);
		}

        walls = level.l_Walls.render();
        walls.scale(Settings.SCALE);
        Game.ME.scroller.add(walls, Settings.BG_LAYER);

        water = level.l_Water.render();
        water.scale(Settings.SCALE);
        Game.ME.scroller.add(water, Settings.BG_LAYER);

        for (ent in level.l_Entities.all_SpawnPoint) {
            var spawn = new h2d.col.Point(ent.cx, ent.cy);
            spawnPoints.push(spawn);
        }

    }

    public function addFilters() {
        normalMap = hxd.Res.normalMap.toTile();
        //water.filter = new h2d.filter.Displacement(normalMap, 4, 4);
        // water.addShader(testShader); 
        // tiles.addShader(testShader);
    }

}