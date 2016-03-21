#!/bin/sh
# Copyright (C) 2008-2012 Red Hat, Inc. All rights reserved.
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions
# of the GNU General Public License v.2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

SKIP_WITH_LVMPOLLD=1

. lib/inittest

aux prepare_devs 3 8

vgcreate $vg $dev1 $dev2
lvcreate -l100%FREE -n $lv $vg
dd if="$dev1" of="$dev3" bs=1M
pvs --config "devices/global_filter = [ \"a|$dev2|\", \"a|$dev3|\", \"r|.*|\" ]" 2>err
grep "WARNING: Device mismatch detected for $vg/$lv which is accessing $dev1 instead of $dev3" err

vgremove -ff $vg
