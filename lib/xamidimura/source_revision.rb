# frozen_string_literal: true

require "digest"

module Xamidimura
  class SourceRevision
    Snapshot = Data.define(:bytes, :signature, :digest)

    def self.digest(bytes)
      raise TypeError, "source bytes must be a String" unless bytes.is_a?(String)

      Digest::SHA256.hexdigest(bytes)
    end

    def self.file_digest(path)
      raise TypeError, "path must be a String" unless path.is_a?(String)

      Digest::SHA256.file(path).hexdigest
    rescue SystemCallError => error
      raise Error, error.message
    end

    def self.signature(path, reject_symlink: false)
      raise TypeError, "path must be a String" unless path.is_a?(String)
      unless reject_symlink == true || reject_symlink == false
        raise ArgumentError, "reject_symlink must be true or false"
      end

      stat = reject_symlink ? File.lstat(path) : File.stat(path)
      raise Error, "source path is not a regular file" unless stat.file? && !(reject_symlink && stat.symlink?)

      [stat.dev, stat.ino, stat.size, stat.mtime.to_i, stat.mtime.nsec,
       stat.ctime.to_i, stat.ctime.nsec].freeze
    rescue SystemCallError => error
      raise Error, error.message
    end

    def self.read(path, attempts: 3, reject_symlink: false)
      unless attempts.is_a?(Integer) && attempts.between?(1, 10)
        raise ArgumentError, "attempts must be an integer between 1 and 10"
      end

      attempts.times do
        before = signature(path, reject_symlink: reject_symlink)
        bytes = File.binread(path)
        after = signature(path, reject_symlink: reject_symlink)
        next unless before == after

        return Snapshot.new(bytes.freeze, after, digest(bytes))
      end
      raise Error, "source file changed while it was being read; retry"
    rescue SystemCallError => error
      raise Error, error.message
    end
  end
end
