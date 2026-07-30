class Hunch < Formula
  include Language::Python::Virtualenv

  desc "Drive your Mac focus-free over MCP: OS APIs, AppleScript, CDP, and Accessibility"
  homepage "https://github.com/prithviseran/hunch-mcp"
  url "https://files.pythonhosted.org/packages/b2/af/c7311d48f62f1e5dc4a34e7b338d448752b3afcbcb51a826f48f9351bb2c/hunch_sdk-0.5.3.tar.gz"
  sha256 "1b6d4669d47f71555ab59d1315f7019c5b591f2ae9c9a272c4fc7880f094631d"
  license "Apache-2.0"

  depends_on :macos
  depends_on "python@3.13"
  depends_on "terminal-notifier"   # notifications wear the Hunch logo (osascript can't)

  def install
    venv = virtualenv_create(libexec, "python3.13")
    # pip resolves the deps (mcp, websocket-client, pyobjc frameworks) from PyPI so
    # pyobjc arrives as prebuilt wheels — compiling its sdists needs Xcode CLT and
    # takes far longer than everything else combined.
    system libexec/"bin/python", "-m", "pip", "install", "--quiet", buildpath.to_s
    bin.install_symlink libexec/"bin/hunch"
  end

  def caveats
    <<~EOS
      One-time setup (macOS permission grants + browser profile):
        hunch setup
        hunch doctor
        hunch connect claude-desktop   # or: claude-code, cursor

      macOS trust attaches to the app that RUNS the server (your MCP host),
      not to hunch itself — `hunch setup` walks you through it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hunch --version")
  end
end
