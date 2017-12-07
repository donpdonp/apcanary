[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

delegate void LevelCall (uint a);

int main (string[] args) {
    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    try {
        var netman = Wifi.netman ();
        var wifi = new Wifi (netman, (i) => { window.showLevel (i); });
        stdout.printf ("Canary listening\n");
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
