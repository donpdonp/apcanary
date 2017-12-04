[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

int main () {
    try {
        NetworkManager netman = Bus.get_proxy_sync (BusType.SYSTEM,
                                                    "org.freedesktop.NetworkManager",
                                                    "/org/freedesktop/NetworkManager");

        netman.properties_changed.connect (Wifi.on_property);
        netman.state_changed.connect (Wifi.on_state);

        stdout.printf ("Canary listening\n");
        var loop = new MainLoop ();
        loop.run ();
    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
