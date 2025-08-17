# DemoKit(UIKit)

- 패턴: **MVC**
- 의존성: 외부 라이브러리 1
  - SDWebImage
- 테스트: Unit + UI 테스트 샘플 포함
- Xcode : Version 16.4 (16F6)
- Minimum Deployments : 15.0 

## 구조
```
Application/                             # 앱 라이프사이클
  ├─ AppDelegate.swift
  └─ AppDelegate+Extension.swift

UI/
  ├─ Common/
  │   └─ WebView/                       # 공통 웹뷰 컴포넌트
  │       ├─ WebView.swift
  │       ├─ WebViewController.swift
  │       └─ WebPopupViewController.swift
  ├─ Storyboards/
  │   ├─ Splash/
  │   │   └─ Splash.storyboard
  │   └─ Main/
  │       └─ Main.storyboard
  ├─ Controllers/
  │   ├─ Splash/
  │   │   └─ SplashViewController.swift  # 탈옥/네트워크 체크 후 라우팅
  │   └─ Main/
  │       ├─ MainViewController.swift    # 컴포지셔널 레이아웃 섹션 구성
  │       ├─ Cells/
  │       │   ├─ ProductCell.swift(.xib)
  │       │   └─ BannerCell.swift(.xib)
  │       └─ Reusable/
  │           ├─ HeaderReusableView.swift(.xib)
  │           └─ BannerFooterReusableView.swift(.xib)
  └─ Extensions/
      └─ Extensions.swift                # 공통 확장(문자열→URL, 가격 포맷 등)

Router/                                   # 네트워크/모델 로딩
  ├─ APIRouter.swift
  └─ Model/
      ├─ ProductModel.swift              # Product + 계산 프로퍼티
      ├─ ProductLoader.swift             # 로컬/원격 로더
      └─ products.json                   # 데모 데이터(모델 폴더에 보관)

Utils/
  ├─ Base/
  │   ├─ BaseViewController.swift
  │   └─ BaseCustomView.swift
  ├─ Helper/
  │   └─ GeneralHelper.swift
  ├─ Extensions/
  │   └─ Extensions.swift                # (UI 폴더 외 공용 확장 모음)
  └─ Tools/                              # 기타 유틸/툴 모듈

Resource/
  ├─ Icon/
  │   └─ Assets.xcassets                 # 앱 아이콘/이미지 에셋
  ├─ Font/
  │   └─ NotoSansKR/                     # 커스텀 폰트 번들
  ├─ Color/
  │   └─ Colors.colorset                 # 컬러 에셋
  ├─ LaunchScreen.storyboard
  └─ Info.plist

Tests/
  ├─ DemoKitTests/                       # Unit Test (파싱)
  │   └─ DemoKitTests.swift
  └─ DemoKitUITests/                     # UI Test (리스트)
      ├─ DemoKitUITests.swift
      └─ DemoKitUITestsLaunchTests.swift
```

## 실행
1) 의존성 설치 : pod install --repo-update
2) 워크스페이스 열기 : DemoKit.xcworkspace
3) Scheme : DemoKit > Destination은 임의의 시뮬레이터

## 기능
- 배너 1:1, 3초 오토 슬라이드, 우하단 푸터 `현재/전체`
- 타임세일(가로 페이징 2개), 2열 그리드, 1열 리스트(이미지 큼)
- 가격 표시는 할인 유/무에 따른 Attributed 스타일(333/666/999 규칙)
- 상세 웹뷰 뒤로가기 스크립트 캐치, popController 적용
- Logo(CI)홈페이지, AppIcon(구글)
