# Help Desk Home Lab: Active Directory Domain

A hands-on home lab simulating a small corporate Windows environment, built to practice the day-to-day work of an IT help desk / desktop support technician.

**Tools & technologies:** VirtualBox · Windows Server 2022 · Windows 11 Pro · Active Directory Domain Services · DNS · PowerShell

---

## What I built

- A **Windows Server 2022 domain controller** (`DC01`) running AD DS and DNS for a new forest, `lab.local`
- A **Windows 11 Pro client** (`CLIENT02`) joined to the domain
- An **Organizational Unit**, **user accounts** and a **security group** managed in Active Directory Users and Computers
- A real **troubleshooting case**: diagnosed and fixed a failed domain join caused by bad IP/DNS settings
- A simulated **help desk ticket**: password reset and account unlock for a domain user

![Company OU with domain users in Active Directory Users and Computers](screenshots/04-company-ou-users.png)

## Skills demonstrated

| Area | What I did |
|---|---|
| Virtualization | Built and configured two VMs in VirtualBox, including EFI + TPM 2.0 for Windows 11 |
| Networking | Dual-adapter design (NAT + host-only), static IP addressing, subnet masks, DNS |
| Active Directory | Promoted a DC, created a forest, OUs, users and security groups |
| Troubleshooting | Isolated a domain-join failure to subnet mask and DNS misconfiguration |
| PowerShell | Verified connectivity and name resolution with `Test-NetConnection` and `Resolve-DnsName` |
| Help desk | Password resets, account unlocks, verifying the fix with the end user's login |

## Lab environment

| VM | OS | Role | RAM | CPU | Disk | Lab IP |
|---|---|---|---|---|---|---|
| DC01 | Windows Server 2022 (Desktop Experience) | Domain controller, DNS, Global Catalog | 4 GB | 2 | 50 GB | 192.168.56.10 (static) |
| CLIENT02 | Windows 11 Pro | Domain-joined workstation | 4 GB | 2 | 50 GB | 192.168.56.x |

- **Host:** Windows PC, 32 GB RAM, VirtualBox
- **Domain:** `lab.local` (NetBIOS: `LAB`)
- **Adapter 1:** NAT (internet access)
- **Adapter 2:** Host-only, `192.168.56.0/24` (isolated lab network)

```
                    ┌───────────────── Host PC (VirtualBox) ─────────────────┐
                    │                                                        │
   Internet ◄──NAT──┤  ┌──────────────┐   host-only    ┌──────────────────┐  │
                    │  │    DC01      │ 192.168.56.0/24 │    CLIENT02      │  │
                    │  │ Server 2022  │◄───────────────►│  Windows 11 Pro  │  │
                    │  │ AD DS + DNS  │                 │  joined to       │  │
                    │  │192.168.56.10 │                 │  lab.local       │  │
                    │  └──────────────┘                 └──────────────────┘  │
                    └────────────────────────────────────────────────────────┘
```

## Walkthrough

1. [Domain controller setup](docs/01-domain-controller-setup.md)
2. [Active Directory management (OU, users, group)](docs/02-active-directory-management.md)
3. [Windows 11 client setup](docs/03-client-setup.md)
4. [Troubleshooting: domain join failure](docs/04-troubleshooting-domain-join.md)
5. [Help desk ticket: password reset](docs/05-ticket-password-reset.md)

PowerShell versions of the main steps are in [`scripts/`](scripts/).

## Key takeaway

The most valuable part of this lab was the domain join failure. The client couldn't find `lab.local` because its subnet mask was `255.255.0.0` instead of `255.255.255.0` and its DNS wasn't pointing at the domain controller. **In Active Directory, DNS is almost always the first thing to check:** clients locate domain controllers through DNS SRV records, so a client using the wrong DNS server will never find the domain.

## Roadmap

- [ ] New-hire onboarding: create an account, add to groups
- [ ] Offboarding: disable a departed employee's account and move it to a Disabled Users OU
- [ ] Install and uninstall software on CLIENT02
- [ ] Remote support with Quick Assist and RDP
- [ ] Deploy osTicket and log practice tickets
- [ ] Group Policy: password policy, mapped drives, desktop restrictions
