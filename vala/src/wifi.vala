[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

[DBus (name = "org.freedesktop.NetworkManager.Connection.Active")]
interface ActiveConnection : Object {
    [DBus (name = "Type")]
    public abstract string ttype { owned get; }
    [DBus (name = "Uuid")]
    public abstract string uuid { owned get; }
}

delegate void LevelCall (uint a);

class Wifi {

    public static NetworkManager netman () throws IOError {
        return Bus.get_proxy_sync (BusType.SYSTEM,
                                   "org.freedesktop.NetworkManager",
                                   "/org/freedesktop/NetworkManager");
    }

    LevelCall ll;
    LevelCall hl;

    public Wifi (NetworkManager netman, LevelCall l, LevelCall h) {
        netman.properties_changed.connect (on_property);
        netman.state_changed.connect (on_state);
        ll = l;
        hl = h;
    }

    public void on_property (HashTable<string, Variant> props) {
        stdout.printf ("on_property keys: ");
        foreach (string key in props.get_keys ()) {
            var prop = props.get (key);
            var type = prop.get_type_string ();
            stdout.printf ("%s(%s): %s\n", key, type, prop.print (true));
            if (key == "PrimaryConnection") {
                var obj_path = prop.get_string ();
                stdout.printf ("connecting to ActiveConnection @ %s\n", obj_path);
                ActiveConnection ac = Bus.get_proxy_sync (BusType.SYSTEM,
                                                          "org.freedesktop.NetworkManager",
                                                          obj_path);
                stdout.printf ("about to type\n");
                stdout.printf ("%s\n", ac.ttype);
            }
        }
        stdout.printf ("\n");
    }

    public void on_state (uint state) {
        stdout.printf ("on_state %" + uint32.FORMAT + "\n", state);
        ll (state);
        if (state == 70) {
            stderr.printf ("timer start\n");
            Timeout.add (1000, () => { tickle (); return false; });
        }
    }

    void tickle () {
        var url = "http://google.com";
        var verb = "GET";
        var message = new Soup.Message (verb, url);
        var session = new Soup.Session ();
        session.queue_message (message, (sess, msg) => {
            stderr.printf ("%s %s %u\n", verb, url, msg.status_code);
            hl (msg.status_code);
            msg.response_headers.foreach ((name, val) => {
                stdout.printf ("%s = %s\n", name, val);
            });
        });
        hl (1);
    }

    void msg_push () {
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

