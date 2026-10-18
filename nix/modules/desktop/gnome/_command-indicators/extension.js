// Shows the output of shell commands in the GNOME top bar.
//
// The indicators are read from ~/.config/command-indicators/config.json:
//   {"indicators": [{"name": "...", "command": "...", "interval": 60}]}
//
// Each command is run periodically via /bin/sh. The first line of its stdout is shown in the top bar,
// all following lines are shown as details in the menu (together with a "Refresh Now" button).
// If the command fails, a warning sign is shown in the top bar and its stderr in the menu.

import Clutter from 'gi://Clutter';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import GObject from 'gi://GObject';
import St from 'gi://St';

import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';

Gio._promisify(Gio.Subprocess.prototype, 'communicate_utf8_async');

const CommandIndicator = GObject.registerClass(
class CommandIndicator extends PanelMenu.Button {
    _init(config) {
        super._init(0.5, config.name);
        this._config = config;
        this._process = null;
        this._cancellable = null;

        this._label = new St.Label({text: '…', y_align: Clutter.ActorAlign.CENTER});
        this.add_child(this._label);

        this._details = new PopupMenu.PopupMenuSection();
        this.menu.addMenuItem(this._details);
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
        const refreshItem = new PopupMenu.PopupMenuItem('Refresh Now');
        refreshItem.connect('activate', () => this._refresh());
        this.menu.addMenuItem(refreshItem);

        this._timeoutId = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, config.interval, () => {
            this._refresh();
            return GLib.SOURCE_CONTINUE;
        });
        this._refresh();
    }

    async _refresh() {
        if (this._process)
            return; // previous run still in progress

        const cancellable = new Gio.Cancellable();
        this._cancellable = cancellable;
        try {
            this._process = Gio.Subprocess.new(
                ['/bin/sh', '-c', this._config.command],
                Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE
            );
            const [stdout, stderr] = await this._process.communicate_utf8_async(null, cancellable);
            if (this._process.get_successful())
                this._show(stdout.trim().split('\n'));
            else
                this._show(['⚠', ...(stderr || stdout || 'command failed').trim().split('\n')]);
        } catch (e) {
            if (cancellable.is_cancelled())
                return; // indicator was destroyed
            this._show(['⚠', e.message]);
        } finally {
            if (!cancellable.is_cancelled()) {
                this._process = null;
                this._cancellable = null;
            }
        }
    }

    _show([label, ...details]) {
        this._label.text = label ?? '';
        this._details.removeAll();
        for (const line of details)
            this._details.addMenuItem(new PopupMenu.PopupMenuItem(line, {reactive: false}));
    }

    destroy() {
        GLib.source_remove(this._timeoutId);
        this._cancellable?.cancel();
        this._process?.force_exit();
        this._process = null;
        this._cancellable = null;
        super.destroy();
    }
});

export default class CommandIndicatorsExtension extends Extension {
    enable() {
        this._indicators = this._loadConfig().map(config => {
            const indicator = new CommandIndicator(config);
            // the role is used by the Top Bar Organizer extension to identify the item
            Main.panel.addToStatusArea(`command-indicator-${config.name}`, indicator);
            return indicator;
        });
    }

    disable() {
        this._indicators?.forEach(indicator => indicator.destroy());
        this._indicators = null;
    }

    _loadConfig() {
        const path = GLib.build_filenamev([GLib.get_user_config_dir(), 'command-indicators', 'config.json']);
        try {
            const [, contents] = GLib.file_get_contents(path);
            return JSON.parse(new TextDecoder().decode(contents)).indicators ?? [];
        } catch (e) {
            console.error(`${this.uuid}: failed to read ${path}: ${e.message}`);
            return [];
        }
    }
}
