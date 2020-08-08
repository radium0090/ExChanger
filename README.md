# Realtime Currency Exchange calculator  - ExChanger iOS Application

---

## Installation

- インストール手順		

### Unzip

- ファイルのUnzip

### Setup

- CLIでセットアップする

> update and install pod package first

```shell
$ pod install
```

> プロジェクトディレクトリにてXCODEで`GitHubDM.xcworkspace`を開く

> プロジェクトビルドし、シミュレーターで実行する

---

## Usage

- アーキテクチャ

> 全体のアーキテクチャイメージ：
* MVVMベース

> ディレクトリ構造(イメージ)

```
project
├── Models
├── Views
├────── ViewController
├───────── History
├───────── CurrencyList
├───────── ConvercyConvert
├────── StoryBoard
├── ViewModels
├── Data
├────── Service
├────── LocalStorage
├── Common
├────── Utility
├────── Extensions
├── other root files
└── Assets

```

> 概要：
* プロジェクト全体はMVVMをベースとしたアーキテクチャを採用した、さらにClean Architectureの概念を導入しました。データバインド部分はRxSwiftを利用。データ保存はCoreDataを利用しました。	

> 機能概要：
* 為替計算：リアルタイムで為替レート取得する、変換元と変換先為替の選択によって実際入力した値を元に計算を行う
* 計算履歴：為替計算の履歴一覧を表示する
* 為替レートリスト：変換元を選択し、あらゆる為替のレートをリストで表示する（デフォルトはUSD、単位は1とする）

> 今後の課題

* UI改善
* * Tableview調整、レイアウト、カラーリング、フォント・スタイル調整、ダークモード対応など

* アーキテクチャ改善
* * プロジェクトの拡大によるDomainの追加及びUseCaseの導入

* パフォーマンス向上		
* * StoryBoardからSwiftUIへ変換するのをチャレンジ、またobservableobjectを利活用
* * 機能と遷移先ページの増加に伴うナビゲーションRouterの導入

* 保守
* * マネタイズ、プロモーション、AdMob、ASO、ストア公開、キーワード選定などの運営を行う	

* 同仕様のAndroidアプリを作成

---

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
