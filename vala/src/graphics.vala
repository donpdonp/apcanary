class Graphics {
    public static void setup (string[] args) {
        Gtk.init (ref args);
        try {
            Gtk.Window.set_default_icon_from_file ("icon.svg");
        } catch (GLib.Error e) {
        }
    }
}

class Window : Gtk.Window {
    Gtk.Label wifi_label;
    Gtk.Label http_label;
    Gtk.Label title_label;

    public Window () {
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 20);
        title_label = new Gtk.Label ("-");
        vbox.add (title_label);

        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
        wifi_label = new Gtk.Label ("-");
        http_label = new Gtk.Label ("-");
        hbox.add (wifi_label);
        hbox.add (http_label);

        vbox.add (hbox);
        add (vbox);
        show_all ();
    }

    public void logo () {
        Rsvg.Handle handle;
    }

    public void setTitle (string title, string color_name) {
        var color = Gdk.RGBA ();
        color.parse (color_name);
        title_label.set_markup ("<span font_size='xx-large'>" + title + "</span>");
        title_label.override_background_color (Gtk.StateFlags.NORMAL, color);
        var text = Gdk.RGBA ();
        text.parse ("white");
        title_label.override_color (Gtk.StateFlags.NORMAL, text);
        show_all ();
    }

    public void showLevel (uint level, string color_name) {
        var color = Gdk.RGBA ();
        color.parse (color_name);
        wifi_label.set_markup ("-<span font_size='xx-large'>" + level.to_string () + "</span>-");
        wifi_label.override_background_color (Gtk.StateFlags.NORMAL, color);
        show_all ();
    }

    public void showHttp (uint level, string color_name) {
        var color = Gdk.RGBA ();
        color.parse (color_name);
        http_label.set_markup ("-<span font_size='xx-large'>" + level.to_string () + "</span>-");
        http_label.override_background_color (Gtk.StateFlags.NORMAL, color);
        show_all ();
    }
}
