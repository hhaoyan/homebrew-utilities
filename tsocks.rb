# original code is from https://github.com/Anakros/homebrew-tsocks/blob/master/tsocks.rb

require 'formula'
 
class Tsocks < Formula
  # The original is http://tsocks.sourceforge.net/
  # This GitHub repo is a maintained fork with OSX support
  homepage 'https://github.com/hhaoyan/tsocks'
  head 'https://github.com/hhaoyan/tsocks.git'
 
  depends_on 'autoconf' => :build if MacOS::Xcode.version.to_f >= 4.3
 
  def install
    system "autoconf", "-v"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-conf=#{config_file}"
 
    inreplace("tsocks") { |bin| bin.change_make_var! "LIBDIR", lib }
 
    system "make"
    system "make install"
 
    etc.install "tsocks.conf.simple.example" => "tsocks.conf" unless config_file.exist?
    puts 'Note: On macOS, some binaries are marked restricted and cannot be wrapped by tsocks.'
  end
 
  def test
    puts 'Your current public ip is:'
    ohai `curl -sS ifconfig.me 2>&1`.chomp
    puts "If your correctly configured #{config_file}, this should show the ip you have trough the proxy"
    puts 'Your ip through the proxy is:'
    ohai `tsocks curl -sS ifconfig.me 2>&1`.chomp
  end
 
  def config_file
    etc / 'tsocks.conf'
  end
end
