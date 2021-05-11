class MavenlinkDev < Formula
  desc "Mavenlink Development Environment"
  homepage "https://github.com/mavenlink"
  url "https://github.com/plainprogrammer/homebrew-mavenlink/raw/main/files/empty.tgz"
  version "0.1"
  sha256 "ddb89a76e73dde81e35bbc3112ed949c29cf569cbd89440360646b611b3ab5e1"
  revision 1

  depends_on "autoconf"
  depends_on "automake"
  depends_on "cmake"
  depends_on "coreutils"
  depends_on "git"
  depends_on "git-lfs"
  depends_on "gpg"
  depends_on "imagemagick@6"
  depends_on "libksba"
  depends_on "libtool"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "libyaml"
  depends_on "memcached"
  depends_on "nginx"
  depends_on "percona-toolkit"
  depends_on "pkg-config"
  depends_on "plainprogrammer/mavenlink/redis"
  depends_on "readline"

  def install
    # No-Op
  end
end
