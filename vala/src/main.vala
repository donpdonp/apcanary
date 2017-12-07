[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

int main (string[] args) {
    var loop = new MainLoop ();
    Graphics.setup (args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    try {
        var netman = Wifi.netman ();
        var wifi = new Wifi (netman, (state) => {
            var color = "#c00";
            if (state == 40) {
                color = "white";
                window.showHttp (0, color);
            }
            if (state == 70) {
                color = "green";
            }
            window.showLevel (state, color);
        }, (status) => {
            var color = "#c00";
            if (status < 100) {
                color = "yellow";
            }
            if (status >= 200 && status < 300) {
                color = "green";
            }
            window.showHttp (status, color);
        });
        stdout.printf ("Canary listening\n");
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
