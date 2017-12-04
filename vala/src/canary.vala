[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

int main (string[] args) {
    var loop = new MainLoop ();
    Gtk.init (ref args);
    var window = new Window ();
    window.destroy.connect (loop.quit);

    try {
        Wifi.setup ();
        stdout.printf ("Canary listening\n");
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
