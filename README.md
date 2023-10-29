# 오단완 - 간헐적 단식 시간 측정 타이머 앱⏱️

- Minimum Deployments: iOS 16.0 <br>
- Development Period: 2023.09.25 ~ (진행중) <br>
- Role: iOS 개발, 기획, 디자인 담당 <br>

<br>

## Screenshot
<p align="center"><img src="https://github.com/JongHoooon/TodayFastComplete/assets/98168685/59a209a9-afd3-46dc-b285-fe3bb00df314"></p>



<br>

## Architecture
- MVVM-C
- Clean Architecture

<br>

<p align="center"><img width="1271" alt="image" src="https://github.com/JongHoooon/TodayFastComplete/assets/98168685/b4436197-74b1-44be-af96-24db3a2b7a48"></p>

<p align="center"><img width="1200" alt="image" src="https://github.com/JongHoooon/TodayFastComplete/assets/98168685/bd7f5c18-9225-4037-98c9-bd5e9fda37f1"></p>


<br>

## Tech Stack
- UIKit, Compositonal Layout, Diffable Datasource, UIBezierPath, Local Notification, OSLog
- RxSwift, Realm, SnapKit, FSCalendar

<br>
  
## Core Feature
- 단식 시간을 설정해 **단식 시간과 식사 시간을 모니터링**할 수 있습니다.
- 단식 시작/종료 시간을 **local notification을 통해 확인**할 수 있습니다.
- 단식 완료 후 **단식과 몸무게를 기록**할 수 있습니다.

<br>

## Description

- **타이머 화면**
  - **UIBezierPath** 기반 custom progress view 구현
  - **RxSwift timer operator** 기반 타이머 stream 생성
- **타이머 설정 화면**
  - **Compositional Layout**
  -  **Diffable Datasource** 기반 collection view 구현
- **기록 화면**
  - **UIBazierPath** 기반 **custom FSCalendar cell** 구현
  - custom **UISegmentedControl, UIPageViewController** 기반 화면 구성
  - **Delegate Proxy** 사용해 FSCalendar의 **delegate 메소드 rx로 확장**

- **Coordinator** 기반 화면 흐름 제어, local notification handling, 의존성 주입
- OSLog 사용해 로그 모니터링

<br>

## Troubleshooting

- [RxSwift 기반 Realm 비동기 처리](https://velog.io/@qnm83/RxSwift-%EA%B8%B0%EB%B0%98-Realm-%EB%B9%84%EB%8F%99%EA%B8%B0-%EC%B2%98%EB%A6%AC)
- [nesting closure에서 메모리 누수 발생](https://velog.io/@qnm83/nesting-closure%EC%97%90%EC%84%9C-%EB%B0%9C%EC%83%9D%ED%95%9C-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%88%84%EC%88%98)
- [RxSwift 사용시 unowned 사용해 캡처리스트 정의](https://velog.io/@qnm83/RxSwift-%EC%82%AC%EC%9A%A9%EC%8B%9C-unowned-%EC%82%AC%EC%9A%A9%ED%95%B4-%EC%BA%A1%EC%B2%98%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EC%A0%95%EC%9D%98)
