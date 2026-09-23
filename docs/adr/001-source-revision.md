# ADR-001: Share source revision checks, not application policy

- Status: Accepted
- Date: 2026-09-23

## Context

Canopus, Hadar, and Rukbat each prevent an application save from silently
overwriting external edits, but they use different policies: Canopus and Rukbat
compare content digests, while Hadar also uses filesystem signatures to avoid
reading a deck on every poll. Their settings, commands, keymaps, and themes do
not share an implementation contract.

The gem is named for μ¹ Scorpii (Xamidimura), an IAU-adopted Khoekhoe name
derived from *xami di mura*, “eyes of the beast.”

## Decision

Xamidimura owns only stable byte snapshots, filesystem signatures, and SHA-256
content revisions. Application-specific reload, save, and conflict behavior
stays in each application. Do not move settings, keymaps, command registries,
theme loading, or file watchers here without a demonstrated three-application
contract.

## Consequences

The three applications can agree on how a source revision is observed without
coupling their editing models or conflict messages. The gem remains small; its
scope can expand only when another shared behavior is proven by real use.
