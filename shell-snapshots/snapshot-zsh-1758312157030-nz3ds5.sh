# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
# Check for rg availability
if ! command -v rg >/dev/null 2>&1; then
  alias rg='/Users/natedamstra/.nvm/versions/node/v22.11.0/lib/node_modules/\@anthropic-ai/claude-code/vendor/ripgrep/x64-darwin/rg'
fi
export PATH=/Users/natedamstra/.elan/bin\:/Users/natedamstra/.nvm/versions/node/v22.11.0/bin\:/Library/Frameworks/Python.framework/Versions/3.12/bin\:/Library/Frameworks/Python.framework/Versions/3.9/bin\:/usr/local/bin\:/System/Cryptexes/App/usr/bin\:/usr/bin\:/bin\:/usr/sbin\:/sbin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin\:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin\:/usr/local/share/dotnet\:~/.dotnet/tools\:/usr/local/go/bin\:/Users/natedamstra/.elan/bin\:/Users/natedamstra/.nvm/versions/node/v22.11.0/bin\:/Library/Frameworks/Python.framework/Versions/3.12/bin\:/Library/Frameworks/Python.framework/Versions/3.9/bin\:/Users/natedamstra/.local/bin\:/Users/natedamstra/.foundry/bin
