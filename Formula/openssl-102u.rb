class Openssl102u < Formula
  desc "OpenSSL version 1.0.2u for Ruby 2.3"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz"
  sha256 "ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16"
  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  patch do
    url "https://gist.githubusercontent.com/plainprogrammer/35b6e6be7dd42e1293914afdcca2ffe5/raw/057d4f02a0f5480523511ee8f45ba87feb08d220/openssl-1.0.2u-arm64-macos.patch"
    sha256 "d6f226b966e1012af36a1fd48a73530ce5f658509292f6dbed6e691692978100"
  end

  def openssldir
    etc/"openssl-102u"
  end
  
  def install
    configure_args = %W[--openssldir=#{openssldir} no-zlib]
    
    on_macos do
      configure_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
      configure_args += %W[no-asm shared] if Hardware::CPU.arm?
    end
    
    on_linux do
      configure_args += (ENV.cflags || "").split
      configure_args += (ENV.cppflags || "").split
      configure_args += (ENV.ldflags || "").split
      configure_args << "enable-md2"
      
      if Hardware::CPU.intel?
        configure_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
      elsif Hardware::CPU.arm?
        configure_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
      end
    end
    
    system "./configure", "--prefix=#{prefix}", *configure_args
    system "make", "clean"
    system "make", "depend", "CC=/usr/bin/cc"
    system "make", "CC=/usr/bin/cc"
    system "make", "test", "CC=/usr/bin/cc"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl", "CC=/usr/bin/cc"
  end
end
