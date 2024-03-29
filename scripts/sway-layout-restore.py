#!/usr/bin/env python3

#Based on https://github.com/9ary/dotfiles/blob/master/i3/ws-1.py
#Generalized and extended by Nolan Leake <nolan@sigbus.net>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#Example layout:
# {
#     "layout": "splith",
#     "nodes": [
#         {
#             "layout": "splitv",
#             "width": 60,
#             "nodes": [
#                 {
#                     "swallows": {"class": "Audacious"}
#                 }
#             ]
#         },
#         {
#             "layout": "splitv",
#             "width": 40,
#             "nodes": [
#                 {
#                     "swallows": {"app_id": "^Alacritty$"}
#                 },
#                 {
#                     "swallows": {"cmd": "exec alacritty"}
#                 }
#             ]
#         }
#     ]
# }
#This layout will match an externally started audacious (an Xwayland app), by
# its X11 class, then match an externally started alacritty by its Wayland
# app_id, and then internally start another alacritty, matching it because its
# window PID is the cmd's PID, or a child of it.
#
#NOTE: A "cmd" will match on PID unless there are other matches in the swallow,
# in which case the PID match will be ignored. This is useful for things like
# windows spawned via emacsclient, where the PID of the window will end up
# being from the emacs daemon, not the emacsclient instance.

import asyncio, re, argparse, json, subprocess, sys, os
from i3ipc.aio import Connection, Con
from i3ipc import Event
from time import sleep

async def refresh_con(con):
    tree = await con._conn.get_tree()
    return tree.find_by_id(con.id)

Con.__repr__ = lambda self: f'type: {self.type} name: {self.name} id: {self.id} layout: {self.layout} pid: {self.pid}'


def pid_is_descendent(pid, parent_pid):
    if str(pid) == str(parent_pid):
        return True
    try:
        with open(f'/proc/{pid}/stat', 'rb') as f:
            l = f.read()
            ppid = int(l[l.rfind(b')') + 2:].split()[1])
    except FileNotFoundError: #No Linux compatible procfs, try psutil
        import psutil
        ppid = psutil.Process(pid).ppid()
    if ppid == 0:
        return False
    return pid_is_descendent(ppid, parent_pid)

def iter_leaves(subtree):
    for node in subtree["nodes"]:
        node["parent"] = subtree
        if node.get("swallows"):
            yield node
        if node.get("nodes") is not None:
            yield from iter_leaves(node)


def try_match(con, leaves):
    if not getattr(try_match, 'already_ids', None):
        try_match.already_ids = set()

    if con.id in try_match.already_ids:
        return #Something already matched this container.

    for leaf in leaves:
        if leaf.get("con"):
            continue #Something already matched this leaf.

        if 'pid' in leaf['swallows']:
            pid = getattr(con, 'pid', None)
            if pid and pid_is_descendent(con.pid, leaf['swallows']['pid']):
                leaf['con'] = con
                try_match.already_ids.add(con.id)
                return
        else:
            for key, pattern in leaf["swallows"].items():
                if key in ('class', 'instance', 'title'):
                    key = 'window_' + key

                if (value := getattr(con, key, None)) is None:
                    break
                if re.search(pattern, value) is None:
                    break
            else:
                leaf["con"] = con
                try_match.already_ids.add(con.id)
                return

def check_all_leaves_matched(leaves):
    for leaf in leaves:
        if leaf.get("con") is None:
            return False
    return True


async def apply_layout(subtree, ws='current'):
    to_split = len(subtree['nodes']) > 1
    for node in subtree["nodes"]:
        con = None
        if con := node.get("con"):
            await con.command(f"move workspace {ws}")
            await con.command('floating disable')
            await con.command("focus")
            if to_split:
                await con.command('splitt')
                await con.command(f'layout {subtree["layout"]}')
                to_split = False
        elif node.get("nodes") is not None:
            con = await apply_layout(node, ws)
            print("node")
            if con.type != 'workspace':
                await con.command("focus")
                if to_split:
                    new_con = await refresh_con(con)
                    if new_con.parent.type == 'workspace':
                        await con.command('splitt')
                        await con.command(f'layout {subtree["layout"]}')
                        await con.command('focus parent')
                    else:
                        await con.command(f'layout {subtree["layout"]}')

                    to_split = False
            else:
                await con.nodes[0].command('focus parent')
                if to_split:
                    await con._conn.command('splitt')
                    await con._conn.command(f'layout {subtree["layout"]}')

    if con:
        new_con = await refresh_con(con)
        return new_con.parent


async def main():
    parser = argparse.ArgumentParser(description='Setup a workspace layout based on a layout config file.')
    parser.add_argument('--bg',  default=False, action='store_true',
                        help='daemonize after listening to new windows starts')
    parser.add_argument('--ws', default=None, help='workspace number to setup')
    parser.add_argument('--match-existing', action='store_true',
                        help='match windows that already exist')
    parser.add_argument('layout_file',
                        help='json file containing the workspace layout')
    args = parser.parse_args()

    with open(args.layout_file, 'r') as f:
        layout = json.load(f)

    sway = await Connection().connect()

    leaves = list(iter_leaves(layout))

    #Subscribe to events first to make sure we don't miss anything.
    watched_ids = set()
    def on_window(self, event):
        if event.change == Event.WINDOW_NEW:
            watched_ids.add(event.container.id)
        if event.change == Event.WINDOW_TITLE:
            if not (event.container.id in watched_ids or args.match_existing):
                return
        try_match(event.container, leaves)
        if check_all_leaves_matched(leaves):
            sway.main_quit()
    sway.on(Event.WINDOW_NEW, on_window)
    sway.on(Event.WINDOW_TITLE, on_window)

    #Fork into bg if requested, now that we're listening to window events.
    if args.bg:
        pid = os.fork()
        if pid > 0:
            sys.exit(0)

    #Run any cmd directives.
    for leaf in leaves:
        swallows = leaf['swallows']
        cmd = swallows.get('cmd', None)
        if cmd:
            proc = subprocess.Popen(cmd, close_fds=True, shell=True)
            if len(swallows) == 1:
                #Since we're not already matching on any other criteria,
                # match on the PID.
                swallows['pid'] = proc.pid

    #If requested, try to match any existing windows.
    if args.match_existing:
        for con in await sway.get_tree():
            try_match(con, leaves)

    if not check_all_leaves_matched(leaves):
        # Wait until all windows have appeared
        await sway.main()

    #This really shouldn't be necessary, but we get a warning otherwise
    # (this could be a bug in i3ipc).
    sway.off(on_window)

    scratchpad_windows = []
    try:
        #Move all our windows to the scratchpad temporarily.
        for leaf in leaves:
            scratchpad_windows.append(leaf["con"])
            await leaf["con"].command("move scratchpad")

        #Recusrively apply layout to our discovered leaves.
        await apply_layout(layout, args.ws)

        #Resize containers for windows that have sizes specified.
        for leaf in leaves:
            con = leaf["con"]
            await con.command("focus")
            await con.command(f"resize set {leaf.get('width', 0)} "
                              f"{leaf.get('height', 0)}")
            while leaf := leaf.get("parent"):
                await sway.command("focus parent")
                await sway.command(f"resize set {leaf.get('width', 0)} "
                                   f"{leaf.get('height', 0)}")

        await leaves[0]["con"].command("focus")
    except:
        #Let's at least not leave hidden windows in the scratchpad...
        while len(scratchpad_windows):
            await scratchpad_windows.pop().command('scratchpad show')
        raise

asyncio.run(main())
