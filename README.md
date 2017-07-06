# RIT - RIDI Inital Test

[Ruby](https://www.ruby-lang.org/)로 작성된 Micro web framework인 [Sinatra](http://www.sinatrarb.com/)와 ORM인 [DataMapper](http://datamapper.org/)를 이용하여 개발되었습니다.



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
  $ gem install bundler
  ```

* Database

  * PostgreSQL과 SQLite가 사용 가능합니다. (Prouduction 환경에서는 PostgreSQL 사용을 권장합니다)

  * DataMapper가 필요한 테이블들을 자동으로 생성하여 주므로 별도의 테이블 생성은 필요하지 않습니다. 스키마 정보는 [이 코드](src/model.rb)를 참고하세요.

  * 개발 환경에서는 미리 준비된 Sample SQLite database file을 복사하여 사용할 수도 있습니다.

    ```sh
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

Heroku의 heroku/ruby buildpack을 이용한 배포에 최적화 되어 있으며 Repository 연결 후 환경 변수 설정 외의 별도 설정은 필요하지 않습니다.

Apache를 사용하고 싶다면 [Passenger](https://www.phusionpassenger.com/) 등을 이용해 연동 할 수 있습니다. [관련 문서](https://www.phusionpassenger.com/library/walkthroughs/start/ruby.html)를 참고하세요.

