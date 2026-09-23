# frozen_string_literal: true

require_relative "test_helper"
require "minitest/mock"

class SourceRevisionTest < Minitest::Test
  def test_read_returns_bytes_digest_and_stable_signature
    Dir.mktmpdir do |directory|
      path = File.join(directory, "source.md")
      File.binwrite(path, "hello\n")

      snapshot = Xamidimura::SourceRevision.read(path)

      assert_equal "hello\n", snapshot.bytes
      assert_equal Xamidimura::SourceRevision.digest(snapshot.bytes), snapshot.digest
      assert_equal snapshot.digest, Xamidimura::SourceRevision.file_digest(path)
      assert_equal Xamidimura::SourceRevision.signature(path), snapshot.signature
      assert_predicate snapshot.bytes, :frozen?
      assert_predicate snapshot.signature, :frozen?
      assert_predicate snapshot.digest, :frozen?
    end
  end

  def test_reject_symlink_and_invalid_arguments
    Dir.mktmpdir do |directory|
      path = File.join(directory, "source")
      link = File.join(directory, "link")
      File.write(path, "bytes")
      File.symlink(path, link)

      assert_raises(Xamidimura::Error) { Xamidimura::SourceRevision.signature(link, reject_symlink: true) }
      assert_raises(Xamidimura::Error) { Xamidimura::SourceRevision.read(link, reject_symlink: true) }
      assert_raises(ArgumentError) { Xamidimura::SourceRevision.signature(path, reject_symlink: :yes) }
      assert_raises(TypeError) { Xamidimura::SourceRevision.signature(Object.new) }
      [0, 11, 1.5].each do |attempts|
        assert_raises(ArgumentError) { Xamidimura::SourceRevision.read(path, attempts: attempts) }
      end
    end
  end

  def test_read_retries_if_the_file_changes_during_the_read
    Dir.mktmpdir do |directory|
      path = File.join(directory, "source")
      File.write(path, "before")
      original_read = File.method(:binread)
      change_after_first_read = true

      snapshot = File.stub(:binread, ->(target, *arguments) {
        bytes = original_read.call(target, *arguments)
        if change_after_first_read
          change_after_first_read = false
          File.write(path, "after")
        end
        bytes
      }) do
        Xamidimura::SourceRevision.read(path)
      end

      assert_equal "after", snapshot.bytes
      assert_equal Xamidimura::SourceRevision.signature(path), snapshot.signature
    end
  end
end
