# RIT - RIDI Inital Test

## 제공 기능

* 문제 풀기 및 자동 채점 기록
* 문제 세트 및 문제 카테고리 기능 지원
* Admin (`/admin`)
  * 채점 결과(카테고리별 점수 및 총점) 확인
  * 문제별 정답률 확인 및 문제 편집



## 개발 환경 설정

### Requirements

* Ruby 2.3.x

* Bundler

  ```sh
  $ gem isntall bundler
  ```

* Postgresql database

  * 개발 환경에서는 SQLite도 사용 가능하며 Sample SQLite database file을 복사하여 사용할 수동 있습니다.

    ```
    $ cp development.db.sample development.db
    ```

### Install gems and run local server

```sh
$ bundle install
$ rackup
```

### 환경 변수 (Ruby ENV)

- DATABASE_URL : 설정하지 않을 경우 default는 `development.db` file 입니다.
- ADMIN_PASSWORD : Admin 페이지 접속을 위한 비밀번호 입니다. 설정하지 않을 경우 default는 `admin` 입니다.



## 배포

Heroku를 이용한 배포에 최적화 되어 있으며 Repository 연결 후 환경 변수 설정 외의 별도 설정은 필요하지 않습니다.

