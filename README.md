# hasura-mssql-liff

## 前提

- dockerおよびdocker composeが利用可能
- hasura cliが利用可能
  - [インストール方法](https://hasura.io/docs/latest/hasura-cli/install-hasura-cli/)

## 1. 環境構築

以下をやることでhasura consoleが起動する。

```shell
cd to/this/repo

docker compose up
cd hasura

hasura metadata apply
hasura migrate apply --all-databases
hasura md reload

hasura console
```

## 2. トークン取得

以下のページでLINEにログインし、IDトークンを取得する。

[LIFF Playground](https://liff-playground.netlify.app/>)

## 3. IDトークンをヘッダーにセット

hasura console上でトークンを以下のようにセットする。

- KEY: Authorization
- VALUE: Bearer <2で取得したidトークン>

## 4. ユーザーIDを控える

2で取得したidトークンの中に含まれるトークン中に含まれる`sub`というキーの値がユーザーIDとなる。これを控えておく。

idトークンの中身を見るには以下のサイトを利用するとよい。

[jwt.io](https://jwt.io/)

## 5. 管理者権限でユーザーを作成する

`x-hasura-admin-secret` ヘッダーにチェックを入れることで、管理者権限で任意のGraphQLクエリが発行可能になる。

その上で、以下のクエリを実行し、ユーザーを作成する。

```graphql
mutation AdminAddUser {
  insert_user_one(
    object: { id: "{ユーザーID}", name: "テストユーザー" }
  ) {
    id
    name
  }
}
```

## 6. IDトークンの権限でユーザー情報を取得する

`x-hasura-admin-secret` ヘッダーのチェックを外し、`Authorization`ヘッダーにチェックを入れることで、IDトークン中のユーザーIDに関するデータ取得しかできないクエリを発行できる。

その上で、以下のクエリを発行し、自分のデータしかとれていないことを確認できる。

```graphql
query GetMe {
  user {
    id
    name
    deleted_at
  }
}
```
