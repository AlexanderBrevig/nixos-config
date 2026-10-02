# Crash / hard-hang instrumentation.
#
# Why this exists: abmain dies from *silent hard hangs*. The journal simply stops
# mid-line with no oops, no panic and no shutdown (boots -1/-3/-4/-6 all end this
# way, while clean reboots end with "Journal stopped"). When the box wedges that
# hard, nothing reaches disk, so we are left with zero evidence.
#
# This module does two things:
#   1. Turns as many silent freezes as possible into *captured, auto-rebooting
#      panics* — a panic prints a backtrace (rendered on screen by the DRM panic
#      handler, which this kernel registers), flushes what it can, then reboots.
#   2. Archives the tail of the previous boot on every boot, so a crash history
#      accumulates on its own under /var/log/crashes for later inspection.
#
# None of this fixes a crash; it makes the *next* one leave a trace.
{ config, lib, pkgs, ... }:

{
  boot.kernel.sysctl = {
    # A recoverable kernel oops normally leaves the machine limping (or frozen)
    # with no reboot. Promote it to a full panic so it is captured...
    "kernel.panic_on_oops" = 1;
    # ...and reboot 20s after any panic instead of sitting on a dead screen.
    # 20s is enough to photograph the DRM panic trace before it reboots.
    "kernel.panic" = 20;

    # NMI hard-lockup detector (nmi_watchdog is already on): if a CPU is wedged
    # with interrupts off, panic -> trace + reboot, instead of an eternal freeze.
    "kernel.hardlockup_panic" = 1;
    # Soft-lockup: a CPU stuck in the kernel without scheduling -> panic too.
    "kernel.softlockup_panic" = 1;

    # Hung-task detector. A GPU wedge often shows up as userspace tasks stuck in
    # uninterruptible (D) state on the driver rather than as a CPU lockup, so this
    # is the check most likely to catch an NVIDIA hang. The window is deliberately
    # generous (120s) so ordinary slow I/O or a big model load does not trip it.
    # If you ever get spurious reboots, set hung_task_panic to 0 first — you still
    # keep the warning + backtrace in the log without the reboot.
    "kernel.hung_task_timeout_secs" = 120;
    "kernel.hung_task_panic" = 1;

    # Magic SysRq fully enabled: when the box is half-wedged but the keyboard still
    # responds you can force a blocked-task dump (Alt+SysRq+w) or a safe reboot
    # (REISUB: hold Alt+SysRq, then R E I S U B). The dump lands in the journal and
    # gets archived by crash-archive on the next boot.
    "kernel.sysrq" = 1;
  };

  # Lose fewer of the final seconds before a freeze: flush the journal to disk
  # more often. 10s is a modest trade against SSD wear (default is ~5min).
  services.journald.settings.Journal = {
    Storage = "persistent";
    SyncIntervalSec = "10s";
  };

  # systemd-pstore moves any panic/oops the firmware preserved in pstore into
  # /var/lib/systemd/pstore on boot. Harmless when pstore is empty.
  systemd.services.systemd-pstore.wantedBy = [ "multi-user.target" ];

  # On every boot, snapshot the *previous* boot so a crash history builds itself.
  # Records whether the previous boot ended cleanly ("Journal stopped") so hangs
  # are easy to pick out later, and folds in any pstore trace that survived.
  systemd.services.crash-archive = {
    description = "Archive previous boot's log tail for crash forensics";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-journald.service" "systemd-pstore.service" ];
    path = [ pkgs.systemd pkgs.coreutils pkgs.gnugrep pkgs.findutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -u
      out=/var/log/crashes
      mkdir -p "$out"

      # Did the previous boot end cleanly? Clean shutdowns log "Journal stopped".
      clean=no
      if journalctl -b -1 -o cat 2>/dev/null | tail -n 8 | grep -q "Journal stopped"; then
        clean=yes
      fi

      ts="$(date +%Y%m%d-%H%M%S)"
      f="$out/boot-prev-$ts-clean-$clean.log"
      {
        echo "# archived: $(date -Iseconds)"
        echo "# previous boot ended cleanly: $clean"
        echo
        echo "# ===== last 1000 lines of previous boot ====="
        journalctl -b -1 -o short-iso -n 1000 2>/dev/null || true
        echo
        echo "# ===== previous boot: kernel warnings+ ====="
        journalctl -b -1 -k -p warning -o short-iso 2>/dev/null || true
        echo
        echo "# ===== pstore (firmware-preserved panic, if any) ====="
        cat /var/lib/systemd/pstore/*/dmesg.txt 2>/dev/null || true
        cat /sys/fs/pstore/* 2>/dev/null || true
      } > "$f"

      # Keep the most recent 40 archives.
      ls -1t "$out"/boot-prev-*.log 2>/dev/null | tail -n +41 | xargs -r rm -f
    '';
  };

  # ---------------------------------------------------------------------------
  # OPTIONAL — netconsole: the only reliable way to capture a *true* hard hang,
  # because it streams each kernel printk out the NIC the instant it happens, so
  # nothing depends on disk. Needs a second always-on machine on your LAN to
  # receive. To enable:
  #   1. On the receiver (IP <RX_IP>):  nc -u -l 6666   (or: socat udp-recv:6666 -)
  #   2. Find this box's NIC + the receiver's MAC, then add to hosts/abmain.nix:
  #        boot.kernelParams = [
  #          "netconsole=6666@<THIS_BOX_IP>/eno1,6666@<RX_IP>/<RX_MAC>"
  #        ];
  #      (eno1 is your wired r8169 NIC; use the wired link, not wlp8s0.)
  #   3. Rebuild + reboot. Every kernel message now also lands on the receiver,
  #      including the last words before a freeze.
  # ---------------------------------------------------------------------------
}
