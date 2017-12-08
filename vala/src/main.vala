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
                color = "yellow";
                window.showHttp (0, "white");
            }
            if (state == 70) {
                color = "green";
            }
            window.showLevel (state, color);
        }, (http_status) => {
            var color = "#c00";
            if (http_status < 100) {
                color = "yellow";
            }
            if (http_status >= 200 && http_status < 300) {
                color = "green";
            }
            window.showHttp (http_status, color);
        });
        stdout.printf ("Canary listening\n");
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
