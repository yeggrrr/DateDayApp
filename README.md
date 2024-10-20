# 🧸 DateDay(공방 리뷰 앱) 🧸
- LSLP(Light Service Level Project)
- 최소 버전: iOS 16.0
  
<br>

## 📷 ScreenShot
|로그인 & 회원가입|메인 & 검색|리뷰 디테일|내 게시글|
|:-:|:-:|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/c4088557-d793-4337-bade-a0db24b57e74" width="150"/>|<img src="https://github.com/user-attachments/assets/3061729d-cd37-4925-a48a-ce07463c0635" width="150"/>|<img src="https://github.com/user-attachments/assets/fcd253fe-1249-47e0-9f91-406a8a849afd" width="150"/>|<img src="https://github.com/user-attachments/assets/635096eb-c81d-48d5-9351-97b497bd5d76" width="150"/>|
|프로필 편집|관심 목록|게시글 작성|공방 예약하기|
|<img src="https://github.com/user-attachments/assets/2fd7f451-691b-4eb3-b2c2-dc4d1c84d1c3" width="150"/>|<img src="https://github.com/user-attachments/assets/8b86869a-10e0-4144-8d51-be718b35658e" width="150"/>|<img src="https://github.com/user-attachments/assets/f725f1e5-4feb-4137-87fb-0fe7b26b8f43" width="150"/>|<img src="https://github.com/user-attachments/assets/1afef906-31da-472a-968f-348670793c60" width="150"/>|

<br>

## 📌 앱 설명 📌
- 방문했던 공방의 상세 리뷰를 남기고 공유하는 앱
- 다양한 공방 리뷰를 통해 체험하고 싶은 공방을 찾고, 예약하는 앱
  
<br>

## ⏰ 개발 기간 ⏰
- 기획: 2024.08.14
- 집중 개발: 2024.08.15 ~ 2024.09.01
- 19일간 진행

<br>

## 👤 개발 인원 👤
- 개인 프로젝트

<br>

## 📚 기술 스택 📚
- UIKit, MVVM
- RxSwift, Alamofire, SnapKit
- Webkit

<br>

## 📡 API 📡
🌱 SeSAC 🌱에서 제공해준 LSLP API Server 사용
<br>
- 회원인증: 회원가입 / 이메일 중복 확인 / 로그인 / 탈퇴
- 토큰: AccessToken 갱신
- 포스트: 이미지 업로드 / 포스트 작성 / 포스트 조회 / 특정 포스트 조회 / 포스트 삭제 / 유저별 작성한 포스트 조회
- 좋아요1 & 좋아요2: 좋아요 및 취소 / 좋아요한 포스트 조회
- 프로필: 내 프로필 조회 / 내 프로필 수정
- 해시태그: 해시태그 검색
- 결제: 포트원(Portone) 설치 / 결제 영수증 검증 / 결제 내역 리스트

<br>

## 🔥 구현 🔥
- Confluence 기획서를 바탕으로 서버 통신 프로젝트
- Alamofire를 추상화한 TargetType을 활용하여 Router 패턴으로 네트워크 통신
- Portone 통합 결제 API를 통한 결제 시스템 로직 구현
- 공통 Toast를 CustomUI로 구현


<br>

## ⚽️ 트러블 슈팅 ⚽️
- RxSwift - CombineLatest 사용으로 인한 out of range error
    - 셀을 클릭하여 데이터 배열에서 해당 목록을 삭제하는 로직에서 새로운 데이터 배열이 업데이트 되면서 삭제된 인덱스가 호출되어 생긴 문제
    - 데이터 배열과 인덱스를 CombineLatest로 관리하던 코드를 ModelSelected를 사용하여 리팩토링

<br>
 
- Single를 활용한 네트워크 통신
    - Observable로 구현했던 네트워크 통신 코드에서 요청을 보낼때마다 disposed되지 않고 스트림이 유지되었던 문제
    - Single<Result>를 활용하여 Stream 종료 처리를 통한 메모리 누수 관리 및 Enum을 활용해 API별로 StatusCode에 따른 Error 핸들링
<br>

- RxSwift 이중 Subscribe
    - RxSwift의 flatMap Operator를 활용해 이중 삼중 구독문을 리팩토링해서 메모리 누수와 스트림 안정성 확보
 
<br>

- Router 패턴 활용
    - 20개의 API 통신을 위해 Router 패턴을 활용해서 코드 간결화 및 보일러 플레이트 감소로 유지보수성 증가

## 📝 회고 📝
- LSLP 프로젝트를 처음 진행하면서 로그인 및 회원가입 로직 등을 기획하면서 서비스적으로 어떻게 구현해야 사용자에게 자연스럽게 다가올지 고민해보고 적용했던 경험이었음
- Portone 결제 기능을 구현하면서 결제 요청부터 영수증 검증까지 결제 플로우에 대해서 공부할 수 있었던 경험이었음
