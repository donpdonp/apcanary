class Graphics {
    public static void setup (string[] args) {
        Gtk.init (ref args);
    }
}

class Window : Gtk.Window {
    Gtk.Button button;

    public Window () {
        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
        button = new Gtk.Button.with_label ("--");
        hbox.add (button);
        add (hbox);
        show_all ();
    }

    public void logo () {
        Rsvg.Handle handle;
    }

    public void showLevel (uint level) {
        button.set_label ("-" + level.to_string () + "-");
        show_all ();
    }
}
