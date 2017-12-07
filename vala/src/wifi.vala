class Wifi {
    public static void setup () throws IOError {
        NetworkManager netman = Bus.get_proxy_sync (BusType.SYSTEM,
                                                    "org.freedesktop.NetworkManager",
                                                    "/org/freedesktop/NetworkManager");

        netman.properties_changed.connect (on_property);
        netman.state_changed.connect (on_state);
    }

    public static void on_property (HashTable<string, Variant> props) {
        stdout.printf ("on_property keys: ");
        foreach (string key in props.get_keys ()) {
            stdout.printf ("%s ", key);
        }
        stdout.printf ("\n");
        if (props.contains ("State")) {
            var prop = props.get ("State");
            stdout.printf ("Property changed %s %" + uint32.FORMAT + "\n", prop.get_type_string (), prop.get_uint32 ());
        }
    }

    public static void on_state (uint state) {
        stdout.printf ("on_state %" + uint32.FORMAT + "\n", state);
        if (state == 70) {
            stderr.printf ("timer start\n");
            Timeout.add (1000, () => { msg_push (); return false; });
        }
    }

    static void msg_push () {
        stderr.printf ("HTTP POST donpark.org\n");
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", "http://donpark.org/canary/vala");
        var body = new Soup.MessageBody ();
        body.append_take ("{}".data);
        message.request_body = body;
        session.queue_message (message, (sess, mess) => {
            stderr.printf ("POST done");
        });
    }
}

