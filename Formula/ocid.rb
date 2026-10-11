# Homebrew formula for ocid — the single source of truth. `just packaging
# brew` and `just ship publish-release` copy it into the tap
# (Formula/ocid.rb), filling url/sha256.
class Ocid < Formula
  desc "Local-first, peer-to-peer distribution of OCI container images powered by iroh"
  homepage "https://github.com/safonas/ocid"
  url "https://github.com/safonas/ocid/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ee483f7a5608da6beb43d90bd172977b39e4c9fce528f95f03cf383214f4a6be"
  license "GPL-3.0-or-later"
  head "https://github.com/safonas/ocid.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ocid")
    system "cargo", "install", *std_cargo_args(path: "crates/ocictl")
    system "cargo", "install", *std_cargo_args(path: "crates/ocitop")
  end

  # brew services: launchd agent (macOS) / systemd user unit (Linux),
  # TLS on loopback like every other channel; state in the default XDG home.
  service do
    run [opt_bin/"ocid", "--tls"]
    keep_alive true
    log_path var/"log/ocid.log"
    error_log_path var/"log/ocid.log"
  end

  test do
    assert_match "ocid", shell_output("#{bin}/ocid --version")
    assert_match "ocictl", shell_output("#{bin}/ocictl --version")
  end
end
