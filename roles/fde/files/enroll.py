#!/usr/bin/env python3

import sys
import json
import pexpect
import subprocess

from pathlib import Path

def run_command():
    pass


def luksDump(path):
    cmd = f"cryptsetup luksDump --dump-json-metadata {path}".split(" ")
    process = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    stdout, stderr = process.communicate()
    if len(stdout) == 0:
        return None
    return json.loads(stdout)

def luksTestPassword(path, password):
    if isinstance(password, str):
        password = password.encode("utf-8")

    cmd=f"cryptsetup luksOpen --test-passphrase --tries 1 --key-slot 0 {path}"
    child = pexpect.spawn(cmd)

    child.expect(f"^Enter passphrase for {path}: ")
    child.send(password+b"\n")
    child.expect(pexpect.EOF)

    stdout = child.before.decode()

    child.close()
    ec = child.exitstatus

    return ec == 0

def luksChangePassword(path, old_password, new_password):
    if isinstance(old_password, str):
        old_password = old_password.encode("utf-8")
    if isinstance(new_password, str):
        new_password = new_password.encode("utf-8")

    cmd=f"cryptsetup luksChangeKey --tries 1 --key-slot 0 {path}"
    child = pexpect.spawn(cmd)

    prompt = "Enter passphrase to be changed: "
    # print(prompt)
    child.expect(prompt)
    child.send(old_password+b"\n")

    prompt = "Enter new passphrase: "
    # print(prompt)
    child.expect(prompt)
    child.send(new_password+b"\n")

    prompt = "Verify passphrase: "
    # print(prompt)
    child.expect(prompt)
    child.send(new_password+b"\n")

    child.expect(pexpect.EOF)

    stdout = child.before.decode()

    child.close()
    ec = child.exitstatus

    return ec == 0

def enroll(obj):
    path = obj['path']
    password = obj['password'].encode("utf-8")

    cmd = f"systemd-cryptenroll --wipe-slot=1 --tpm2-device=auto {path}"
    print(cmd)
    child = pexpect.spawn(cmd)

    child.expect(".*Please enter current passphrase for disk.*")
    child.send(password+b"\n")
    child.expect(pexpect.EOF)

    stdout = child.before.decode()

    child.close()

def main():
    # read in the secrets for this machine
    with sys.stdin as stdin:
        SECRET = json.loads(stdin.read())

    DRIVE = [SECRET['fde']['boot']]
    DRIVE += SECRET['fde']['nvme']
    DRIVE += SECRET['fde']['ssd']
    DRIVE += SECRET['fde']['hdd']
    for i, v in enumerate(DRIVE):
        if i == 0:
            v['path'] = Path("/dev/disk/by-id/"+v['bus']+"-"+v['mnsn']+"-part3")
        else:
            v['path'] = Path("/dev/disk/by-id/"+v['bus']+"-"+v['mnsn'])
        v['dump'] = luksDump(v['path'])

    v = DRIVE[0]
    is_using_default_password = luksTestPassword(v['path'], "changeme")
    if is_using_default_password:
        print("boot drive is still using the default password")
        result = luksChangePassword(v['path'], "changeme", v['password'])
        print("password changed:", result)

    NEED_ENROLL = []
    for v in DRIVE:
        if v['dump']["keyslots"].get("1") is None and len(v['dump']['tokens']) == 0:
            path = v['path']
            if path.is_symlink():
                path = path.resolve(strict=True)
            if not path.exists():
                print(str(v['path'])+" No such file or directory", file=sys.stderr)
            else:
                NEED_ENROLL.append(v)
                print(v['path'])
        else:
            print(str(v['path'])+" is already enrolled", file=sys.stderr)

    for v in NEED_ENROLL:
        enroll(v)

    pass


if __name__ == "__main__":
    main()
