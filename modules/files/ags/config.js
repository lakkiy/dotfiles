import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';
import GLib from 'gi://GLib';

export default {
  style: App.configDir + '/style.css',
  windows: [
	Widget.Window({
	  monitor: 'HDMI-A-2',
	  name: 'viewedge-clock',
	  class_name: 'viewedge-clock',
	  anchor: ['top', 'bottom', 'left', 'right'],
	  layer: 'background',
	  child: Widget.Label({
		connections: [
		  [1000, self => { self.label = GLib.DateTime.new_now_local().format('%H:%M:%S') }]
		]
	  })
	})
  ]
}
