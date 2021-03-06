class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-3.2.13.tar.gz"
  sha256 "862979c9853fdb1d275d9eb9077f34621596fec1843e3e7f2e2f09ce09a387ba"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "d016b698688c41f3a1157f61aaa44e4686cab2806ba8bb6b09a2d1f46eed255c"
    sha256 cellar: :any_skip_relocation, catalina:    "e557bee10881f773cfb59d593a874f628b4f7d7239acea2d9cfc1ab394619fba"
    sha256 cellar: :any_skip_relocation, mojave:      "b61b4867149efc9201c51c984a55edcd0809e8a045b372c4bbf00c3b119afea4"
    sha256 cellar: :any_skip_relocation, high_sierra: "78a359ac74a02868ba481ae740d1d5046a89fc2e07020ddee6c73e491a162247"
  end

  patch do
    url "https://gist.githubusercontent.com/plainprogrammer/5d064c4703e99fedc084a0a8c95aef5b/raw/d5aff3266ea702fad6386ed95edbb5979e855344/redis-3.2-arm64.patch"
    sha256 "571d00572ab23f73057c187b2eb616b0ed672b937c51069ed80d12782db6807a"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/redis@3.2/bin/redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/redis-server</string>
            <string>#{etc}/redis.conf</string>
            <string>--daemonize no</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/redis.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/redis.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
