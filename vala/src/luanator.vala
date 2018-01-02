using Lua;
using Json;

class Luanator {
    public void url (string url) {
        var vm = new LuaVM ();
        vm.open_libs ();
        try {
            Posix.chdir ("./lua");
            vm.do_file ("./capture.lua");

            var jsonNode = new Json.Node (Json.NodeType.VALUE).init_string (url); // Json.from_string (url);
            Json.Generator generator = new Json.Generator ();
            generator.set_root (jsonNode);
            string json = generator.to_data (null);
            string code = "capture(" + json + ")";
            vm.do_string (code);
        } catch (IOError e) {
        }
    }
}