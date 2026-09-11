class Ocid < Formula
  desc "Local-first, peer-to-peer distribution of OCI container images powered by iroh"
  homepage "https://github.com/safonas/ocid"
  url "https://github.com/safonas/ocid/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9031af40fade0d77953242b1b927b36069fd2eda400f2fd4927b884cd12d3fef"
  license "GPL-3.0-or-later"
  head "https://github.com/safonas/ocid.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ocid")
    system "cargo", "install", *std_cargo_args(path: "crates/ocictl")
  end

  test do
    assert_match "ocid", shell_output("#{bin}/ocid --version")
    assert_match "ocictl", shell_output("#{bin}/ocictl --version")
  end
end
