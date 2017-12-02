[DBus (name = "org.freedesktop.NetworkManager")]
interface NetworkManager : Object {
  public signal void properties_changed(HashTable<string, Variant> props);
  public signal void state_changed(uint state); 
}

void on_property(HashTable<string, Variant> props) {
    stdout.printf ("on_property keys: ");
    foreach (string key in props.get_keys ()) {
		stdout.printf ("%s ", key);
	}
    stdout.printf ("\n");
    if (props.contains("State")) {
    var prop = props.get("State");
    stdout.printf ("Property changed %s %"+uint32.FORMAT+"\n", prop.get_type_string(), prop.get_uint32());
    }
}

void on_state(uint state) {
    stdout.printf("on_state %"+uint32.FORMAT+"\n", state);
    if (state == 70) {
        stderr.printf ("timer start\n");
        Timeout.add (1000, ()=> {msg_push(); return false;});
    }
}

void msg_push() {
    stderr.printf ("HTTP POST donpark.org\n");
    var session = new Soup.Session ();
    var message = new Soup.Message ("POST", "http://donpark.org/canary/vala");
    var body = new Soup.MessageBody();
    body.append_take("{}".data);
    message.request_body = body;
    session.queue_message (message, (sess, mess) => {
      stderr.printf ("POST done");
    });
}

int main () {
    try {
        NetworkManager netman = Bus.get_proxy_sync (BusType.SYSTEM,
                                            "org.freedesktop.NetworkManager",
                                            "/org/freedesktop/NetworkManager");

        netman.properties_changed.connect(on_property);
        netman.state_changed.connect(on_state);

        stdout.printf ("Canary listening\n");
        var loop = new MainLoop ();
        loop.run ();

    } catch (IOError e) {
        stderr.printf ("%s\n", e.message);
        return 1;
    }

    return 0;
}
