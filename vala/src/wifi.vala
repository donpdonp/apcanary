[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
    public signal void properties_changed (HashTable<string, Variant> props);
    public signal void state_changed (uint state);
}

[DBus (name = "org.freedesktop.NetworkManager.Connection.Active")]
interface ActiveConnection : Object {
    [DBus (name = "Type")]
    public abstract string ttype { owned get; }
    [DBus (name = "Id")]
    public abstract string essid { owned get; }
}

delegate void LevelCall (uint a);

delegate void WordCall (string a);

class Wifi {

    public static NetworkManager netman () throws IOError {
        return Bus.get_proxy_sync (BusType.SYSTEM,
                                   "org.freedesktop.NetworkManager",
                                   "/org/freedesktop/NetworkManager");
    }

    LevelCall ll;
    WordCall hl;
    WordCall wl;

    public Wifi (NetworkManager netman, LevelCall l, WordCall h, WordCall w) {
        netman.properties_changed.connect (on_property);
        netman.state_changed.connect (on_state);
        ll = l;
        hl = h;
        wl = w;
    }

    public void on_property (HashTable<string, Variant> props) {
        stdout.printf ("on_property keys: ");
        foreach (string key in props.get_keys ()) {
            var prop = props.get (key);
            var type = prop.get_type_string ();
            stdout.printf ("%s(%s): %s\n", key, type, prop.print (true));
            if (key == "PrimaryConnection") {
                var obj_path = prop.get_string ();
                stdout.printf ("*ActiveConnection @ %s\n", obj_path);
                ActiveConnection ac = Bus.get_proxy_sync (BusType.SYSTEM,
                                                          "org.freedesktop.NetworkManager",
                                                          obj_path);
                wl (ac.essid);
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
        var url = "http://detectportal.firefox.com/";
        var verb = "GET";
        var request = new Soup.Message (verb, url);
        var session = new Soup.Session ();
        session.max_conns = 1;
        request.got_headers.connect (() => {
            /* 302 */
            if (request.status_code == Soup.Status.FOUND) {
                var new_url = request.response_headers.get_one ("Location");
                stdout.printf ("!redirect: %s\n", new_url);
                stdout.printf ("--redirect response--\n");
                stderr.printf ("status: %u\n", request.status_code);
                hl (new_url);
                request.response_headers.foreach ((name, val) => {
                    stdout.printf ("%s: %s\n", name, val);
                });
                /* Finish processing request */
                session.cancel_message (request, Soup.Status.CANCELLED);
            }
        });
        session.queue_message (request, (sess, response) => {
            stdout.printf ("--request--\n");
            stderr.printf ("%s %s\n", verb, url);
            response.request_headers.foreach ((name, val) => {
                stdout.printf ("%s: %s\n", name, val);
            });
            stdout.printf ("--response--\n");
            stderr.printf ("status: %u\n", response.status_code);
            response.response_headers.foreach ((name, val) => {
                stdout.printf ("%s: %s\n", name, val);
            });
        });
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

