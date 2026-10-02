# Homebrew formula for ocid — the single source of truth. `just packaging
# brew` and `just ship publish-release` copy it into the tap
# (Formula/ocid.rb), filling url/sha256.
class Ocid < Formula
  desc "Local-first, peer-to-peer distribution of OCI container images powered by iroh"
  homepage "https://github.com/safonas/ocid"
  url "https://github.com/safonas/ocid/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8e3ded24473aeba3584c445991cc409e3729072a7bde2d97dba4d9ff453e2309"
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
