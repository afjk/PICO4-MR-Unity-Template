# Meta OpenXR パッチ適用手順

Meta 提供の `com.unity.xr.meta-openxr` パッケージに対する独自修正はライセンス上そのままリポジトリへ含められないため、以下の手順でローカルにパッチを適用してください。

## 前提

- Unity で一度プロジェクトを開き、`Library/PackageCache` に `com.unity.xr.meta-openxr@2.3.0`（または使用しているバージョン）がダウンロードされていること。
- `bash` と `git` が利用可能な環境であること。

## 手順

1. プロジェクトルートで以下のスクリプトを実行します。
   ```bash
   tools/meta-openxr/apply_patch.sh
   ```
2. スクリプトは `Library/PackageCache` から `Packages/com.unity.xr.meta-openxr` へパッケージをコピーし、`patches/meta-openxr-passthrough.patch` を適用します。
3. 実行後に Unity を再起動するか、`Package Manager` ウィンドウを開いてリコンパイルをトリガーすると、パッチ済み SDK が利用可能になります。

パッチの内容はコミット `14f2fac85dc46cce4881a9a146fdc2aa9c04cd45` のものと同等で、パススルー初期化の安定化と診断ログの追加を行います。
