//	This file is part of FeedReader.
//
//	FeedReader is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	 (at your option) any later version.
//
//	FeedReader is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with FeedReader.  If not, see <http://www.gnu.org/licenses/>.

namespace FeedReader {

	public class FeedReaderApp : Gtk.Application {

		private MainWindow m_window;
		private bool m_online = true;
		private static FeedReaderApp? m_app = null;
		public static bool m_verbose = false;
		public signal void callback (string content);

		public new static FeedReaderApp get_default () {
			if (m_app == null) {
				m_app = new FeedReaderApp ();
			}

			return m_app;
		}

		public bool isOnline () {
			return m_online;
		}

		public void setOnline (bool online) {
			m_online = online;
		}

		protected override void startup () {
			Logger.init (m_verbose);
			Logger.info ("FeedReader " + AboutInfo.version);

			Settings.state ().set_boolean ("currently-updating", false);

			base.startup ();
		}

		public override void activate () {
			base.activate ();
			WebKit.WebContext.get_default ().set_web_extensions_directory (Constants.INSTALL_PREFIX + "/" + Constants.INSTALL_LIBDIR);
			Intl.setlocale  (LocaleCategory.ALL, "");
			Intl.bindtextdomain  (Constants.GETTEXT_PACKAGE, Constants.LOCALE_DIR);
			Intl.bind_textdomain_codeset  (Constants.GETTEXT_PACKAGE, "UTF-8");
			Intl.textdomain  (Constants.GETTEXT_PACKAGE);

			if (m_window == null) {
				SetupActions ();
				m_window = MainWindow.get_default ();
				m_window.set_icon_name ("com.github.suzie97.communique");
				Gtk.IconTheme.get_default ().add_resource_path ("/com/github//suzie97/communique/icons");

				FeedReaderBackend.get_default ().newFeedList.connect ( () => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: newFeedList");
						ColumnView.get_default ().newFeedList ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().refreshFeedListCounter.connect ( () => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: refreshFeedListCounter");
						ColumnView.get_default ().refreshFeedListCounter ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().updateArticleList.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: updateArticleList");
						ColumnView.get_default ().updateArticleList ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().syncStarted.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: syncStarted");
						MainWindow.get_default ().writeInterfaceState ();
						ColumnView.get_default ().getHeader ().setRefreshButton (true);
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().syncFinished.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: syncFinished");
						ColumnView.get_default ().syncFinished ();
						MainWindow.get_default ().showContent (Gtk.StackTransitionType.SLIDE_LEFT, true);
						ColumnView.get_default ().getHeader ().setRefreshButton (false);
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().springCleanStarted.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: springCleanStarted");
						MainWindow.get_default ().showSpringClean ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().springCleanFinished.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: springCleanFinished");
						MainWindow.get_default ().showContent ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().showArticleListOverlay.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: showArticleListOverlay");
						ColumnView.get_default ().showArticleListOverlay ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().setOffline.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: setOffline");
						if (FeedReaderApp.get_default ().isOnline ())
						{
							FeedReaderApp.get_default ().setOnline (false);
							ColumnView.get_default ().setOffline ();
						}
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().setOnline.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: setOnline");
						if (!FeedReaderApp.get_default ().isOnline ())
						{
							FeedReaderApp.get_default ().setOnline (true);
							ColumnView.get_default ().setOnline ();
						}
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().feedAdded.connect ( (error, errmsg) => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: feedAdded");
						ColumnView.get_default ().footerSetReady ();
						if (error)
						{
							ColumnView.get_default ().footerShowError (errmsg);
						}
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().opmlImported.connect (() => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: opmlImported");
						ColumnView.get_default ().footerSetReady ();
						ColumnView.get_default ().newFeedList ();
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().updateSyncProgress.connect ( (progress) => {
					GLib.Idle.add ( () => {
						Logger.debug ("FeedReader: updateSyncProgress");
						ColumnView.get_default ().getHeader ().updateSyncProgress (progress);
						return GLib.Source.REMOVE;
					});
				});

				FeedReaderBackend.get_default ().updateBadge ();
				FeedReaderBackend.get_default ().checkOnlineAsync.begin ();

				sync ();
			}

			var granite_settings = Granite.Settings.get_default ();
	        var gtk_settings = Gtk.Settings.get_default  ();

	        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
	        if  (Granite.Settings.get_default  ().prefers_color_scheme == Granite.Settings.ColorScheme.DARK) {
            	Settings.general  ().set_enum  ("article-theme", 4);
            	ColumnView.get_default  ().reloadArticleView  ();
            } else {
                Settings.general  ().set_enum  ("article-theme", 1);
                ColumnView.get_default  ().reloadArticleView  ();
            }
	        granite_settings.notify["prefers-color-scheme"].connect  (() => {
	        	gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
	            if  (Granite.Settings.get_default  ().prefers_color_scheme == Granite.Settings.ColorScheme.DARK) {
	            	Settings.general  ().set_enum  ("article-theme", 4);
	            	ColumnView.get_default  ().reloadArticleView  ();
	            } else {
	                Settings.general  ().set_enum  ("article-theme", 1);
	                ColumnView.get_default  ().reloadArticleView  ();
	            }
	        });

			m_window.show_all ();
			m_window.present ();
		}

		public override int command_line (ApplicationCommandLine command_line)
		{
			var args = command_line.get_arguments ();
			if (args.length > 1)
			{
				Logger.debug ("FeedReader: callback %s".printf (args[1]));
				callback  (args[1]);
			}

			activate ();

			return 0;
		}

		protected override void shutdown ()
		{
			Logger.debug ("Shutdown!");
			Gst.deinit ();
			base.shutdown ();
		}

		public void sync ()
		{
			FeedReaderBackend.get_default ().startSync ();
		}

		public void cancelSync ()
		{
			FeedReaderBackend.get_default ().cancelSync ();
		}

		private FeedReaderApp ()
		{
			GLib.Object (application_id: "com.github.suzie97.communique", flags : ApplicationFlags.HANDLES_COMMAND_LINE);
		}

		private void SetupActions ()
		{
			var quit_action = new SimpleAction ("quit", null);
			quit_action.activate.connect (() => {

				// MainWindow.get_default ().writeInterfaceState (true);
				// m_window.close ();

				// if (Settings.state ().get_boolean ("currently-updating"))
				// {
				// 	Logger.debug ("Quit: FeedReader seems to be syncing -> trying to cancel");
				// 	FeedReaderBackend.get_default ().cancelSync ();
				// 	while (Settings.state ().get_boolean ("currently-updating"))
				// 	{
				// 		Gtk.main_iteration ();
				// 	}

				// 	Logger.debug ("Quit: Sync cancelled -> shutting down");
				// }
				// else
				// {
				// 	Logger.debug ("No Sync ongoing -> Quit right away");
				// }

				// FeedReaderApp.get_default ().quit ();

				MainWindow.get_default ().hide ();
			});
			this.add_action (quit_action);
		}
	}
}
