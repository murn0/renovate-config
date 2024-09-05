# レシピをリスト表示
default:
    @just --list

# GitHubにリリースDraftを作成
release:
    @nix run .#release
