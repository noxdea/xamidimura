# Xamidimura

Xamidimura provides the shared file-revision contract used by Canopus, Hadar,
and Rukbat. It reads a stable byte snapshot, records a filesystem signature,
and computes a SHA-256 revision for optimistic save-conflict checks.

The gem is named for μ¹ Scorpii: Xamidimura is an IAU-adopted Khoekhoe name
derived from *xami di mura*, “eyes of the beast” ([All Skies Encyclopaedia](https://xing.fmi.uni-jena.de/mediawiki/index.php/Xamidimura)).

```ruby
snapshot = Xamidimura::SourceRevision.read("notes.md", reject_symlink: true)
snapshot.bytes       # exact bytes read
snapshot.signature   # stable filesystem signature
snapshot.digest      # SHA-256 of those bytes
```

`read` retries if the file changes during the read. Use `signature` for cheap
change checks, `digest` for bytes already in memory, and `file_digest` to hash
a file without loading it all into memory.

Xamidimura requires Ruby 3.2 or newer and has no runtime dependencies.
