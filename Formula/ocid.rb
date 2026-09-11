class Ocid < Formula
  desc "Local-first, peer-to-peer distribution of OCI container images powered by iroh"
  homepage "https://github.com/safonas/ocid"
  url "https://github.com/safonas/ocid/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "753909c3cf3ac107c9102b0186786214d2939b689cb41f48be3581dd26e3a9c7"
  license "GPL-3.0-or-later"
  head "https://github.com/safonas/ocid.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ocid")
    system "cargo", "install", *std_cargo_args(path: "crates/ocictl")
    system "cargo", "install", *std_cargo_args(path: "crates/ocitop")
  end

  test do
    assert_match "ocid", shell_output("#{bin}/ocid --version")
    assert_match "ocictl", shell_output("#{bin}/ocictl --version")
  end
end
