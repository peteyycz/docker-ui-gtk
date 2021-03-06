public class Docker.ContainerEntry {
    public string name;
	public string state;
	public string status;

	public ContainerEntry (string name, string state, string status) {
		this.name = name;
		this.state = state;
		this.status = status;
	}
}

public class Docker.ContainerTreeView : Gtk.ApplicationWindow {

    Gtk.Label label;
	Docker.ContainerEntry[] entries;

    enum Column {
		NAME,
		STATE,
		STATUS
	}

    internal ContainerTreeView (Gtk.Application app, Docker.ContainerEntry[] entries) {
		Object (application: app, title: "Docker containers running on the machine");
		this.entries = entries;

		set_default_size (250, 100);
		border_width = 10;

		var refresh = new Gtk.Button.from_icon_name ("view-refresh-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
		var header = new Gtk.HeaderBar ();
		header.set_title ("Hello");
		header.pack_end (refresh);
		header.set_show_close_button (true);

		set_titlebar (header);

		var view = new Gtk.TreeView ();
		setup_treeview (view);
		view.expand = true;

		var label = new Gtk.Label ("");

		var grid = new Gtk.Grid ();

		grid.attach (view, 0, 0, 1, 1);
		grid.attach (label, 0, 1, 1, 1);
		add (grid);
    }
    
    void setup_treeview (Gtk.TreeView view) {
		var listmodel = new Gtk.ListStore (3, typeof (string),
                                              typeof (string),
                                              typeof (string));
		view.set_model (listmodel);

		var cell = new Gtk.CellRendererText ();

		cell.set ("weight_set", true);
		cell.set ("weight", 700);

		/*columns*/
		view.insert_column_with_attributes (-1, "Name",
                                                cell, "text",
                                                Column.NAME);

		view.insert_column_with_attributes (-1, "State",
                                                new Gtk.CellRendererText (),
                                                "text", Column.STATE);

		view.insert_column_with_attributes (-1, "Status",
                                                new Gtk.CellRendererText (),
                                                "text", Column.STATUS);

		Gtk.TreeIter iter;
		for (int i = 0; i < entries.length; i++) {
			listmodel.append (out iter);
			listmodel.set (iter, Column.NAME,
                                 entries[i].name,
                                 Column.STATE, entries[i].state,
                                 Column.STATUS, entries[i].status);
		}
	}
}