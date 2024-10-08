//	This file is part of FeedReader.
//
//	FeedReader is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	FeedReader is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with FeedReader.  If not, see <http://www.gnu.org/licenses/>.

public class FeedReader.SimpleHeader : Hdy.HeaderBar {
	private Gtk.Button m_backButton;

	public signal void back ();

	static construct {
	  Hdy.init ();
	}

	public SimpleHeader () {
		m_backButton = new Gtk.Button.with_label (_("Back"));
		m_backButton.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
		m_backButton.no_show_all = true;
		m_backButton.clicked.connect (() => {
			back ();
		});

		var back_grid = new Gtk.Grid () {
			valign = Gtk.Align.CENTER
		};
		back_grid.add (m_backButton);

		this.pack_start (back_grid);
		this.show_close_button = true;
		this.set_title ("Communique");
	}

	public void showBackButton (bool show) {
		m_backButton.visible = show;
	}
}
