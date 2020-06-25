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

		this.set_default_size (250, 100);
		this.border_width = 10;

		var view = new Gtk.TreeView ();
		this.setup_treeview (view);
		view.expand = true;

		label = new Gtk.Label ("");

		var grid = new Gtk.Grid ();

		grid.attach (view, 0, 0, 1, 1);
		grid.attach (label, 0, 1, 1, 1);
		this.add (grid);
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