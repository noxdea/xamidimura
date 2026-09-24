<h1 align="center">Xamidimura</h1>

<p align="center">
  <strong>Stable file snapshots and SHA-256 revisions for conflict-safe saves in Ruby applications</strong>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/xamidimura"><img src="https://img.shields.io/gem/v/xamidimura.svg" alt="Gem version"></a>
  <a href="https://rubygems.org/gems/xamidimura"><img src="https://img.shields.io/gem/dt/xamidimura.svg" alt="Gem downloads"></a>
  <a href="https://github.com/noxdea/xamidimura/actions/workflows/main.yml"><img src="https://github.com/noxdea/xamidimura/actions/workflows/main.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/Ruby-%3E%3D%203.2-cc342d.svg" alt="Ruby 3.2 or newer">
  <a href="LICENSE.txt"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#revision-checks">Revision checks</a> ·
  <a href="#development">Development</a>
</p>

---

Xamidimura gives [Canopus](https://github.com/noxdea/canopus),
[Hadar](https://github.com/noxdea/hadar), and
[Rukbat](https://github.com/noxdea/rukbat) a shared way to observe a file's
revision. It reads a stable byte snapshot, records a filesystem signature, and
computes a SHA-256 digest. Each application remains responsible for its own
reload and save-conflict policy.

## Installation

```sh
gem install xamidimura
```

Requires Ruby 3.2 or newer. There are no runtime gem dependencies.

## Quick start

```ruby
require "xamidimura"

path = "notes.md"
snapshot = Xamidimura::SourceRevision.read(path)

snapshot.bytes      # exact, frozen bytes read from disk
snapshot.signature  # frozen filesystem signature
snapshot.digest     # SHA-256 hex digest of those bytes

# Before saving, let the application decide what to do if the file changed.
if Xamidimura::SourceRevision.file_digest(path) != snapshot.digest
  warn "The file changed on disk"
end
```

`read` checks the file's signature before and after reading and retries when
they differ (three attempts by default, configurable from one to ten). `read`
and `signature` accept `reject_symlink: true`; `file_digest` follows symlinks.

## Revision checks

- `SourceRevision.signature(path)` returns a filesystem signature for a cheap
  metadata comparison; it is not a content hash.
- `SourceRevision.digest(bytes)` hashes a String already in memory.
- `SourceRevision.file_digest(path)` hashes a file without loading it all into
  memory.

Comparing revisions can detect changes at that moment; it does not make a later
write atomic. Applications choose how to handle a mismatch and protect their
own saves. See [ADR-001](docs/adr/001-source-revision.md) for the deliberately
narrow scope.

## Development

```sh
bundle install
bundle exec rake test
bundle exec rake rbs
```

The name Xamidimura comes from μ¹ Scorpii, an IAU-adopted Khoekhoe name
derived from *xami di mura*, “eyes of the beast”
([All Skies Encyclopaedia](https://xing.fmi.uni-jena.de/mediawiki/index.php/Xamidimura)).

## License

Xamidimura is released under the [MIT License](LICENSE.txt).
