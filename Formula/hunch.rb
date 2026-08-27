class Hunch < Formula
  include Language::Python::Virtualenv

  desc "Drive your Mac focus-free over MCP: OS APIs, AppleScript, CDP, and Accessibility"
  homepage "https://github.com/prithviseran/hunch-mcp"
  url "https://files.pythonhosted.org/packages/8d/7f/eefe142fd60dc8d6baddfab84392cb99cb9db577838729fe06d42b0656e5/hunch_sdk-0.6.2.tar.gz"
  sha256 "a30e3aa01b6e24181efddc166fbf29f060acb5194cb54fb78d5edb5b7a5978ab"
  license "Apache-2.0"

  depends_on :macos
  depends_on "python@3.13"
  depends_on "terminal-notifier" # notifications wear the Hunch logo (osascript can't)

  def install
    virtualenv_create(libexec, "python3.13")
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
