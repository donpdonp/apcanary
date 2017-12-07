class Graphics {
    public static void setup (string[] args) {
        Gtk.init (ref args);
    }
}

class Window : Gtk.Window {
    public Window () {
        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
        var button1 = new Gtk.Button.with_label ("Click me!");
        var button2 = new Gtk.Button.with_label ("Click me!");
        hbox.add (button1);
        hbox.add (button2);
        add (hbox);
        show_all ();
    }
}
