class Utils {

    public static inline function RGBToCol(r:Int, g:Int, b:Int, a:Int):Int
        {
            var color:Int = (a & 0xFF) << 24 | (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);
            return color;
        }

}