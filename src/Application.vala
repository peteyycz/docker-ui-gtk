public class Application : Gtk.Application {
    public Application () {
        Object (
            application_id: "com.github.peteyycz.docker",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate () {
        //  title = "Docker container listings";
        //  window_position = Gtk.WindowPosition.CENTER;
        //  set_default_size (350, 80);

        string url = "http://localhost:2375/containers/json";
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);

        session.send_message (message);

        Json.Parser parser = new Json.Parser ();

        parser.load_from_data ((string)message.response_body.data);

        Json.Node node = parser.get_root ();
        
        unowned Json.Array arr = node.get_array ();

        Docker.ContainerEntry[] entries = {};
        foreach (var element in arr.get_elements ()) {
            Json.Object el = element.get_object ();

            string name = el.get_array_member ("Names").get_element (0).get_string ();
            string state = el.get_string_member ("State");
            string status = el.get_string_member ("Status");

            var c = new Docker.ContainerEntry(name, state, status);
            entries += c;
        }

        new Docker.ContainerTreeView (this, entries).show_all ();
        //  var window = new Docker.Window (this);
        //  add_window (window);
    }
}

