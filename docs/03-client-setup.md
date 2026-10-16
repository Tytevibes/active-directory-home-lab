# 3. Windows 11 Client Setup (CLIENT02)

## VM configuration

| Setting | Value |
|---|---|
| OS | Windows 11 Pro |
| RAM / CPU / Disk | 4 GB / 2 CPUs / 50 GB |
| Firmware | EFI enabled |
| TPM | TPM 2.0 enabled |
| Adapters | NAT + host-only |

## Notes

- **Windows 11 hardware check:** Windows 11 requires UEFI and TPM 2.0. Enabling **EFI** and **TPM 2.0** in the VirtualBox VM settings let the installer pass the compatibility check without registry workarounds.
- **Missed boot prompt:** with EFI, the "Press any key to boot from CD or DVD" prompt only shows for a few seconds. When it was missed, the VM dropped to the UEFI shell; restarting the VM and pressing a key immediately fixed it.
- **Rebuild:** the first client build was locked out after I forgot the local account password. Rather than spend time on recovery in a throwaway VM, I rebuilt it as **CLIENT02**. Lesson learned: document local admin credentials when building lab machines.

## Domain join

After fixing the networking issue (see [Troubleshooting](04-troubleshooting-domain-join.md)):

1. Joined CLIENT02 to `lab.local` through **System Properties → Change → Domain**, using domain admin credentials.
2. Restarted and logged in as the domain user `LAB\jjones`.
3. Ran `whoami`, which returned `lab\jjones`, confirming a domain logon.
4. Re-enabled the NAT adapter so the client had internet access again.

PowerShell equivalent: [`scripts/03-join-domain.ps1`](../scripts/03-join-domain.ps1)

<!-- Screenshot: ![whoami output](../screenshots/03-whoami.png) -->
