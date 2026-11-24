
#!/usr/bin/env python3

import os
import logging

KLIPPER_COMPONENTS = "/usr/data/opencreator/klipper/klipper/klippy/extras"
MOONRAKER_COMPONENTS = "/usr/prog/moonraker/moonraker/moonraker/components"

KLIPPER_EXCLUDE = "/usr/data/opencreator/klipper/klipper/.git/info/exclude"
MOONRAKER_EXCLUDE = "/usr/prog/moonraker/moonraker/.git/info/exclude"

LOG = "/tmp/oc-c5-patches.log"

logging.basicConfig(
    filename=LOG,
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)


def get_symlinks(directory, prefix):
    entries = set()

    if not os.path.isdir(directory):
        logging.warning("Directory not found: %s", directory)
        return entries

    for name in os.listdir(directory):
        path = os.path.join(directory, name)

        if os.path.islink(path):
            entries.add(prefix + name)

    return entries


def update_exclude(path, entries):
    directory = os.path.dirname(path)

    if not os.path.isdir(directory):
        logging.warning("Git exclude directory not found: %s", directory)
        return

    lines = []

    if os.path.isfile(path):
        with open(path, "r") as f:
            lines = f.readlines()

    existing = {line.rstrip("\r\n") for line in lines}
    changed = False

    for entry in sorted(entries):
        if entry not in existing:
            lines.append(entry + "\n")
            existing.add(entry)
            changed = True

    if changed:
        with open(path, "w") as f:
            f.writelines(lines)

        logging.info("Updated Git exclusions: %s", path)


def main():
    klipper = get_symlinks(
        KLIPPER_COMPONENTS,
        "klippy/extras/"
    )

    moonraker = get_symlinks(
        MOONRAKER_COMPONENTS,
        "/moonraker/components/"
    )

    update_exclude(KLIPPER_EXCLUDE, klipper)
    update_exclude(MOONRAKER_EXCLUDE, moonraker)
    logging.info(
        "Git symlink exclusions updated: Klipper=%d Moonraker=%d",
        len(klipper),
        len(moonraker)
    )


if __name__ == "__main__":
    try:
        main()
    except Exception:
        logging.exception("Git exclusion update failed")
        raise SystemExit(1)
