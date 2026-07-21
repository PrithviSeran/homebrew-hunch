class Hunch < Formula
  include Language::Python::Virtualenv

  desc "Drive your Mac focus-free over MCP: OS APIs, AppleScript, CDP, and Accessibility"
  homepage "https://github.com/prithviseran/hunch-mcp"
  url "https://files.pythonhosted.org/packages/7e/86/24a64248a0afa6bf55d021cf6dfd0fe8ef7b7e5916dd3d20565e62912315/hunch_sdk-0.3.1.tar.gz"
  sha256 "858f5e850df958db4f14e7750bad4b4caf3c7d04ddf3f1364c31374f2670b211"
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
